enum AnnouncementCategory {
  company,
  policy,
  event,
  hrNotice,
}

enum AnnouncementPriority {
  high,
  normal,
}

class Announcement {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String publishedDate;
  final AnnouncementCategory category;
  final AnnouncementPriority priority;
  final bool isRead;
  final String author;

  Announcement({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedDate,
    required this.category,
    required this.priority,
    required this.isRead,
    required this.author,
  });

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      summary: map['summary'] ?? '',
      content: map['content'] ?? '',
      publishedDate: map['publishedDate'] ?? '',
      category: announcementCategoryFromString(map['category']),
      priority: map['priority'] == 'High'
          ? AnnouncementPriority.high
          : AnnouncementPriority.normal,
      isRead: map['isRead'] ?? false,
      author: map['author'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'publishedDate': publishedDate,
      'category': announcementCategoryToString(category),
      'priority': priority == AnnouncementPriority.high
          ? 'High'
          : 'Normal',
      'isRead': isRead,
      'author': author,
    };
  }
}

AnnouncementCategory announcementCategoryFromString(String? value) {
  switch (value) {
    case 'Policy':
      return AnnouncementCategory.policy;
    case 'Event':
      return AnnouncementCategory.event;
    case 'HR Notice':
      return AnnouncementCategory.hrNotice;
    default:
      return AnnouncementCategory.company;
  }
}

String announcementCategoryToString(AnnouncementCategory value) {
  switch (value) {
    case AnnouncementCategory.company:
      return 'Company';
    case AnnouncementCategory.policy:
      return 'Policy';
    case AnnouncementCategory.event:
      return 'Event';
    case AnnouncementCategory.hrNotice:
      return 'HR Notice';
  }
}