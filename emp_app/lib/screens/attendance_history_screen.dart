import 'package:flutter/material.dart';

import '../models/attendance_model.dart';
import '../services/attendance_service.dart';
import 'flow_detail_screen.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState
    extends State<AttendanceHistoryScreen> {
  final AttendanceService _attendanceService = AttendanceService();

  List<AttendanceRecord> _records = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final records =
      await _attendanceService.getAttendanceHistory();

      if (!mounted) return;

      setState(() {
        _records = records;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final present = _records
        .where(
          (record) =>
      record.status == AttendanceRecordStatus.present,
    )
        .length;

    final late = _records
        .where(
          (record) =>
      record.status == AttendanceRecordStatus.late,
    )
        .length;

    final absent = _records
        .where(
          (record) =>
      record.status == AttendanceRecordStatus.absent,
    )
        .length;

    final halfDay = _records
        .where(
          (record) =>
      record.status == AttendanceRecordStatus.halfDay,
    )
        .length;

    final onLeave = _records
        .where(
          (record) =>
      record.status == AttendanceRecordStatus.onLeave,
    )
        .length;

    return FlowDetailScreen(
      title: 'Attendance History',
      subtitle: 'Monthly attendance record',
      sections: [
        (
        _monthTitle,
        '$present present · '
            '$late late · '
            '$absent absent',
        ),
        (
        'Other records',
        '$halfDay half day · '
            '$onLeave on leave',
        ),
        (
        'Total records',
        '${_records.length} attendance records',
        ),
      ],
    );
  }

  String get _monthTitle {
    final now = DateTime.now();

    return MaterialLocalizations.of(context)
        .formatMonthYear(now);
  }
}