enum GoalStatus {
  onTrack,
  atRisk,
  completed,
  pending,
}

class Goal {
  final String id;
  final String title;
  final String description;
  final String kpi;
  final String target;
  final String currentValue;
  final double progressPercent;
  final String deadline;
  final GoalStatus status;
  final String? managerComments;
  final String? assignedToName;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.kpi,
    required this.target,
    required this.currentValue,
    required this.progressPercent,
    required this.deadline,
    required this.status,
    this.managerComments,
    this.assignedToName,
  });

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      kpi: map['kpi'] ?? '',
      target: map['target'] ?? '',
      currentValue: map['currentValue'] ?? '',
      progressPercent: (map['progressPercent'] ?? 0).toDouble(),
      deadline: map['deadline'] ?? '',
      status: goalStatusFromString(map['status']),
      managerComments: map['managerComments'],
      assignedToName: map['assignedToName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'kpi': kpi,
      'target': target,
      'currentValue': currentValue,
      'progressPercent': progressPercent,
      'deadline': deadline,
      'status': goalStatusToString(status),
      'managerComments': managerComments,
      'assignedToName': assignedToName,
    };
  }
}

GoalStatus goalStatusFromString(String? value) {
  switch (value) {
    case 'On Track':
      return GoalStatus.onTrack;
    case 'At Risk':
      return GoalStatus.atRisk;
    case 'Completed':
      return GoalStatus.completed;
    default:
      return GoalStatus.pending;
  }
}

String goalStatusToString(GoalStatus value) {
  switch (value) {
    case GoalStatus.onTrack:
      return 'On Track';
    case GoalStatus.atRisk:
      return 'At Risk';
    case GoalStatus.completed:
      return 'Completed';
    case GoalStatus.pending:
      return 'Pending';
  }
}