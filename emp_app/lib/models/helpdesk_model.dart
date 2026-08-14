enum HelpdeskCategory {
  itSupport,
  hrQuery,
  payroll,
  facilities,
  other,
}

enum HelpdeskPriority {
  low,
  medium,
  high,
  urgent,
}

enum HelpdeskStatus {
  open,
  inProgress,
  resolved,
}

class HelpdeskTicket {
  final String id;
  final String ticketNumber;
  final String subject;
  final HelpdeskCategory category;
  final HelpdeskPriority priority;
  final HelpdeskStatus status;
  final String createdAt;
  final String description;
  final List<HelpdeskMessage> messages;

  HelpdeskTicket({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.description,
    required this.messages,
  });

  factory HelpdeskTicket.fromMap(Map<String, dynamic> map) {
    return HelpdeskTicket(
      id: map['id'] ?? '',
      ticketNumber: map['ticketNumber'] ?? '',
      subject: map['subject'] ?? '',
      category: helpdeskCategoryFromString(map['category']),
      priority: helpdeskPriorityFromString(map['priority']),
      status: helpdeskStatusFromString(map['status']),
      createdAt: map['createdAt'] ?? '',
      description: map['description'] ?? '',
      messages: (map['messages'] as List<dynamic>? ?? [])
          .map(
            (item) => HelpdeskMessage.fromMap(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'subject': subject,
      'category': helpdeskCategoryToString(category),
      'priority': helpdeskPriorityToString(priority),
      'status': helpdeskStatusToString(status),
      'createdAt': createdAt,
      'description': description,
      'messages': messages.map((item) => item.toMap()).toList(),
    };
  }
}

class HelpdeskMessage {
  final String id;
  final String senderName;
  final String senderAvatar;
  final bool isStaff;
  final String text;
  final String timestamp;

  HelpdeskMessage({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.isStaff,
    required this.text,
    required this.timestamp,
  });

  factory HelpdeskMessage.fromMap(Map<String, dynamic> map) {
    return HelpdeskMessage(
      id: map['id'] ?? '',
      senderName: map['senderName'] ?? '',
      senderAvatar: map['senderAvatar'] ?? '',
      isStaff: map['isStaff'] ?? false,
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'isStaff': isStaff,
      'text': text,
      'timestamp': timestamp,
    };
  }
}

HelpdeskCategory helpdeskCategoryFromString(String? value) {
  switch (value) {
    case 'HR Query':
      return HelpdeskCategory.hrQuery;
    case 'Payroll':
      return HelpdeskCategory.payroll;
    case 'Facilities':
      return HelpdeskCategory.facilities;
    case 'Other':
      return HelpdeskCategory.other;
    default:
      return HelpdeskCategory.itSupport;
  }
}

String helpdeskCategoryToString(HelpdeskCategory value) {
  switch (value) {
    case HelpdeskCategory.itSupport:
      return 'IT Support';
    case HelpdeskCategory.hrQuery:
      return 'HR Query';
    case HelpdeskCategory.payroll:
      return 'Payroll';
    case HelpdeskCategory.facilities:
      return 'Facilities';
    case HelpdeskCategory.other:
      return 'Other';
  }
}

HelpdeskPriority helpdeskPriorityFromString(String? value) {
  switch (value) {
    case 'Medium':
      return HelpdeskPriority.medium;
    case 'High':
      return HelpdeskPriority.high;
    case 'Urgent':
      return HelpdeskPriority.urgent;
    default:
      return HelpdeskPriority.low;
  }
}

String helpdeskPriorityToString(HelpdeskPriority value) {
  switch (value) {
    case HelpdeskPriority.low:
      return 'Low';
    case HelpdeskPriority.medium:
      return 'Medium';
    case HelpdeskPriority.high:
      return 'High';
    case HelpdeskPriority.urgent:
      return 'Urgent';
  }
}

HelpdeskStatus helpdeskStatusFromString(String? value) {
  switch (value) {
    case 'In Progress':
      return HelpdeskStatus.inProgress;
    case 'Resolved':
      return HelpdeskStatus.resolved;
    default:
      return HelpdeskStatus.open;
  }
}

String helpdeskStatusToString(HelpdeskStatus value) {
  switch (value) {
    case HelpdeskStatus.open:
      return 'Open';
    case HelpdeskStatus.inProgress:
      return 'In Progress';
    case HelpdeskStatus.resolved:
      return 'Resolved';
  }
}