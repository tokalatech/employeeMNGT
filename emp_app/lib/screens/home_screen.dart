import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import '../models/attendance_model.dart';
import '../models/leave_model.dart';
import '../services/attendance_service.dart';
import '../services/leave_service.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  final _leaveService = LeaveService();
  final _attendanceService = AttendanceService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Ticks the UI every second so a live "working" timer can redraw itself
    // off the current record's clockIn time.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
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
    return '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Future<void> _handleClock(bool working) async {
    try {
      if (working) {
        await _attendanceService.clockOut();
      } else {
        await _attendanceService.clockIn();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Bad state: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _header(),
      const SizedBox(height: 18),
      _attendance(),
      if (widget.manager) ...[const SizedBox(height: 14), _team()],
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
          _quick(Icons.calendar_month, 'Apply Leave', 'leave'),
          _quick(Icons.access_time, 'History', 'attendance'),
          _quick(Icons.description_outlined, 'Payslip', 'payslips'),
          _quick(Icons.support_agent, 'Support', 'helpdesk'),
        ],
      ),
      const SizedBox(height: 18),
      _balances(),
      const SizedBox(height: 14),
      _list(Icons.trending_up, 'Upcoming Events', const [
        ['Labor Day Public Holiday', 'SEP 7'],
        ['Alex Lake Tahoe Leave', 'AUG 25'],
      ]),
      const SizedBox(height: 14),
      _list(Icons.campaign_outlined, 'Announcements', const [
        ['Q3 All-Hands Meeting & Product Roadmap', 'AUG 11'],
        ['Updated Parental Leave & Wellness Policy', 'AUG 5'],
      ]),
    ],
  );

  Widget _header() => Row(
    children: [
      const CircleAvatar(
        radius: 25,
        backgroundColor: AppColors.primary,
        child: Text(
          'AM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.manager ? 'MANAGER PORTAL' : 'EMPLOYEE PORTAL',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Hello, Alex 👋',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19),
            ),
            Text(
              'Senior UI/UX Designer',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
      IconButton(
        onPressed: () => widget.onNavigate('notifications'),
        icon: const Badge(child: Icon(Icons.notifications_none)),
      ),
    ],
  );

  Widget _attendance() => StreamBuilder<AttendanceRecord?>(
    stream: _attendanceService.watchToday(),
    builder: (context, snap) {
      final record = snap.data;
      final working = record?.clockIn != null && record?.clockOut == null;
      final shiftCompleted = record?.clockIn != null && record?.clockOut != null;
      final clockedInTime = _clockedInTime(record);

      return Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.navy, Color(0xFF1A263A)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, color: Color(0xFFA5B4FC), size: 17),
                const SizedBox(width: 7),
                Text(
                  MaterialLocalizations.of(context)
                      .formatShortDate(DateTime.now()),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
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
                  ? 'Clocked in at ${record!.clockIn} · Clocked out at ${record.clockOut}'
                  : 'Standard shift: 09:00 AM - 06:00 PM',
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF334155)),
            if (!shiftCompleted)
              PrimaryButton(
                label: working ? 'Clock Out Shift' : 'Clock In Now',
                icon: working ? Icons.stop : Icons.play_arrow,
                color: working ? AppColors.danger : AppColors.success,
                onPressed: () => _handleClock(working),
              ),
          ],
        ),
      );
    },
  );

  Widget _quick(IconData icon, String text, String target) => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(right: 5),
      child: PulseCard(
        onTap: () => widget.onNavigate(target),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 3),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(
              text,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _team() => Column(
    children: [
      PulseCard(
        onTap: () => widget.onNavigate('team'),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.groups, color: AppColors.primary),
          title: Text(
            'Team At A Glance',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            '5 total · 3 present · 1 on leave · 1 pending',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ),
      const SizedBox(height: 9),
      StreamBuilder<List<LeaveRequest>>(
        stream: _leaveService.watchPendingApprovals(),
        builder: (context, snap) {
          final count = snap.data?.length ?? 0;
          return PulseCard(
            onTap: () => widget.onNavigate('leaveApprovals'),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.fact_check_outlined, color: AppColors.warning),
              title: const Text(
                'Leave Approvals',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                count == 0 ? 'No pending requests' : '$count pending team request${count == 1 ? '' : 's'}',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    ],
  );

  Widget _balances() => StreamBuilder<List<LeaveBalance>>(
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
        return const PulseCard(child: Text('No leave balances found.'));
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
            Row(children: balances.map(_balance).toList()),
          ],
        ),
      );
    },
  );

  Widget _balance(LeaveBalance b) => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(leaveTypeToString(b.type), style: const TextStyle(fontSize: 10)),
          Text(
            '${b.remaining} / ${b.total}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          LinearProgressIndicator(
            value: b.total == 0 ? 0 : b.remaining / b.total,
            color: _balanceColor(b.color),
            minHeight: 5,
          ),
        ],
      ),
    ),
  );

  Color _balanceColor(String hex) {
    try {
      final clean = hex.replaceFirst('#', '').padLeft(6, '0');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  Widget _list(
      IconData icon,
      String title,
      List<List<String>> rows,
      ) => PulseCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 7),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        ...rows.map(
              (r) => ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              r[0],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            trailing: Text(
              r[1],
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    ),
  );
}