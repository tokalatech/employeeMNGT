enum LeaveType {
  paidLeave,
  casualLeave,
  sickLeave,
  maternityPaternity,
}

enum LeaveRequestStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

class LeaveBalance {
  final LeaveType type;
  final int total;
  final int used;
  final int remaining;
  final String color;

  LeaveBalance({
    required this.type,
    required this.total,
    required this.used,
    required this.remaining,
    required this.color,
  });

  factory LeaveBalance.fromMap(Map<String, dynamic> map) {
    return LeaveBalance(
      type: leaveTypeFromString(map['type']),
      total: map['total'] ?? 0,
      used: map['used'] ?? 0,
      remaining: map['remaining'] ?? 0,
      color: map['color'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': leaveTypeToString(type),
      'total': total,
      'used': used,
      'remaining': remaining,
      'color': color,
    };
  }
}

class LeaveRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeAvatar;
  final String department;
  final LeaveType leaveType;
  final String startDate;
  final String endDate;
  final int totalDays;
  final String reason;
  final String? attachmentName;
  final LeaveRequestStatus status;
  final String appliedDate;
  final String? reviewedBy;
  final String? reviewedAt;
  final String? rejectionReason;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeAvatar,
    required this.department,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    this.attachmentName,
    required this.status,
    required this.appliedDate,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
  });

  factory LeaveRequest.fromMap(Map<String, dynamic> map) {
    return LeaveRequest(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      employeeAvatar: map['employeeAvatar'] ?? '',
      department: map['department'] ?? '',
      leaveType: leaveTypeFromString(map['leaveType']),
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      totalDays: map['totalDays'] ?? 0,
      reason: map['reason'] ?? '',
      attachmentName: map['attachmentName'],
      status: leaveRequestStatusFromString(map['status']),
      appliedDate: map['appliedDate'] ?? '',
      reviewedBy: map['reviewedBy'],
      reviewedAt: map['reviewedAt'],
      rejectionReason: map['rejectionReason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeeAvatar': employeeAvatar,
      'department': department,
      'leaveType': leaveTypeToString(leaveType),
      'startDate': startDate,
      'endDate': endDate,
      'totalDays': totalDays,
      'reason': reason,
      'attachmentName': attachmentName,
      'status': leaveRequestStatusToString(status),
      'appliedDate': appliedDate,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt,
      'rejectionReason': rejectionReason,
    };
  }
}

LeaveType leaveTypeFromString(String? value) {
  switch (value) {
    case 'Casual Leave':
      return LeaveType.casualLeave;
    case 'Sick Leave':
      return LeaveType.sickLeave;
    case 'Maternity/Paternity':
      return LeaveType.maternityPaternity;
    default:
      return LeaveType.paidLeave;
  }
}

String leaveTypeToString(LeaveType value) {
  switch (value) {
    case LeaveType.paidLeave:
      return 'Paid Leave';
    case LeaveType.casualLeave:
      return 'Casual Leave';
    case LeaveType.sickLeave:
      return 'Sick Leave';
    case LeaveType.maternityPaternity:
      return 'Maternity/Paternity';
  }
}

LeaveRequestStatus leaveRequestStatusFromString(String? value) {
  switch (value) {
    case 'Approved':
      return LeaveRequestStatus.approved;
    case 'Rejected':
      return LeaveRequestStatus.rejected;
    case 'Cancelled':
      return LeaveRequestStatus.cancelled;
    default:
      return LeaveRequestStatus.pending;
  }
}

String leaveRequestStatusToString(LeaveRequestStatus value) {
  switch (value) {
    case LeaveRequestStatus.pending:
      return 'Pending';
    case LeaveRequestStatus.approved:
      return 'Approved';
    case LeaveRequestStatus.rejected:
      return 'Rejected';
    case LeaveRequestStatus.cancelled:
      return 'Cancelled';
  }
}
