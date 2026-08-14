import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  String _tab = 'Goals';
  final _goals = const [
    [
      'Mobile App Flutter UI System',
      '84',
      'On Track',
      'Complete 25+ pixel-perfect screen designs',
    ],
    [
      'Design System Token Accessibility',
      '100',
      'Completed',
      'Ensure WCAG AA compliance across the design system',
    ],
    [
      'User Micro-Interactions & Transitions',
      '65',
      'At Risk',
      'Craft fluid motion states and transitions',
    ],
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _tabs(),
      const SizedBox(height: 14),
      if (_tab == 'Goals') ..._goals.map(_goal) else _reviews(),
    ],
  );

  Widget _tabs() => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: ['Goals', 'Reviews']
          .map(
            (x) => Expanded(
              child: TextButton(
                onPressed: () => setState(() => _tab = x),
                style: TextButton.styleFrom(
                  backgroundColor: _tab == x
                      ? Theme.of(context).colorScheme.surface
                      : null,
                ),
                child: Text(
                  x,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _tab == x ? AppColors.primary : null,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _goal(List<String> g) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: PulseCard(
      onTap: () => _details(g),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  g[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                g[2],
                style: TextStyle(
                  color: g[2] == 'At Risk'
                      ? AppColors.danger
                      : AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: int.parse(g[1]) / 100,
            color: g[2] == 'At Risk' ? AppColors.danger : AppColors.primary,
            minHeight: 7,
          ),
          const SizedBox(height: 5),
          Text('${g[1]}% complete', style: const TextStyle(fontSize: 11)),
        ],
      ),
    ),
  );

  Widget _reviews() => Column(
    children: [
      PulseCard(
        onTap: _reviewDetails,
        child: const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Color(0xFFEDE9FE),
            child: Icon(Icons.star, color: AppColors.primary),
          ),
          title: Text(
            'H1 2026 Performance Review',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            'Completed · 15 Jul 2026',
            style: TextStyle(fontSize: 11),
          ),
          trailing: Text(
            '4.8 / 5',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    ],
  );

  void _details(List<String> g) => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (c) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            g[0],
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Text('KPI: ${g[3]}'),
          Text('Progress: ${g[1]}% · ${g[2]}'),
          const SizedBox(height: 10),
          const Text(
            'Manager comments: Great progress on this objective.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );

  void _reviewDetails() => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (c) => const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'H1 2026 Performance Review',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10),
          Text('Overall Rating: 4.8 / 5.0'),
          SizedBox(height: 8),
          Text(
            'Strengths: Mobile-first UI architecture, team communication, and consistent design tokens.',
          ),
          SizedBox(height: 8),
          Text('Areas for improvement: Expand remote field-user testing.'),
          SizedBox(height: 15),
        ],
      ),
    ),
  );
}
