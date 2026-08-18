import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/daily_report_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'storage_service.dart';
import 'user_service.dart';

class DailyReportService {
  DailyReportService({
    FirestoreService? firestoreService,
    AuthService? authService,
    UserService? userService,
    StorageService? storageService,
  }) : _firestore = firestoreService ?? FirestoreService(),
       _auth = authService ?? AuthService(),
       _userService = userService ?? UserService(),
       _storage = storageService ?? StorageService();

  final FirestoreService _firestore;
  final AuthService _auth;
  final UserService _userService;
  final StorageService _storage;

  static const String collectionName = 'daily_reports';

  String get _uid {
    final uid = _auth.currentUserId;

    if (uid == null) {
      throw StateError('No authenticated user.');
    }

    return uid;
  }

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // Future<String> uploadDailyReport({
  //   required Uint8List bytes,
  //   required String fileName,
  //   required String fileType,
  //   required int fileSize,
  //   required DateTime reportDate,
  //   String? description,
  // }) async {
  //   try {
  //     final uid = _uid;
  //
  //     // ------------------------------------------------------------
  //     // 1. Get current employee
  //     // ------------------------------------------------------------
  //
  //     final user = await _userService.getCurrentUser().timeout(
  //       const Duration(seconds: 15),
  //       onTimeout: () {
  //         throw StateError(
  //           'Unable to load your employee profile. Please try again.',
  //         );
  //       },
  //     );
  //
  //     // ------------------------------------------------------------
  //     // 2. Create report date
  //     // ------------------------------------------------------------
  //
  //     final reportDateKey = _dateKey(reportDate);
  //
  //     // ------------------------------------------------------------
  //     // 3. Prevent duplicate report for same date
  //     // ------------------------------------------------------------
  //
  //     final existingSnapshot = await _firestore
  //         .collection(collectionName)
  //         .where('employeeId', isEqualTo: uid)
  //         .where('reportDate', isEqualTo: reportDateKey)
  //         .limit(1)
  //         .get()
  //         .timeout(
  //       const Duration(seconds: 15),
  //       onTimeout: () {
  //         throw StateError(
  //           'Unable to check existing reports. '
  //               'Please check your internet connection.',
  //         );
  //       },
  //     );
  //
  //     if (existingSnapshot.docs.isNotEmpty) {
  //       throw StateError(
  //         'A daily report has already been submitted for $reportDateKey.',
  //       );
  //     }
  //
  //     // ------------------------------------------------------------
  //     // 4. Create Firestore document ID
  //     // ------------------------------------------------------------
  //
  //     final id = _firestore.newId(collectionName);
  //
  //     // ------------------------------------------------------------
  //     // 5. Firebase Storage path
  //     // ------------------------------------------------------------
  //
  //     final safeFileName = fileName.replaceAll(
  //       RegExp(r'[\\/:*?"<>|]'),
  //       '_',
  //     );
  //
  //     final storagePath =
  //         'daily_reports/$uid/$reportDateKey/$id-$safeFileName';
  //
  //     // ------------------------------------------------------------
  //     // 6. Upload file to Firebase Storage
  //     // ------------------------------------------------------------
  //
  //     final fileUrl = await _storage.uploadBytes(
  //       path: storagePath,
  //       bytes: bytes,
  //       contentType: _contentType(fileType),
  //     );
  //
  //     // ------------------------------------------------------------
  //     // 7. Save report metadata in Firestore
  //     // ------------------------------------------------------------
  //
  //     await _firestore
  //         .setDocument(
  //       '$collectionName/$id',
  //       {
  //         'id': id,
  //         'employeeId': uid,
  //         'employeeName': user?.name ?? '',
  //         'managerId': user?.managerId ?? '',
  //         'reportDate': reportDateKey,
  //         'fileName': fileName,
  //         'fileUrl': fileUrl,
  //         'fileType': fileType,
  //         'fileSize': fileSize,
  //         'storagePath': storagePath,
  //         'description': description,
  //         'uploadedAt': FieldValue.serverTimestamp(),
  //         'status': 'submitted',
  //       },
  //     )
  //         .timeout(
  //       const Duration(seconds: 15),
  //       onTimeout: () {
  //         throw StateError(
  //           'The file was uploaded, but saving the report '
  //               'information to Firestore timed out.',
  //         );
  //       },
  //     );
  //
  //     return id;
  //   } on StateError {
  //     rethrow;
  //   } on FirebaseException catch (e) {
  //     throw StateError(
  //       'Firebase error: ${e.code}'
  //           '${e.message != null ? ' - ${e.message}' : ''}',
  //     );
  //   } catch (e) {
  //     throw StateError(
  //       'Unable to submit daily report: $e',
  //     );
  //   }
  // }
  Future<String> uploadDailyReport({
    required Uint8List bytes,
    required String fileName,
    required String fileType,
    required int fileSize,
    required DateTime reportDate,
    String? description,
  }) async {
    try {
      final uid = _uid;

      // ------------------------------------------------------------
      // 1. Get current employee
      // ------------------------------------------------------------

      final user = await _userService.getCurrentUser().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw StateError(
            'Unable to load your employee profile. Please try again.',
          );
        },
      );

