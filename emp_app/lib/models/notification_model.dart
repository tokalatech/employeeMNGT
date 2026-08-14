enum AppStateMode {
  normal,
  loading,
  empty,
  error,
  offline,
}

enum ScreenId {
  splash,
  login,
  home,
  attendance,
  leave,
  managerLeaveApprovals,
  myTeam,
  teamAttendance,
  teamPerformance,
  payslips,
  performance,
  helpdesk,
  calendar,
  requests,
  announcements,
  documents,
  notifications,
  profile,
  settings,
  more,
}

enum NotificationCategory {
  leave,
  attendance,
  payroll,
  performance,
  announcements,
  helpdesk,
  requests,
}

class AppNotification {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final NotificationCategory category;
  final bool isRead;
  final ScreenId? targetScreen;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    required this.isRead,
    this.targetScreen,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      timestamp: map['timestamp'] ?? '',
      category: notificationCategoryFromString(map['category']),
      isRead: map['isRead'] ?? false,
      targetScreen: screenIdFromString(map['targetScreen']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'category': notificationCategoryToString(category),
      'isRead': isRead,
      'targetScreen': targetScreen != null
          ? screenIdToString(targetScreen!)
          : null,
    };
  }
}

NotificationCategory notificationCategoryFromString(String? value) {
  switch (value) {
    case 'Attendance':
      return NotificationCategory.attendance;
    case 'Payroll':
      return NotificationCategory.payroll;
    case 'Performance':
      return NotificationCategory.performance;
    case 'Announcements':
      return NotificationCategory.announcements;
    case 'Helpdesk':
      return NotificationCategory.helpdesk;
    case 'Requests':
      return NotificationCategory.requests;
    default:
      return NotificationCategory.leave;
  }
}

String notificationCategoryToString(NotificationCategory value) {
  switch (value) {
    case NotificationCategory.leave:
      return 'Leave';
    case NotificationCategory.attendance:
      return 'Attendance';
    case NotificationCategory.payroll:
      return 'Payroll';
    case NotificationCategory.performance:
      return 'Performance';
    case NotificationCategory.announcements:
      return 'Announcements';
    case NotificationCategory.helpdesk:
      return 'Helpdesk';
    case NotificationCategory.requests:
      return 'Requests';
  }
}

ScreenId? screenIdFromString(String? value) {
  switch (value) {
    case 'splash':
      return ScreenId.splash;
    case 'login':
      return ScreenId.login;
    case 'home':
      return ScreenId.home;
    case 'attendance':
      return ScreenId.attendance;
    case 'leave':
      return ScreenId.leave;
    case 'manager_leave_approvals':
      return ScreenId.managerLeaveApprovals;
    case 'my_team':
      return ScreenId.myTeam;
    case 'team_attendance':
      return ScreenId.teamAttendance;
    case 'team_performance':
      return ScreenId.teamPerformance;
    case 'payslips':
      return ScreenId.payslips;
    case 'performance':
      return ScreenId.performance;
    case 'helpdesk':
      return ScreenId.helpdesk;
    case 'calendar':
      return ScreenId.calendar;
    case 'requests':
      return ScreenId.requests;
    case 'announcements':
      return ScreenId.announcements;
    case 'documents':
      return ScreenId.documents;
    case 'notifications':
      return ScreenId.notifications;
    case 'profile':
      return ScreenId.profile;
    case 'settings':
      return ScreenId.settings;
    case 'more':
      return ScreenId.more;
    default:
      return null;
  }
}

String screenIdToString(ScreenId value) {
  switch (value) {
    case ScreenId.splash:
      return 'splash';
    case ScreenId.login:
      return 'login';
    case ScreenId.home:
      return 'home';
    case ScreenId.attendance:
      return 'attendance';
    case ScreenId.leave:
      return 'leave';
    case ScreenId.managerLeaveApprovals:
      return 'manager_leave_approvals';
    case ScreenId.myTeam:
      return 'my_team';
    case ScreenId.teamAttendance:
      return 'team_attendance';
    case ScreenId.teamPerformance:
      return 'team_performance';
    case ScreenId.payslips:
      return 'payslips';
    case ScreenId.performance:
      return 'performance';
    case ScreenId.helpdesk:
      return 'helpdesk';
    case ScreenId.calendar:
      return 'calendar';
    case ScreenId.requests:
      return 'requests';
    case ScreenId.announcements:
      return 'announcements';
    case ScreenId.documents:
      return 'documents';
    case ScreenId.notifications:
      return 'notifications';
    case ScreenId.profile:
      return 'profile';
    case ScreenId.settings:
      return 'settings';
    case ScreenId.more:
      return 'more';
  }
}