import 'package:flutter/material.dart';

import '../models/attendance_model.dart';
import 'flow_detail_screen.dart';

class AttendanceDetailsScreen extends StatelessWidget {
  const AttendanceDetailsScreen({
    super.key,
    required this.record,
  });

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    return FlowDetailScreen(
      title: 'Attendance Record',
      subtitle: 'Shift and location details',
      sections: [
        (
        'Date',
        record.date,
        ),
        (
        'Status',
        '${_statusLabel(record.status)} · '
            '${record.clockIn ?? '--'} to '
            '${record.clockOut ?? '--'}',
        ),
        (
        'Work summary',
        '${record.totalHours ?? '--'} worked',
        ),
        (
        'Break',
        record.breakDuration ?? 'No break recorded',
        ),
        (
        'Correction',
        record.isCorrectionRequested==true
            ? 'Correction request submitted'
            : 'No correction requested',
        ),
      ],
    );
  }

  String _statusLabel(AttendanceRecordStatus status) {
    switch (status) {
      case AttendanceRecordStatus.present:
        return 'Present';

      case AttendanceRecordStatus.late:
        return 'Late';

      case AttendanceRecordStatus.absent:
        return 'Absent';

      case AttendanceRecordStatus.halfDay:
        return 'Half Day';

      case AttendanceRecordStatus.onLeave:
        return 'On Leave';
    }
  }
}