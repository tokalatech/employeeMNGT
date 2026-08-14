import 'package:flutter/material.dart';
import 'status_chip.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.name,
    required this.designation,
    required this.status,
    this.onTap,
  });

  final String name, designation, status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Text(name.split(' ').map((e) => e[0]).join()),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(designation),
      trailing: StatusChip(status: status),
    ),
  );
}
