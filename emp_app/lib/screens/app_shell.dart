import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'announcements_screen.dart';
import 'attendance_screen.dart';
import 'calendar_screen.dart';
import 'documents_screen.dart';
import 'helpdesk_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'leave_screen.dart';
import 'notifications_screen.dart';
import 'payslips_screen.dart';
import 'performance_screen.dart';
import 'profile_screen.dart';
import 'requests_screen.dart';
import 'settings_screen.dart';
import 'team_screen.dart';
import 'team_attendance_screen.dart';
import 'team_perfomance_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.onThemeToggle, this.initialManager = false});
  final VoidCallback onThemeToggle;
  final bool initialManager;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _tab = 0;
  late bool _manager;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _manager = widget.initialManager;
  }


  void _open(String title, Widget page) => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: Text(title)), body: page)),
  );

  Future<void> _signOut() async {
    // Sign out of Firebase too — otherwise the session persists and the
    // splash screen will route straight back into AppShell next launch.
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen(onThemeToggle: widget.onThemeToggle)),
          (_) => false,
    );
  }

  void _openModule(String id) {
    const managerOnly = {'team', 'leaveApprovals', 'teamAttendance', 'teamPerformance'};
    if (!_manager && managerOnly.contains(id)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This manager tool is not available in employee mode.')));
      return;
    }
    switch (id) {
      case 'attendance': _tab = 1; break;
      case 'leave': _tab = _manager ? 3 : 2; break;
    // Manager Leave tab already has an Approvals sub-tab listing the full
    // pending queue with inline approve/reject — jump there instead of
    // pushing LeaveApprovalsScreen, which now needs a specific leaveId.
      case 'leaveApprovals': _tab = 3; break;
      case 'notifications': _tab = 3; break;
      case 'team': _open('My Team', const TeamScreen()); return;
      case 'teamAttendance': _open('Team Attendance', const TeamAttendanceScreen()); return;
      case 'teamPerformance': _open('Team Performance', const TeamPerfomanceScreen()); return;
      case 'payslips': _open('Payslips', const PayslipsScreen()); return;
      case 'performance': _open('Performance & Goals', const PerformanceScreen()); return;
      case 'helpdesk': _open('Helpdesk & Support', const HelpdeskScreen()); return;
      case 'calendar': _open('Master Calendar', const CalendarScreen()); return;
      case 'requests': _open('Self-Service Requests', const RequestsScreen()); return;
      case 'announcements': _open('Announcements', const AnnouncementsScreen()); return;
      case 'documents': _open('Document Center', const DocumentsScreen()); return;
      case 'profile': _open('My Profile', ProfileScreen(onSignOut: _signOut)); return;
      case 'settings': _open('App Settings', SettingsScreen(onThemeToggle: widget.onThemeToggle)); return;
      default: _tab = 4;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pages = _manager
        ? <Widget>[
      HomeScreen(manager: true, onNavigate: _openModule),
      AttendanceScreen(),
      const TeamScreen(),
      const LeaveScreen(manager: true),
      _MoreMenu(onOpen: _openModule, manager: true, onSignOut: _signOut),
    ]
        : <Widget>[
      HomeScreen(manager: false, onNavigate: _openModule),
      AttendanceScreen(),
      const LeaveScreen(manager: false),
      NotificationsScreen(onOpen: _openModule),
      _MoreMenu(onOpen: _openModule, manager: false, onSignOut: _signOut),
    ];
    final titles = _manager ? ['Pulse HRMS', 'Clock & Time Tracking', 'My Team', 'Leave Management', 'All Modules'] : ['Pulse HRMS', 'Clock & Time Tracking', 'Leave Management', 'Notifications', 'All Modules'];
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_tab], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        actions: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Center(child: Text(_manager ? 'MANAGER' : 'EMPLOYEE', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)))),
          IconButton(onPressed: widget.onThemeToggle, icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined)),
        ],
      ),
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: _manager ? const [NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'), NavigationDestination(icon: Icon(Icons.access_time), label: 'Attendance'), NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'My Team'), NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Leave'), NavigationDestination(icon: Icon(Icons.grid_view_outlined), label: 'More')] : const [NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'), NavigationDestination(icon: Icon(Icons.access_time), label: 'Attendance'), NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Leave'), NavigationDestination(icon: Badge(child: Icon(Icons.notifications_outlined)), label: 'Alerts'), NavigationDestination(icon: Icon(Icons.grid_view_outlined), label: 'More')],
      ),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({required this.onOpen, required this.manager, required this.onSignOut});
  final ValueChanged<String> onOpen;
  final bool manager;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final employeeItems = <(String, IconData, String)>[
      ('Payslips', Icons.description_outlined, 'payslips'),
      ('Performance & Goals', Icons.workspace_premium_outlined, 'performance'), ('Helpdesk & Support', Icons.support_agent_outlined, 'helpdesk'),
      ('Master Calendar', Icons.calendar_month_outlined, 'calendar'), ('Self-Service Requests', Icons.send_outlined, 'requests'),
      ('Document Center', Icons.folder_outlined, 'documents'),
      ('My Profile', Icons.person_outline, 'profile'), ('App Settings', Icons.settings_outlined, 'settings'),
    ];
    final managerItems = <(String, IconData, String)>[('Leave Approvals', Icons.check_box_outlined, 'leaveApprovals'), ('My Team', Icons.groups_outlined, 'team'), ('Team Attendance', Icons.access_time, 'teamAttendance'), ('Team Performance', Icons.trending_up, 'teamPerformance')];
    final items = manager ? [...managerItems, ...employeeItems] : employeeItems;
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .98, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemBuilder: (context, index) { final item = items[index]; return Material(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16), child: InkWell(borderRadius: BorderRadius.circular(16), onTap: () => onOpen(item.$3), child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(backgroundColor: AppColors.primary.withValues(alpha: .15), child: Icon(item.$2, color: AppColors.primary)), const Spacer(), Text(item.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800))])))); }),
      const SizedBox(height: 18),
      OutlinedButton.icon(onPressed: onSignOut, icon: const Icon(Icons.logout, color: AppColors.danger), label: const Text('Sign Out Account', style: TextStyle(color: AppColors.danger))),
    ]);
  }
}