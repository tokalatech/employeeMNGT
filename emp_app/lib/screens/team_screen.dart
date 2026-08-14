import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  String _tab = 'Directory';
  final _members = const [
    ['Alex Morgan', 'Senior UI/UX Designer', 'Present', '4.8'],
    ['Marcus Vance', 'Staff Product Designer', 'Work From Home', '4.9'],
    ['Elena Rostova', 'UX Researcher', 'Present', '4.6'],
    ['David Chen', 'Design Systems Engineer', 'On Leave', '4.9'],
    ['Sophia Patel', 'Junior Visual Designer', 'Late', '4.4'],
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _tabs(),
      const SizedBox(height: 15),
      if (_tab == 'Directory')
        ..._members.map(_member)
      else if (_tab == 'Attendance')
        _attendance()
      else
        _performance(),
    ],
  );

  Widget _tabs() => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: ['Directory', 'Attendance', 'Performance']
          .map(
            (label) => Expanded(
              child: TextButton(
                onPressed: () => setState(() => _tab = label),
                style: TextButton.styleFrom(
                  backgroundColor: _tab == label
                      ? Theme.of(context).colorScheme.surface
                      : null,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _tab == label ? AppColors.primary : null,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _member(List<String> member) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: PulseCard(
      onTap: () => _detail(member),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: .15),
          child: Text(
            member[0].split(' ').map((x) => x[0]).join(),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        title: Text(
          member[0],
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(member[1], style: const TextStyle(fontSize: 11)),
        trailing: Text(
          member[2],
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
        ),
      ),
    ),
  );

  Widget _attendance() => Column(
    children: _members
        .map(
          (member) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: PulseCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(member[0]),
                subtitle: Text(
                  member[2] == 'On Leave'
                      ? 'On approved leave'
                      : 'Clocked in at ${member[2] == 'Late' ? '09:40 AM' : '08:58 AM'}',
                ),
                trailing: Text(
                  member[2],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        )
        .toList(),
  );

  Widget _performance() => Column(
    children: _members
        .map(
          (member) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: PulseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member[0],
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: double.parse(member[3]) / 5,
                    color: AppColors.primary,
                    minHeight: 7,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Performance rating: ${member[3]} / 5',
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList(),
  );

  void _detail(List<String> m) => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            m[0],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          Text(m[1]),
          const SizedBox(height: 12),
          Text('Today: ${m[2]}'),
          const Text('Department: Product & Design'),
          const Text('Email: employee@company.com'),
          const SizedBox(height: 15),
        ],
      ),
    ),
  );
}
