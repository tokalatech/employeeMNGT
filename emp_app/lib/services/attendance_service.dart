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
  static const String breakCollection = 'attendance_breaks';

  String get _uid {
    final uid = _auth.currentUserId;

    if (uid == null) {
      throw StateError('No authenticated user.');
    }

    return uid;
  }

  // ============================================================
  // DATE / TIME HELPERS
  // ============================================================

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';

  String _timeKey(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
          '${value.minute.toString().padLeft(2, '0')}';

  DateTime _parseTime(String value) {
    final parts = value.split(':');
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  DateTime _parseDate(String value) {
    final parts = value.split('-');

    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // ATTENDANCE
  // ============================================================

  Future<AttendanceRecord?> getAttendanceForDate(
      DateTime date,
      ) async {
    final snapshot = await _firestore
        .collection(attendanceCollection)
        .where('employeeId', isEqualTo: _uid)
        .where('date', isEqualTo: _dateKey(date))
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return AttendanceRecord.fromMap({
      ...doc.data(),
      'id': doc.id,
    });
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

    records.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return records;
  }

  Stream<AttendanceRecord?> watchToday() {
    return _firestore
        .collection(attendanceCollection)
        .where('employeeId', isEqualTo: _uid)
        .where(
      'date',
      isEqualTo: _dateKey(DateTime.now()),
    )
        .limit(1)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.isEmpty
          ? null
          : AttendanceRecord.fromMap({
        ...snapshot.docs.first.data(),
        'id': snapshot.docs.first.id,
      }),
    );
  }

  // ============================================================
  // SHIFT SETTINGS
  // ============================================================

  static const int shiftStartHour = 9;
  static const int shiftStartMinute = 0;
  static const int lateGraceMinutes = 15;

  // ============================================================
  // CLOCK IN
  // ============================================================

  Future<String> clockIn({
    String? notes,
  }) async {
    final now = DateTime.now();
    final date = _dateKey(now);

    final existing = await getAttendanceForDate(now);

    if (existing?.clockIn != null) {
      throw StateError(
        'Already checked in today.',
      );
    }

    final shiftStart = DateTime(
      now.year,
      now.month,
      now.day,
      shiftStartHour,
      shiftStartMinute,
    ).add(
      const Duration(
        minutes: lateGraceMinutes,
      ),
    );

    final status = now.isAfter(shiftStart)
        ? 'Late'
        : 'Present';

    final profile = await _userService.getCurrentUser();

    final id = existing?.id ??
        _firestore.newId(
          attendanceCollection,
        );

    await _firestore.setDocument(
      '$attendanceCollection/$id',
      {
        'id': id,
        'employeeId': _uid,
        'managerId': profile?.managerId ?? '',
        'date': date,
        'status': status,

        // Main attendance times.
        'clockIn': _timeKey(now),
        'clockOut': null,

        // Main working duration.
        'totalHours': null,

        // Break total is stored separately as a summary.
        'breakDuration': null,

        'notes': notes,
        'isCorrectionRequested': false,

        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    return id;
  }

  // ============================================================
  // CLOCK OUT
  // ============================================================

  Future<void> clockOut({
    String? notes,
  }) async {
    final now = DateTime.now();

    final existing = await getAttendanceForDate(now);

    if (existing == null || existing.clockIn == null) {
      throw StateError(
        'You have not checked in today.',
      );
    }

    if (existing.clockOut != null) {
      throw StateError(
        'Already checked out today.',
      );
    }

    // ----------------------------------------------------------
    // IMPORTANT:
    // Employee cannot clock out while a break is active.
    // ----------------------------------------------------------

    final activeBreak = await _getActiveBreak();

    if (activeBreak != null) {
      throw StateError(
        'Please end your active break before clocking out.',
      );
    }

    // ----------------------------------------------------------
    // Clock-in -> clock-out calculation is intentionally NOT
    // reduced by break duration.
    //
    // Example:
    //
    // Clock In   = 09:00
    // Lunch      = 13:00 - 14:00
    // Clock Out  = 18:00
    //
    // totalHours = 09:00
    // breakDuration = 01:00
    //
    // They remain separate.
    // ----------------------------------------------------------

    final clockIn = _parseTime(
      existing.clockIn!,
    );

    final duration = now.difference(clockIn);

    final totalHours = _formatDuration(
      duration,
    );

    await _firestore.updateDocument(
      '$attendanceCollection/${existing.id}',
      {
        'clockOut': _timeKey(now),
        'totalHours': totalHours,
        'status': 'Present',

        if (notes != null)
          'notes': notes,

        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  // ============================================================
  // BREAKS
  // ============================================================

  Future<String> startBreak({
    required BreakType type,
  }) async {
    final now = DateTime.now();

    final attendance = await getAttendanceForDate(now);

    if (attendance == null ||
        attendance.clockIn == null) {
      throw StateError(
        'You must clock in before starting a break.',
      );
    }

    if (attendance.clockOut != null) {
      throw StateError(
        'You have already clocked out today.',
      );
    }

    final existingBreak = await _getActiveBreak();

    if (existingBreak != null) {
      throw StateError(
        'A break is already active.',
      );
    }

    final profile = await _userService.getCurrentUser();

    final id = _firestore.newId(
      breakCollection,
    );

    await _firestore.setDocument(
      '$breakCollection/$id',
      {
        'id': id,
        'employeeId': _uid,
        'managerId': profile?.managerId ?? '',
        'attendanceId': attendance.id,
        'date': _dateKey(now),

        'breakType': breakTypeToString(type),

        'breakStart': _timeKey(now),
        'breakEnd': null,

        'duration': null,

        'isActive': true,

        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    return id;
  }

  // ============================================================
  // GET ACTIVE BREAK
  // ============================================================

  Future<AttendanceBreak?> _getActiveBreak() async {
    final snapshot = await _firestore
        .collection(breakCollection)
        .where(
      'employeeId',
      isEqualTo: _uid,
    )
        .where(
      'date',
      isEqualTo: _dateKey(DateTime.now()),
    )
        .where(
      'isActive',
      isEqualTo: true,
    )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return AttendanceBreak.fromMap({
      ...doc.data(),
      'id': doc.id,
    });
  }

  // ============================================================
  // END BREAK
  // ============================================================

  Future<void> endBreak() async {
    final now = DateTime.now();

    final activeBreak = await _getActiveBreak();

    if (activeBreak == null ||
        activeBreak.breakStart == null) {
      throw StateError(
        'No active break found.',
      );
    }

    final breakStart = _parseTime(
      activeBreak.breakStart!,
    );

    final duration = now.difference(
      breakStart,
    );

    final durationText = _formatDuration(
      duration,
    );

    await _firestore.updateDocument(
      '$breakCollection/${activeBreak.id}',
      {
        'breakEnd': _timeKey(now),
        'duration': durationText,
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    // Update only the break summary.
    //
    // This DOES NOT modify clockIn,
    // clockOut, or totalHours.
    await _updateTotalBreakDuration();
  }

  // ============================================================
  // TOTAL BREAK DURATION
  // ============================================================

  Future<void> _updateTotalBreakDuration() async {
    final attendance = await getAttendanceForDate(
      DateTime.now(),
    );

    if (attendance == null) {
      return;
    }

    final snapshot = await _firestore
        .collection(breakCollection)
        .where(
      'employeeId',
      isEqualTo: _uid,
    )
        .where(
      'date',
      isEqualTo: _dateKey(DateTime.now()),
    )
        .get();

    Duration total = Duration.zero;

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final duration = data['duration'];

      if (duration is String &&
          duration.contains(':')) {
        final parts = duration.split(':');

        final hours =
            int.tryParse(parts[0]) ?? 0;

        final minutes =
            int.tryParse(parts[1]) ?? 0;

        total += Duration(
          hours: hours,
          minutes: minutes,
        );
      }
    }

    await _firestore.updateDocument(
      '$attendanceCollection/${attendance.id}',
      {
        'breakDuration': _formatDuration(total),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  // ============================================================
  // TODAY'S BREAKS
  // ============================================================

  Future<List<AttendanceBreak>> getTodayBreaks() async {
    final snapshot = await _firestore
        .collection(breakCollection)
        .where(
      'employeeId',
      isEqualTo: _uid,
    )
        .where(
      'date',
      isEqualTo: _dateKey(DateTime.now()),
    )
        .get();

    final breaks = snapshot.docs
        .map(
          (doc) => AttendanceBreak.fromMap({
        ...doc.data(),
        'id': doc.id,
      }),
    )
        .toList();

    breaks.sort(
          (a, b) => (a.breakStart ?? '')
          .compareTo(b.breakStart ?? ''),
    );

    return breaks;
  }

  // ============================================================
  // WATCH TODAY'S BREAKS
  // ============================================================

  Stream<List<AttendanceBreak>> watchTodayBreaks() {
    return _firestore
        .collection(breakCollection)
        .where(
      'employeeId',
      isEqualTo: _uid,
    )
        .where(
      'date',
      isEqualTo: _dateKey(DateTime.now()),
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => AttendanceBreak.fromMap({
          ...doc.data(),
          'id': doc.id,
        }),
      )
          .toList(),
    );
  }

  // ============================================================
  // ATTENDANCE CORRECTIONS
  // ============================================================

  Future<String> submitCorrection(
      AttendanceCorrectionRequest request,
      ) async {
    final id = request.id.isEmpty
        ? _firestore.newId(
      correctionCollection,
    )
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

    try {
      final attendance =
      await getAttendanceForDate(
        _parseDate(request.date),
      );

      if (attendance != null) {
        await _firestore.updateDocument(
          '$attendanceCollection/${attendance.id}',
          {
            'isCorrectionRequested': true,
            'updatedAt':
            FieldValue.serverTimestamp(),
          },
        );
      }
    } catch (_) {
      // Correction request already exists.
    }

    return id;
  }

  Future<List<AttendanceCorrectionRequest>>
  getMyCorrectionRequests() async {
    final snapshot = await _firestore
        .collection(correctionCollection)
        .where(
      'employeeId',
      isEqualTo: _uid,
    )
        .orderBy(
      'createdAt',
      descending: true,
    )
        .get();

    return snapshot.docs
        .map(
          (doc) =>
          AttendanceCorrectionRequest.fromMap({
            ...doc.data(),
            'id': doc.id,
          }),
    )
        .toList();
  }

}
