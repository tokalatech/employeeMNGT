import 'package:flutter/material.dart';

// import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

/// Reusable local-data detail flow used by feature routes until API repositories are connected.
class FlowDetailScreen extends StatelessWidget {
  const FlowDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.sections,
    this.action = 'Done',
  });

  final String title, subtitle, action;
  final List<(String, String)> sections;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
        const SizedBox(height: 16),
        ...sections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PulseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.$1.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(section.$2, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
        PrimaryButton(
          label: action,
          icon: Icons.check_circle_outline,
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$title updated locally.')));
          },
        ),
      ],
    ),
  );
}
