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

    final hasClockedIn = _todayAttendance?.clockIn != null;
    final hasClockedOut = _todayAttendance?.clockOut != null;

    final shiftCompleted = hasClockedIn && hasClockedOut;

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
              // DATE
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

              // MAIN STATUS / TIMER
              Text(
                _working
                    ? _time
                    : shiftCompleted
                    ? 'Shift completed'
                    : 'Ready to start your shift?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _working ? 33 : 20,
                  fontFamily: _working ? 'monospace' : null,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 6),

              // SHIFT DETAILS
              if (_working)
                Text(
                  'Clocked in at ${_todayAttendance!.clockIn}',
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                  ),
                )
              else if (shiftCompleted)
                Text(
                  'Clocked in at ${_todayAttendance!.clockIn} · '
                      'Clocked out at ${_todayAttendance!.clockOut}',
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                  ),
                )
              else
                const Text(
                  'Standard shift · 09:00 AM – 06:00 PM',
                  style: TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                  ),
                ),

              const SizedBox(height: 18),

              // CLOCK BUTTON
              if (!shiftCompleted)
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
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Today\'s shift completed',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // CORRECTION
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


  String _statusLabel(AttendanceRecordStatus status) {
    switch (status) {
      case AttendanceRecordStatus.present:
        return 'Present';
      case AttendanceRecordStatus.late:
        return 'Late';
      case AttendanceRecordStatus.halfDay:
        return 'Half Day';
      case AttendanceRecordStatus.absent:
        return 'Absent';
      case AttendanceRecordStatus.onLeave:
        return 'On Leave';
    }
  }
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

      return _statusLabel(record.status) == _filter;
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
                  _statusLabel(record.status),
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

            Text('Status: ${_statusLabel(record.status)}'),

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
    final today = DateTime.now();

    final date = TextEditingController(
      text: _formatDate(today),
    );
    AttendanceRecord? selectedRecord = _todayAttendance;

    final clockIn = TextEditingController(
      text: _todayAttendance?.clockIn ?? '',
    );

    final clockOut = TextEditingController(
      text: _todayAttendance?.clockOut ?? '',
    );

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
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (sheetContext, setSheetState) => Column(
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
                    hintText: 'YYYY-MM-DD',
                  ),
                  onChanged: (value) async {
                    final parsed = _tryParseDate(value.trim());
                    if (parsed == null) return;

                    final record =
                    await _attendanceService.getAttendanceForDate(parsed);

                    setSheetState(() {
                      selectedRecord = record;
                    });

                    clockIn.text = record?.clockIn ?? '';
                    clockOut.text = record?.clockOut ?? '';
                  },
                ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: clockIn,
                      decoration: const InputDecoration(
                        labelText: 'Requested clock-in',
                        hintText: '09:00',
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      controller: clockOut,
                      decoration: const InputDecoration(
                        labelText: 'Requested clock-out',
                        hintText: '18:00',
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
                  hintText: 'Explain why the attendance needs correction',
                ),
              ),

              const SizedBox(height: 14),

              PrimaryButton(
                label: 'Submit Correction',
                icon: Icons.send,
                onPressed: () async {
                  final dateValue = date.text.trim();
                  final clockInValue = clockIn.text.trim();
                  final clockOutValue = clockOut.text.trim();
                  final reasonValue = reason.text.trim();

                  if (dateValue.isEmpty) {
                    _showMessage('Please enter the attendance date.');
                    return;
                  }

                  if (clockInValue.isEmpty && clockOutValue.isEmpty) {
                    _showMessage(
                      'Please enter the requested clock-in or clock-out time.',
                    );
                    return;
                  }

                  if (reasonValue.isEmpty) {
                    _showMessage('Please enter a reason.');
                    return;
                  }

                  try {
                    final request = AttendanceCorrectionRequest(
                      id: '',
                      date: dateValue,
                      existingClockIn: selectedRecord?.clockIn,
                      existingClockOut: selectedRecord?.clockOut,
                      requestedClockIn: clockInValue,
                      requestedClockOut: clockOutValue,
                      reason: reasonValue,
                      status: CorrectionRequestStatus.pending,
                      createdAt: DateTime.now().toIso8601String(),
                    );

                    await _attendanceService.submitCorrection(request);

                    if (!mounted) return;

                    Navigator.pop(sheet);

                    _showMessage(
                      'Attendance correction submitted successfully.',
                    );

                    await _loadTodayAttendance();
                    await _loadAttendanceHistory();
                  } catch (e) {
                    if (!mounted) return;

                    _showMessage(
                      e.toString().replaceFirst('Bad state: ', ''),
                    );
                  }
                },
              ),
            ],
          ),
        ),),
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

  DateTime? _tryParseDate(String value) {
    final parts = value.split('-');
    if (parts.length != 3) return null;

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) return null;

    return DateTime(year, month, day);
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