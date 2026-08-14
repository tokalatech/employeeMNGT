import 'dart:async';

import 'package:flutter/material.dart';

import '../models/attendance_model.dart';
import '../services/attendance_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceService _attendanceService = AttendanceService();

  String _tab = 'Today Shift';
  String _filter = 'All';

  Timer? _timer;

  int _monthOffset = 0;

  List<AttendanceRecord> _records = [];
  AttendanceRecord? _todayAttendance;

  bool _loadingToday = true;
  bool _loadingHistory = true;
  bool _clockActionLoading = false;

  @override
  void initState() {
    super.initState();

    _loadTodayAttendance();
    _loadAttendanceHistory();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _working) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // ATTENDANCE STATE
  // ---------------------------------------------------------------------------

  bool get _working {
    return _todayAttendance?.clockIn != null &&
        _todayAttendance?.clockOut == null;
  }

  DateTime? get _clockedIn {
    final clockIn = _todayAttendance?.clockIn;

    if (clockIn == null) return null;

    final parts = clockIn.split(':');

    if (parts.length < 2) return null;

    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.tryParse(parts[0]) ?? 0,
      int.tryParse(parts[1]) ?? 0,
    );
  }

  String get _time {
    final clockedIn = _clockedIn;

    if (clockedIn == null) {
      return '00:00:00';
    }

    final duration = DateTime.now().difference(clockedIn);

    return '${duration.inHours.toString().padLeft(2, '0')}:'
        '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  // ---------------------------------------------------------------------------
  // FIREBASE DATA
  // ---------------------------------------------------------------------------

  Future<void> _loadTodayAttendance() async {
    try {
      final record = await _attendanceService.getAttendanceForDate(
        DateTime.now(),
      );

      if (!mounted) return;

      setState(() {
        _todayAttendance = record;
        _loadingToday = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingToday = false;
      });

      _showMessage('Failed to load today attendance: $e');
    }
  }

  Future<void> _loadAttendanceHistory() async {
    try {
      final records = await _attendanceService.getAttendanceHistory();

      if (!mounted) return;

      setState(() {
        _records = records;
        _loadingHistory = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingHistory = false;
      });

      _showMessage('Failed to load attendance history: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // CLOCK IN / CLOCK OUT
  // ---------------------------------------------------------------------------

  Future<void> _handleClock() async {
    if (_clockActionLoading) return;

    setState(() {
      _clockActionLoading = true;
    });

    try {
      if (_working) {
        await _attendanceService.clockOut();

        if (!mounted) return;

        _showMessage('Clocked out successfully.');
      } else {
        await _attendanceService.clockIn();

        if (!mounted) return;

        _showMessage('Clocked in successfully.');
      }

      await Future.wait([
        _loadTodayAttendance(),
        _loadAttendanceHistory(),
      ]);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        e.toString().replaceFirst('Bad state: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          _clockActionLoading = false;
        });
      }
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _tabs(),
        const SizedBox(height: 16),
        if (_tab == 'Today Shift')
          _today()
        else if (_tab == 'History')
          _history()
        else
          _calendar(),
      ],
    );
  }

  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: ['Today Shift', 'History', 'Calendar']
            .map(
              (item) => Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _tab = item;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: _tab == item
                    ? Theme.of(context).colorScheme.surface
                    : null,
              ),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: _tab == item ? AppColors.primary : null,
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TODAY
  // ---------------------------------------------------------------------------

  Widget _today() {
    if (_loadingToday) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.navy,
                Color(0xFF1A263A),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MaterialLocalizations.of(context)
                    .formatFullDate(DateTime.now())
                    .toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFC7D2FE),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                _working
                    ? _time
                    : 'Ready to start your shift?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _working ? 33 : 20,
                  fontFamily: _working ? 'monospace' : null,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                _working
                    ? 'Clocked in at ${_todayAttendance!.clockIn}'
                    : 'Standard shift · 09:00 AM – 06:00 PM',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 18),

              PrimaryButton(
                label: _clockActionLoading
                    ? 'Please wait...'
                    : _working
                    ? 'Clock Out Shift'
                    : 'Clock In Now',
                icon: _working
                    ? Icons.stop
                    : Icons.play_arrow,
                onPressed:
                _clockActionLoading ? () {} : _handleClock,
                color: _working
                    ? AppColors.danger
                    : AppColors.success,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        PulseCard(
          onTap: _openCorrection,
          child: const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.edit_calendar_outlined,
              color: AppColors.primary,
            ),
            title: Text(
              'Request attendance correction',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              'Fix a missed or incorrect clock time',
              style: TextStyle(fontSize: 11),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HISTORY
  // ---------------------------------------------------------------------------

  Widget _history() {
    if (_loadingHistory) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final filteredRecords = _records.where((record) {
      if (_filter == 'All') return true;

      return record.status.name.toLowerCase() == _filter.toLowerCase();
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          children: ['All', 'Present', 'Late', 'Half Day', 'Absent', 'On Leave']
              .map(
                (item) => ChoiceChip(
              label: Text(
                item,
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
              selected: _filter == item,
              onSelected: (_) {
                setState(() {
                  _filter = item;
                });
              },
            ),
          )
              .toList(),
        ),

        const SizedBox(height: 13),

        if (filteredRecords.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No attendance records found.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        ...filteredRecords.map(
              (record) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: PulseCard(
              onTap: () => _showRecord(record),
              child: ListTile(
                contentPadding: EdgeInsets.zero,

                title: Text(
                  record.date,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),

                subtitle: Text(
                  '${record.clockIn ?? '--'} – '
                      '${record.clockOut ?? '--'} · '
                      '${record.totalHours ?? '--'}',
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),

                trailing: Text(
                  record.status.name,
                  style: TextStyle(
                    color: _statusColor(record.status),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // CALENDAR
  // ---------------------------------------------------------------------------

  Widget _calendar() {
    final selectedMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + _monthOffset,
    );

    final daysInMonth = DateUtils.getDaysInMonth(
      selectedMonth.year,
      selectedMonth.month,
    );

    return PulseCard(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _monthOffset--;
                  });
                },
                icon: const Icon(Icons.chevron_left),
              ),

              Expanded(
                child: Center(
                  child: Text(
                    _monthTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    _monthOffset++;
                  });
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),

          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              daysInMonth,
                  (i) {
                final day = i + 1;

                final dateKey = _formatDate(
                  DateTime(
                    selectedMonth.year,
                    selectedMonth.month,
                    day,
                  ),
                );

                final record = _records.cast<AttendanceRecord?>().firstWhere(
                      (record) => record?.date == dateKey,
                  orElse: () => null,
                );

                return Container(
                  margin: const EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: record != null
                        ? _statusColor(record.status)
                        .withValues(alpha: .18)
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: record != null
                          ? FontWeight.w800
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String get _monthTitle {
    final month = DateTime(
      DateTime.now().year,
      DateTime.now().month + _monthOffset,
    );

    return MaterialLocalizations.of(
      context,
    ).formatMonthYear(month).toUpperCase();
  }

  // ---------------------------------------------------------------------------
  // RECORD DETAILS
  // ---------------------------------------------------------------------------

  void _showRecord(AttendanceRecord record) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.date,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 14),

            Text('Status: ${record.status.name}'),

            Text(
              'Clock in: ${record.clockIn ?? '--'}',
            ),

            Text(
              'Clock out: ${record.clockOut ?? '--'}',
            ),

            Text(
              'Total hours: ${record.totalHours ?? '--'}',
            ),

            if (record.breakDuration != null)
              Text(
                'Break: ${record.breakDuration}',
              ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CORRECTION
  // ---------------------------------------------------------------------------

  void _openCorrection() {
    final date = TextEditingController();
    final clockIn = TextEditingController();
    final clockOut = TextEditingController();
    final reason = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.of(sheet).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Attendance Correction',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: date,
              decoration: const InputDecoration(
                labelText: 'Date',
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: clockIn,
                    decoration: const InputDecoration(
                      labelText: 'Requested clock-in',
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: TextField(
                    controller: clockOut,
                    decoration: const InputDecoration(
                      labelText: 'Requested clock-out',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextField(
              controller: reason,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Reason',
              ),
            ),

            const SizedBox(height: 14),

            PrimaryButton(
              label: 'Submit Correction',
              icon: Icons.send,
              onPressed: () async {
                if (date.text.trim().isEmpty ||
                    reason.text.trim().isEmpty) {
                  _showMessage(
                    'Please enter date and reason.',
                  );
                  return;
                }

                /*
                 * We will connect this to
                 * AttendanceCorrectionRequest
                 * once its exact model fields are confirmed.
                 */

                Navigator.pop(sheet);

                _showMessage(
                  'Please connect AttendanceCorrectionRequest here.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  Color _statusColor(AttendanceRecordStatus status) {
    switch (status) {
      case AttendanceRecordStatus.present:
        return AppColors.success;

      case AttendanceRecordStatus.late:
        return AppColors.warning;

      case AttendanceRecordStatus.absent:
        return AppColors.danger;

      case AttendanceRecordStatus.halfDay:
        return AppColors.warning;

      case AttendanceRecordStatus.onLeave:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}