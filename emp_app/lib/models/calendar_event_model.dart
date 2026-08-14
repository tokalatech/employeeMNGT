enum CalendarEventType {
  holiday,
  leave,
  companyEvent,
  deadline,
}

class CalendarEvent {
  final String id;
  final String title;
  final String date;
  final CalendarEventType type;
  final String? description;
  final String color;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.description,
    required this.color,
  });

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      type: calendarEventTypeFromString(map['type']),
      description: map['description'],
      color: map['color'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'type': calendarEventTypeToString(type),
      'description': description,
      'color': color,
    };
  }
}

CalendarEventType calendarEventTypeFromString(String? value) {
  switch (value) {
    case 'Leave':
      return CalendarEventType.leave;
    case 'Company Event':
      return CalendarEventType.companyEvent;
    case 'Deadline':
      return CalendarEventType.deadline;
    default:
      return CalendarEventType.holiday;
  }
}

String calendarEventTypeToString(CalendarEventType value) {
  switch (value) {
    case CalendarEventType.holiday:
      return 'Holiday';
    case CalendarEventType.leave:
      return 'Leave';
    case CalendarEventType.companyEvent:
      return 'Company Event';
    case CalendarEventType.deadline:
      return 'Deadline';
  }
}