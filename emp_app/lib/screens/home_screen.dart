import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import 'leave_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.manager,
    required this.working,
    required this.clockedIn,
    required this.onClock,
    required this.onNavigate,
    required this.leaves,
  });

  final bool manager, working;
  final DateTime? clockedIn;
  final VoidCallback onClock;
  final ValueChanged<String> onNavigate;
  final List<LeaveItem> leaves;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _elapsed {
    final d = widget.clockedIn == null
        ? Duration.zero
        : DateTime.now().difference(widget.clockedIn!);
    return '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
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

  Widget _attendance() => Container(
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
            const Text(
              'Wed, Aug 13',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const Spacer(),
            Text(
              widget.working ? 'WORKING' : 'NOT CHECKED IN',
              style: TextStyle(
                color: widget.working
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
          widget.working ? 'WORKING TIMER' : 'NOT CHECKED IN',
          style: const TextStyle(
            color: Color(0xFFC7D2FE),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          widget.working ? _elapsed : 'Ready to start your shift?',
          style: TextStyle(
            color: Colors.white,
            fontFamily: widget.working ? 'monospace' : null,
            fontSize: widget.working ? 30 : 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          widget.working
              ? 'Clocked in at ${TimeOfDay.fromDateTime(widget.clockedIn!).format(context)}'
              : 'Standard shift: 09:00 AM - 06:00 PM',
          style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
        ),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFF334155)),
        PrimaryButton(
          label: widget.working ? 'Clock Out Shift' : 'Clock In Now',
          icon: widget.working ? Icons.stop : Icons.play_arrow,
          color: widget.working ? AppColors.danger : AppColors.success,
          onPressed: widget.onClock,
        ),
      ],
    ),
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
      PulseCard(
        onTap: () => widget.onNavigate('leaveApprovals'),
        child: const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.fact_check_outlined, color: AppColors.warning),
          title: Text(
            'Leave Approvals',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            '1 pending team request',
            style: TextStyle(fontSize: 11),
          ),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    ],
  );

  Widget _balances() => PulseCard(
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
          children: [
            _balance('Paid', 12, 18, AppColors.primary),
            _balance('Casual', 5, 8, AppColors.warning),
            _balance('Sick', 7, 10, AppColors.success),
          ],
        ),
      ],
    ),
  );

  Widget _balance(String name, int n, int total, Color color) => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontSize: 10)),
          Text(
            '$n / $total',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          LinearProgressIndicator(value: n / total, color: color, minHeight: 5),
        ],
      ),
    ),
  );

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
