import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/attendance_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'user_service.dart';

class AttendanceService {
  AttendanceService({
    FirestoreService? firestoreService,
    AuthService? authService,
    UserService? userService,
  })  : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService(),
        _userService = userService ?? UserService();

  final FirestoreService _firestore;
  final AuthService _auth;
  final UserService _userService;
  static const String attendanceCollection = 'attendance';
  static const String correctionCollection = 'attendance_corrections';

  String get _uid {
    final uid = _auth.currentUserId;
    if (uid == null) throw StateError('No authenticated user.');
    return uid;
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<AttendanceRecord?> getAttendanceForDate(DateTime date) async {
    final snapshot = await _firestore.collection(attendanceCollection)
        .where('employeeId', isEqualTo: _uid)
        .where('date', isEqualTo: _dateKey(date))
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return AttendanceRecord.fromMap({...doc.data(), 'id': doc.id});
  }

  Future<List<AttendanceRecord>> getAttendanceHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection(attendanceCollection)
        .where('employeeId', isEqualTo: _uid);

    if (startDate != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: _dateKey(startDate),
      );
    }

    if (endDate != null) {
      query = query.where(
        'date',
        isLessThanOrEqualTo: _dateKey(endDate),
      );
    }

    final snapshot = await query.get();

    final records = snapshot.docs
        .map(
          (doc) => AttendanceRecord.fromMap({
        ...doc.data(),
        'id': doc.id,
      }),
    )
        .toList();

    // Sort locally instead of using Firestore orderBy().
    records.sort((a, b) => b.date.compareTo(a.date));

    return records;
  }

  Stream<AttendanceRecord?> watchToday() {
    return _firestore.collection(attendanceCollection)
        .where('employeeId', isEqualTo: _uid)
        .where('date', isEqualTo: _dateKey(DateTime.now()))
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isEmpty
        ? null
        : AttendanceRecord.fromMap({
      ...snapshot.docs.first.data(),
      'id': snapshot.docs.first.id,
    }));
  }

  static const int shiftStartHour = 9;
  static const int shiftStartMinute = 0;
  static const int lateGraceMinutes = 15;

  Future<String> clockIn({String? notes}) async {
    final now = DateTime.now();
    final date = _dateKey(now);
    final existing = await getAttendanceForDate(now);
    if (existing?.clockIn != null) throw StateError('Already checked in today.');

    final shiftStart = DateTime(
      now.year,
      now.month,
      now.day,
      shiftStartHour,
      shiftStartMinute,
    ).add(const Duration(minutes: lateGraceMinutes));

    final status = now.isAfter(shiftStart) ? 'Late' : 'Present';

    // Needed so managers can query team attendance by managerId.
    final profile = await _userService.getCurrentUser();

    final id = existing?.id ?? _firestore.newId(attendanceCollection);
    await _firestore.setDocument('$attendanceCollection/$id', {
      'id': id,
      'employeeId': _uid,
      'managerId': profile?.managerId ?? '',
      'date': date,
      'status': status,
      'clockIn': _timeKey(now),
      'clockOut': null,
      'totalHours': null,
      'breakDuration': null,
      'notes': notes,
      'isCorrectionRequested': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return id;
  }

  Future<void> clockOut({String? notes}) async {
    final now = DateTime.now();
    final existing = await getAttendanceForDate(now);
    if (existing == null || existing.clockIn == null) {
      throw StateError('You have not checked in today.');
    }
    if (existing.clockOut != null) throw StateError('Already checked out today.');

    final clockIn = _parseTime(existing.clockIn!);
    final duration = now.difference(clockIn);
    final totalHours = _formatDuration(duration);
    await _firestore.updateDocument('$attendanceCollection/${existing.id}', {
      'clockOut': _timeKey(now),
      'totalHours': totalHours,
      'status': 'Present',
      if (notes != null) 'notes': notes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> submitCorrection(
      AttendanceCorrectionRequest request,
      ) async {
    final id = request.id.isEmpty
        ? _firestore.newId(correctionCollection)
        : request.id;

    await _firestore.setDocument(
      '$correctionCollection/$id',
      {
        ...request.toMap(),
        'id': id,
        'employeeId': _uid,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      },
    );

    // Mark the attendance record as having a correction request.
    try {
      final attendance = await getAttendanceForDate(
        _parseDate(request.date),
      );

      if (attendance != null) {
        await _firestore.updateDocument(
          '$attendanceCollection/${attendance.id}',
          {
            'isCorrectionRequested': true,
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      }
    } catch (_) {
      // The correction request has already been created.
      // Don't fail the whole request just because
      // the attendance record could not be updated.
    }

    return id;
  }

  Future<List<AttendanceCorrectionRequest>> getMyCorrectionRequests() async {
    final snapshot = await _firestore.collection(correctionCollection)
        .where('employeeId', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => AttendanceCorrectionRequest.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<List<AttendanceRecord>> getTeamAttendance(String managerId, DateTime date) async {
    final snapshot = await _firestore.collection(attendanceCollection)
        .where('managerId', isEqualTo: managerId)
        .where('date', isEqualTo: _dateKey(date))
        .get();
    return snapshot.docs
        .map((doc) => AttendanceRecord.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  String _timeKey(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  DateTime _parseTime(String value) {
    final parts = value.split(':');
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  DateTime _parseDate(String value) {
    final parts = value.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
