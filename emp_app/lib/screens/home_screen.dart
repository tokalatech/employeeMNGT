import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import '../models/attendance_model.dart';
import '../models/leave_model.dart';
import '../services/attendance_service.dart';
import '../services/leave_service.dart';
import '../models/user_model.dart';
import '../models/announcement_model.dart';
import '../services/user_service.dart';
import '../services/announcement_service.dart';
import '../models/calendar_event_model.dart';
import '../services/calendar_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.manager,
    required this.onNavigate,
  });

  final bool manager;
  final ValueChanged<String> onNavigate;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _AttendanceCard extends StatefulWidget {
  const _AttendanceCard();

  @override
  State<_AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<_AttendanceCard> {
  final _attendanceService = AttendanceService();

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  DateTime? _clockedInTime(AttendanceRecord? record) {
    final clockIn = record?.clockIn;

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

  String _elapsed(DateTime? clockedIn) {
    if (clockedIn == null) return '00:00:00';

    final d = DateTime.now().difference(clockedIn);

    return '${d.inHours.toString().padLeft(2, '0')}:'
        '${(d.inMinutes % 60).toString().padLeft(2, '0')}:'
        '${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Future<void> _handleClock(BuildContext context,
      bool working,) async {
    try {
      if (working) {
        await _attendanceService.clockOut();
      } else {
        await _attendanceService.clockIn();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Bad state: ', ''),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AttendanceRecord?>(
      stream: _attendanceService.watchToday(),
      builder: (context, snap) {
        final record = snap.data;

        final working =
            record?.clockIn != null && record?.clockOut == null;

        final shiftCompleted =
            record?.clockIn != null && record?.clockOut != null;

        final clockedInTime = _clockedInTime(record);

        return Container(
          padding: const EdgeInsets.all(19),
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
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xFFA5B4FC),
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    MaterialLocalizations.of(context)
                        .formatShortDate(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    working
                        ? 'WORKING'
                        : shiftCompleted
                        ? 'COMPLETED'
                        : 'NOT CHECKED IN',
                    style: TextStyle(
                      color: working
                          ? const Color(0xFF6EE7B7)
                          : const Color(0xFFCBD5E1),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                working
                    ? 'WORKING TIMER'
                    : shiftCompleted
                    ? 'SHIFT COMPLETED'
                    : 'NOT CHECKED IN',
                style: const TextStyle(
                  color: Color(0xFFC7D2FE),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                working
                    ? _elapsed(clockedInTime)
                    : shiftCompleted
                    ? 'Shift completed'
                    : 'Ready to start your shift?',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: working ? 'monospace' : null,
                  fontSize: working ? 30 : 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                working
                    ? 'Clocked in at ${record!.clockIn}'
                    : shiftCompleted
                    ? 'Clocked in at ${record!.clockIn} · '
                    'Clocked out at ${record.clockOut}'
                    : 'Standard shift: 09:00 AM - 06:00 PM',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(
                color: Color(0xFF334155),
              ),
              if (!shiftCompleted)
                PrimaryButton(
                  label: working ? 'Clock Out Shift' : 'Clock In Now',
                  icon: working ? Icons.stop : Icons.play_arrow,
                  color: working ? AppColors.danger : AppColors.success,
                  onPressed: () =>
                      _handleClock(context, working),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final _leaveService = LeaveService();
  final _attendanceService = AttendanceService();
  final _userService = UserService();
  final _announcementService = AnnouncementService();
  final _calendarService = CalendarService();

  @override
  Widget build(BuildContext context) =>
      ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header(),
          const SizedBox(height: 18),
          _attendance(),
          const SizedBox(height: 14),
          _breaks(),
          const SizedBox(height: 18),
          const Text(
            'QUICK ACTIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _quick(
                Icons.calendar_month,
                'Apply Leave',
                'leave',
              ),
              _quick(
                Icons.access_time,
                'History',
                'attendance',
              ),
              _quick(
                Icons.description_outlined,
                'Payslip',
                'payslips',
              ),
              _quick(
                Icons.support_agent,
                'Support',
                'helpdesk',
              ),
            ],
          ),

          const SizedBox(height: 18),
          _balances(),
          const SizedBox(height: 14),
          _upcomingEvents(),
          const SizedBox(height: 14),
          _announcements(),
        ],
      );

  Widget _header() =>
      StreamBuilder<UserModel?>(
        stream: _userService.watchCurrentUser(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          final name = user?.name ?? 'User';
          final designation = user?.designation ?? '';
          final avatar = user?.avatar ?? '';

          final initials = name
              .trim()
              .split(RegExp(r'\s+'))
              .where((part) => part.isNotEmpty)
              .take(2)
              .map((part) => part[0].toUpperCase())
              .join();

          return Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primary,
                backgroundImage:
                avatar.isNotEmpty ? NetworkImage(avatar) : null,
                child: avatar.isEmpty
                    ? Text(
                  initials.isEmpty ? 'U' : initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.manager
                          ? 'MANAGER PORTAL'
                          : 'EMPLOYEE PORTAL',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Hello, $name 👋',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      designation,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

// ----------------------------------------------------------
// HOME HEADER ACTIONS
// ----------------------------------------------------------
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      widget.onNavigate('dailyReports');
                    },
                    tooltip: 'Daily Reports',
                    icon: const Icon(
                      Icons.assignment_outlined,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onNavigate('notifications');
                    },
                    tooltip: 'Notifications',
                    icon: const Badge(
                      child: Icon(
                        Icons.notifications_none,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );

  Widget _attendance() => const _AttendanceCard();

  Widget _breaks() {
    return StreamBuilder<List<AttendanceBreak>>(
      stream: _attendanceService.watchTodayBreaks(),
      builder: (context, snapshot) {
        final breaks = snapshot.data ?? [];

        final activeBreak =
        breaks
            .where((b) => b.isActive)
            .isNotEmpty
            ? breaks.firstWhere((b) => b.isActive)
            : null;

        return PulseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.free_breakfast_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'BREAKS',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (activeBreak != null)
                _activeBreak(activeBreak)
              else
                _breakButtons(),
              const SizedBox(height: 12),
              if (breaks.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 5),
                ...breaks.map(
                      (breakItem) => _breakRow(breakItem),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _breakButtons() {
    return Row(
      children: [
        Expanded(
          child: _breakButton(
            type: BreakType.teaBreak,
            icon: Icons.local_cafe_outlined,
            label: 'Tea',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _breakButton(
            type: BreakType.lunchBreak,
            icon: Icons.restaurant_outlined,
            label: 'Lunch',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _breakButton(
            type: BreakType.afternoonTeaBreak,
            icon: Icons.coffee_outlined,
            label: 'Afternoon',
          ),
        ),
      ],
    );
  }

  Widget _breakButton({
    required BreakType type,
    required IconData icon,
    required String label,
  }) {
    return OutlinedButton.icon(
      onPressed: () => _startBreak(type),
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 10),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 10,
        ),
      ),
    );
  }

  Future<void> _startBreak(BreakType type) async {
    try {
      await _attendanceService.startBreak(type: type);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${breakTypeToString(type)} started.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Bad state: ', ''),
          ),
        ),
      );
    }
  }

  Widget _activeBreak(AttendanceBreak breakItem) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                breakTypeToString(breakItem.type),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Started at ${breakItem.breakStart}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: _endBreak,
          child: const Text(
            'End Break',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  Future<void> _endBreak() async {
    try {
      await _attendanceService.endBreak();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Break ended successfully.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Bad state: ', ''),
          ),
        ),
      );
    }
  }

  Widget _breakRow(AttendanceBreak breakItem) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            breakItem.type == BreakType.lunchBreak
                ? Icons.restaurant_outlined
                : Icons.local_cafe_outlined,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              breakTypeToString(breakItem.type),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            breakItem.duration ?? 'Active',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _upcomingEvents() =>
      StreamBuilder<List<CalendarEvent>>(
        stream: _calendarService.watchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PulseCard(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          final today = DateTime.now();

          final events = (snapshot.data ?? [])
              .where((event) {
            final parts = event.date.split('-');

            if (parts.length != 3) return false;

            final eventDate = DateTime(
              int.tryParse(parts[0]) ?? 0,
              int.tryParse(parts[1]) ?? 0,
              int.tryParse(parts[2]) ?? 0,
            );

            return !eventDate.isBefore(
              DateTime(
                today.year,
                today.month,
                today.day,
              ),
            );
          })
              .take(3)
              .toList();

          if (events.isEmpty) {
            return const PulseCard(
              child: Text('No upcoming events.'),
            );
          }

          return PulseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...events.map(
                      (event) =>
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: Text(
                          _formatEventDate(event.date),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                ),
              ],
            ),
          );
        },
      );

  String _formatEventDate(String date) {
    final parts = date.split('-');

    if (parts.length != 3) {
      return date;
    }

    final month = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return date;
    }

    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return '${months[month - 1]} ${int.tryParse(parts[2]) ?? parts[2]}';
  }

  Widget _announcements() =>
      StreamBuilder<List<Announcement>>(
        stream: _announcementService.watchAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PulseCard(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          final announcements = snapshot.data ?? [];

          if (announcements.isEmpty) {
            return const PulseCard(
              child: Text('No announcements available.'),
            );
          }

          final items = announcements.take(3).toList();

          return PulseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.campaign_outlined,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'Announcements',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...items.map(
                      (announcement) =>
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          announcement.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: announcement.summary.isNotEmpty
                            ? Text(
                          announcement.summary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10),
                        )
                            : null,
                        trailing: Text(
                          announcement.publishedDate,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                ),
              ],
            ),
          );
        },
      );

  Widget _quick(IconData icon,
      String text,
      String target,) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: PulseCard(
            onTap: () => widget.onNavigate(target),
            padding: const EdgeInsets.symmetric(
              vertical: 11,
              horizontal: 3,
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _balances() =>
      StreamBuilder<List<LeaveBalance>>(
        stream: _leaveService.watchMyLeaveBalances(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const PulseCard(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          final balances = snap.data ?? const [];

          if (balances.isEmpty) {
            return const PulseCard(
              child: Text('No leave balances found.'),
            );
          }

          return PulseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LEAVE BALANCES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: balances.map(_balance).toList(),
                ),
              ],
            ),
          );
        },
      );

  Widget _balance(LeaveBalance b) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leaveTypeToString(b.type),
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                '${b.remaining} / ${b.total}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              LinearProgressIndicator(
                value: b.total == 0
                    ? 0
                    : b.remaining / b.total,
                color: _balanceColor(b.color),
                minHeight: 5,
              ),
            ],
          ),
        ),
      );

  Color _balanceColor(String hex) {
    try {
      final clean =
      hex.replaceFirst('#', '').padLeft(6, '0');

      return Color(
        int.parse(
          'FF$clean',
          radix: 16,
        ),
      );
    } catch (_) {
      return AppColors.primary;
    }
  }
}
