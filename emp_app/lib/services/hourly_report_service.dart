import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/hourly_report_model.dart';
import 'firestore_service.dart';

class HourlyReportService {
  HourlyReportService({
    FirestoreService? firestoreService,
    FirebaseAuth? auth,
  })  : _firestore = firestoreService ?? FirestoreService(),
        _auth = auth ?? FirebaseAuth.instance;

  final FirestoreService _firestore;
  final FirebaseAuth _auth;

  static const String _collection = 'hourly_reports';

  // ------------------------------------------------------------
  // CURRENT USER
  // ------------------------------------------------------------

  String get _employeeId {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError(
        'You must be logged in to submit an hourly report.',
      );
    }

    return user.uid;
  }

  // ------------------------------------------------------------
  // DATE
  // ------------------------------------------------------------

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // ------------------------------------------------------------
  // REPORT DOCUMENT PATH
  // ------------------------------------------------------------

  String _reportPath(String reportId) {
    return '$_collection/$reportId';
  }

  // ------------------------------------------------------------
  // CREATE / SAVE DRAFT
  // ------------------------------------------------------------

  Future<String> saveDraft({
    required DateTime reportDate,
    required List<HourlyReportEntry> entries,
  }) async {
    final reportId = _firestore.newId(_collection);

    final data = {
      'id': reportId,
      'employeeId': _employeeId,
      'reportDate': _dateKey(reportDate),
      'entries': entries.map((e) => e.toMap()).toList(),
      'status': 'draft',
      'createdAt': DateTime.now(),
      'submittedAt': null,
    };

    await _firestore.setDocument(
      _reportPath(reportId),
      data,
    );

    return reportId;
  }

  // ------------------------------------------------------------
  // UPDATE EXISTING DRAFT
  // ------------------------------------------------------------

  Future<void> updateDraft({
    required String reportId,
    required List<HourlyReportEntry> entries,
  }) async {
    await _firestore.updateDocument(
      _reportPath(reportId),
      {
        'entries': entries.map((e) => e.toMap()).toList(),
      },
    );
  }

  // ------------------------------------------------------------
  // SUBMIT REPORT
  // ------------------------------------------------------------

  Future<void> submitReport({
    required String reportId,
    required List<HourlyReportEntry> entries,
  }) async {
    final workSlots = hourlyReportSlots
        .where((slot) => slot.isWork)
        .toList();

    final entryMap = {
      for (final entry in entries)
        entry.slotId: entry.description.trim(),
    };

    for (final slot in workSlots) {
      final description = entryMap[slot.id] ?? '';

      if (description.isEmpty) {
        throw StateError(
          'Please complete the report for ${slot.time}.',
        );
      }
    }

    await _firestore.updateDocument(
      _reportPath(reportId),
      {
        'entries': entries.map((e) => e.toMap()).toList(),
        'status': 'submitted',
        'submittedAt': DateTime.now(),
      },
    );
  }

  // ------------------------------------------------------------
  // GET TODAY'S REPORT
  // ------------------------------------------------------------

  Future<HourlyReport?> getTodayReport() async {
    final date = _dateKey(DateTime.now());

    // No composite index:
    // We only query employeeId and then filter date in Dart.
    final snapshot = await _firestore
        .collection(_collection)
        .where(
      'employeeId',
      isEqualTo: _employeeId,
    )
        .get();

    for (final document in snapshot.docs) {
      final report = HourlyReport.fromMap(
        document.id,
        document.data(),
      );

      if (report.reportDate == date) {
        return report;
      }
    }

    return null;
  }

  // ------------------------------------------------------------
  // CREATE TODAY'S REPORT IF NEEDED
  // ------------------------------------------------------------

  Future<HourlyReport> getOrCreateTodayReport() async {
    final existing = await getTodayReport();

    if (existing != null) {
      return existing;
    }

    final reportId = _firestore.newId(_collection);

    final entries = hourlyReportSlots
        .where((slot) => slot.isWork)
        .map(
          (slot) => HourlyReportEntry(
        slotId: slot.id,
        description: '',
      ),
    )
        .toList();

    await _firestore.setDocument(
      _reportPath(reportId),
      {
        'id': reportId,
        'employeeId': _employeeId,
        'reportDate': _dateKey(DateTime.now()),
        'entries': entries.map((e) => e.toMap()).toList(),
        'status': 'draft',
        'createdAt': DateTime.now(),
        'submittedAt': null,
      },
    );

    return HourlyReport(
      id: reportId,
      employeeId: _employeeId,
      reportDate: _dateKey(DateTime.now()),
      entries: entries,
      status: 'draft',
      createdAt: DateTime.now(),
    );
  }

  // ------------------------------------------------------------
  // WATCH MY SUBMITTED REPORTS
  // ------------------------------------------------------------

  Stream<List<HourlyReport>> watchMyReports() {
    return _firestore
        .collection(_collection)
        .where(
      'employeeId',
      isEqualTo: _employeeId,
    )
        .snapshots()
        .map((snapshot) {
      final reports = snapshot.docs
          .map(
            (doc) => HourlyReport.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList();

      reports.sort(
            (a, b) => b.reportDate.compareTo(a.reportDate),
      );

      return reports;
    });
  }
}