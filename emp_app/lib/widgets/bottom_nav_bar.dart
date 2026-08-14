import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: index,
    onDestinationSelected: onChanged,
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.access_time), label: 'Attendance'),
      NavigationDestination(
        icon: Icon(Icons.calendar_month_outlined),
        label: 'Leave',
      ),
      NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        label: 'Alerts',
      ),
      NavigationDestination(
        icon: Icon(Icons.grid_view_outlined),
        label: 'More',
      ),
    ],
  );
}
