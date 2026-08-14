import 'package:flutter/material.dart';
import 'status_chip.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({
    super.key,
    required this.date,
    required this.status,
    required this.summary,
    this.onTap,
  });

  final String date, status, summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      onTap: onTap,
      title: Text(date, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(summary),
      trailing: StatusChip(status: status),
    ),
  );
}
