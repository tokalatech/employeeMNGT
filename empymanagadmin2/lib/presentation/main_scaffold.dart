import 'package:flutter/material.dart';
import 'pages_dev1/dashboard_page.dart';
import 'pages_dev1/employees_page.dart';
import 'pages_dev1/attendance_page.dart';
import 'pages_dev1/payroll_page.dart';
import 'pages_dev1/performance_page.dart';
import 'pages_dev1/analytics_page.dart';
import 'pages_dev1/calendar_page.dart';
import 'pages_dev1/settings_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),                          // Index 0
    const EmployeesPage(),                          // Index 1
    const AttendancePage(),                         // Index 2
    const Dev2Placeholder(title: 'Leave Management'),// Index 3
    const PayrollPage(),                            // Index 4
    const PerformancePage(),                        // Index 5
    const Dev2Placeholder(title: 'Support Helpdesk'),// Index 6
    const CalendarPage(),                           // Index 7
    const Dev2Placeholder(title: 'Self-Service Requests'), // Index 8
    const Dev2Placeholder(title: 'Departments'),   // Index 9
    const Dev2Placeholder(title: 'Announcements'), // Index 10
    const Dev2Placeholder(title: 'Document Center'),// Index 11
    const AnalyticsPage(),                          // Index 12
    const Dev2Placeholder(title: 'Audit Logs'),    // Index 13
    const SettingsPage(),                           // Index 14
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Sidebar
          Container(
            width: 260,
            color: const Color(0xFF0F172A),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nexus HRMS',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Employee Management & HR Operations',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _navItem(0, Icons.dashboard, 'Dashboard'),
                      _navItem(1, Icons.people, 'Employees'),
                      _navItem(2, Icons.access_time, 'Attendance'),
                      _navItem(3, Icons.event_note, 'Leave Management', badge: '2'),
                      _navItem(4, Icons.attach_money, 'Payroll & Payslips'),
                      _navItem(5, Icons.track_changes, 'Goals & Performance'),
                      _navItem(6, Icons.support_agent, 'Support Helpdesk', badge: '1'),
                      _navItem(7, Icons.calendar_month, 'Master Calendar'),
                      _navItem(8, Icons.assignment_ind, 'Self-Service Requests'),
                      _navItem(9, Icons.business, 'Departments'),
                      _navItem(10, Icons.campaign, 'Announcements'),
                      _navItem(11, Icons.folder, 'Document Center'),
                      _navItem(12, Icons.bar_chart, 'Analytics & Reports'),
                      _navItem(13, Icons.security, 'Audit Logs', badge: '1'),
                      _navItem(14, Icons.settings, 'System Settings'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                Container(
                  height: 65,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 380,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search employees by name, ID, or department...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            filled: true,
                            fillColor: const Color(0xFFF1F5F9),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            backgroundColor: Color(0xFF6366F1),
                            child: Text('SJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sarah Jenkins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('VP of Human Resources', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),

                // Main Dynamic Page View
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String title, {String? badge}) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        selected: isSelected,
        selectedTileColor: const Color(0xFF4F46E5),
        leading: Icon(icon, size: 18, color: isSelected ? Colors.white : const Color(0xFF94A3B8)),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: badge != null
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            badge,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        )
            : null,
        onTap: () => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class Dev2Placeholder extends StatelessWidget {
  final String title;
  const Dev2Placeholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Page\n(Assigned to Developer 2)',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}