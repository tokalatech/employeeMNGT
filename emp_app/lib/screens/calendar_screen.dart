import 'package:flutter/material.dart';
import '../models/calendar_event_model.dart';
import '../services/calendar_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarService _calendarService = CalendarService();
  int _selected = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CalendarEvent>>(
      stream: _calendarService.watchEvents(),
      builder: (context, snapshot) {
        final events = snapshot.data ?? [];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _month(),
            const SizedBox(height: 17),
            Text(
              'UPCOMING EVENTS · ${DateTime.now().month}/$_selected',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 9),
            if (events.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    'No company events or holidays scheduled yet.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              )
            else
              ...events.map(_eventCard),
          ],
        );
      },
    );
  }

  Widget _month() => PulseCard(
    child: Column(
      children: [
        Text(
          'CALENDAR ${DateTime.now().year}',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(31, (index) {
            final day = index + 1;
            final isSelected = _selected == day;
            return InkWell(
              onTap: () => setState(() => _selected = day),
              child: Container(
                margin: const EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : null,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? Colors.white : null,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    ),
  );

  Widget _eventCard(CalendarEvent event) {
    final typeStr = calendarEventTypeToString(event.type);
    final color = event.type == CalendarEventType.holiday
        ? AppColors.danger
        : event.type == CalendarEventType.leave
        ? AppColors.primary
        : event.type == CalendarEventType.deadline
        ? AppColors.warning
        : AppColors.success;

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: PulseCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(width: 5, height: 38, color: color),
          title: Text(
            event.title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          ),
          subtitle: Text(
            '$typeStr · ${event.date}${event.description != null && event.description!.isNotEmpty ? " · ${event.description}" : ""}',
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
    );
  }
}
