import 'package:flutter/material.dart';

class LeaveBalanceCard extends StatelessWidget {
  const LeaveBalanceCard({
    super.key,
    required this.label,
    required this.remaining,
    required this.total,
    this.color = Colors.indigo,
  });

  final String label;
  final int remaining, total;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
          Text('$remaining days left'),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: remaining / total, color: color),
        ],
      ),
    ),
  );
}
