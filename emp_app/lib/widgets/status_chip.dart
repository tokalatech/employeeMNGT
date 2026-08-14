import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color =
        status.contains('Approved') ||
            status.contains('Present') ||
            status.contains('Paid')
        ? Colors.green
        : status.contains('Pending') || status.contains('Late')
        ? Colors.orange
        : status.contains('Rejected') || status.contains('Absent')
        ? Colors.red
        : Colors.blue;
    return Chip(
      label: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
