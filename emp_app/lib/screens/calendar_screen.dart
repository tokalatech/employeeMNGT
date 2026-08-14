import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selected = 13;
  final _events = const [
    ['Q3 All-Hands Meeting', 'Company Event', '10:00 AM'],
    ['Alex Lake Tahoe Leave', 'Leave', 'All day'],
    ['H2 Performance Review Deadline', 'Deadline', 'All day'],
    ['Labor Day Public Holiday', 'Holiday', 'September 7'],
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _month(),
      const SizedBox(height: 17),
      Text(
        'UPCOMING EVENTS · AUG $_selected',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
        ),
      ),
      const SizedBox(height: 9),
      ..._events.map(_event),
    ],
  );

  Widget _month() => PulseCard(
    child: Column(
      children: [
        const Text(
          'AUGUST 2026',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(31, (index) {
            final day = index + 1;
            final marked = [13, 25, 31].contains(day);
            return InkWell(
              onTap: () => setState(() => _selected = day),
              child: Container(
                margin: const EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selected == day
                      ? AppColors.primary
                      : marked
                      ? AppColors.primary.withValues(alpha: .15)
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 11,
                    color: _selected == day ? Colors.white : null,
                    fontWeight: marked ? FontWeight.w800 : null,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    ),
  );

  Widget _event(List<String> event) {
    final color = event[1] == 'Holiday'
        ? AppColors.danger
        : event[1] == 'Leave'
        ? AppColors.primary
        : event[1] == 'Deadline'
        ? AppColors.warning
        : AppColors.success;
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: PulseCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(width: 5, height: 38, color: color),
          title: Text(
            event[0],
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          ),
          subtitle: Text(
            '${event[1]} · ${event[2]}',
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
    );
  }
}