      // ------------------------------------------------------------
      // 2. Create report date
      // ------------------------------------------------------------

      final reportDateKey = _dateKey(reportDate);

      // ------------------------------------------------------------
      // 3. Prevent duplicate report for same date
      // ------------------------------------------------------------

      final existingSnapshot = await _firestore
          .collection(collectionName)
          .where('employeeId', isEqualTo: uid)
          .where('reportDate', isEqualTo: reportDateKey)
          .limit(1)
          .get()
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw StateError(
                'Unable to check existing reports. '
                'Please check your internet connection.',
              );
            },
          );

      if (existingSnapshot.docs.isNotEmpty) {
        throw StateError(
          'A daily report has already been submitted for $reportDateKey.',
        );
      }

      // ------------------------------------------------------------
      // 4. Create Firestore document ID
      // ------------------------------------------------------------

      final id = _firestore.newId(collectionName);

      // ------------------------------------------------------------
      // 5. Firebase Storage path
      // ------------------------------------------------------------

      final safeFileName = fileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

      final storagePath = 'daily_reports/$uid/$reportDateKey/$id-$safeFileName';

      // ------------------------------------------------------------
      // 6. Upload file to Firebase Storage
      // ------------------------------------------------------------

      final fileUrl = await _storage
          .uploadBytes(
            path: storagePath,
            bytes: bytes,
            contentType: _contentType(fileType),
          )
          .timeout(
            const Duration(seconds: 50),
            onTimeout: () {
              throw StateError(
                'File upload timed out. '
                'Please check your internet connection and Firebase Storage '
                'configuration.',
              );
            },
          );

      // ------------------------------------------------------------
      // 7. Save report metadata in Firestore
      // ------------------------------------------------------------

      try {
        await _firestore
            .setDocument('$collectionName/$id', {
              'id': id,
              'employeeId': uid,
              'employeeName': user?.name ?? '',
              'managerId': user?.managerId ?? '',
              'reportDate': reportDateKey,
              'fileName': fileName,
              'fileUrl': fileUrl,
              'fileType': fileType,
              'fileSize': fileSize,
              'storagePath': storagePath,
              'description': description,
              'uploadedAt': FieldValue.serverTimestamp(),
              'status': 'submitted',
            })
            .timeout(const Duration(seconds: 30));
      } on TimeoutException {
        throw StateError(
          'The file was uploaded, but saving the report '
          'information to Firestore timed out. '
          'Please check your internet connection.',
        );
      }

      return id;
    } on StateError {
      rethrow;
    } on FirebaseException catch (e) {
      throw StateError(
        'Firebase error: ${e.code}'
        '${e.message != null ? ' - ${e.message}' : ''}',
      );
    } catch (e) {
      throw StateError('Unable to submit daily report: $e');
    }
  }

  String _contentType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';

      case 'doc':
        return 'application/msword';

      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';

      default:
        return 'application/octet-stream';
    }
  }

  Stream<List<DailyReport>> watchMyReports() {
    return _firestore
        .collection(collectionName)
        .where('employeeId', isEqualTo: _uid)
        .snapshots()
        .map((snapshot) {
          final reports = snapshot.docs
              .map((doc) => DailyReport.fromMap({...doc.data(), 'id': doc.id}))
              .toList();

          reports.sort((a, b) => b.reportDate.compareTo(a.reportDate));

          return reports;
        });
  }

  Future<List<DailyReport>> getMyReports() async {
    final snapshot = await _firestore
        .collection(collectionName)
        .where('employeeId', isEqualTo: _uid)
        .get();

    final reports = snapshot.docs
        .map((doc) => DailyReport.fromMap({...doc.data(), 'id': doc.id}))
        .toList();

    reports.sort((a, b) => b.reportDate.compareTo(a.reportDate));

    return reports;
  }

  Future<DailyReport?> getReportById(String id) async {
    final snapshot = await _firestore.getDocument('$collectionName/$id');

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return DailyReport.fromMap({...snapshot.data()!, 'id': snapshot.id});
  }
}
