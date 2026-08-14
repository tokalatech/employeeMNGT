import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class TeamPerfomanceScreen extends StatelessWidget {
  const TeamPerfomanceScreen({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: const [
      Text(
        'TEAM PERFORMANCE',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
        ),
      ),
      SizedBox(height: 12),
      _Kpi(
        name: 'Alex Morgan',
        role: 'Senior UI/UX Designer',
        progress: .84,
        rating: '4.8 / 5',
      ),
      SizedBox(height: 10),
      _Kpi(
        name: 'Marcus Vance',
        role: 'Staff Product Designer',
        progress: .91,
        rating: '4.9 / 5',
      ),
      SizedBox(height: 10),
      _Kpi(
        name: 'Elena Rostova',
        role: 'UX Researcher',
        progress: .76,
        rating: '4.6 / 5',
      ),
    ],
  );
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.name,
    required this.role,
    required this.progress,
    required this.rating,
  });

  final String name, role, rating;
  final double progress;

  @override
  Widget build(BuildContext context) => PulseCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(role, style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
            Text(
              rating,
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          color: AppColors.primary,
          minHeight: 7,
        ),
        const SizedBox(height: 5),
        Text(
          '${(progress * 100).round()}% goal completion',
          style: const TextStyle(fontSize: 11),
        ),
      ],
    ),
  );
}
