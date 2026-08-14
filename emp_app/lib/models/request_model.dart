enum SelfServiceRequestType {
  attendanceCorrection,
  employmentCertificate,
  documentRequest,
  profileUpdate,
  bankDetailChange,
}

enum SelfServiceRequestStatus {
  pending,
  approved,
  rejected,
  completed,
}

class SelfServiceRequest {
  final String id;
  final SelfServiceRequestType requestType;
  final String appliedDate;
  final String description;
  final SelfServiceRequestStatus status;
  final String? comments;
  final String? attachmentName;

  SelfServiceRequest({
    required this.id,
    required this.requestType,
    required this.appliedDate,
    required this.description,
    required this.status,
    this.comments,
    this.attachmentName,
  });

  factory SelfServiceRequest.fromMap(Map<String, dynamic> map) {
    return SelfServiceRequest(
      id: map['id'] ?? '',
      requestType: requestTypeFromString(map['requestType']),
      appliedDate: map['appliedDate'] ?? '',
      description: map['description'] ?? '',
      status: requestStatusFromString(map['status']),
      comments: map['comments'],
      attachmentName: map['attachmentName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestType': requestTypeToString(requestType),
      'appliedDate': appliedDate,
      'description': description,
      'status': requestStatusToString(status),
      'comments': comments,
      'attachmentName': attachmentName,
    };
  }
}

SelfServiceRequestType requestTypeFromString(String? value) {
  switch (value) {
    case 'Employment Certificate':
      return SelfServiceRequestType.employmentCertificate;
    case 'Document Request':
      return SelfServiceRequestType.documentRequest;
    case 'Profile Update':
      return SelfServiceRequestType.profileUpdate;
    case 'Bank Detail Change':
      return SelfServiceRequestType.bankDetailChange;
    default:
      return SelfServiceRequestType.attendanceCorrection;
  }
}

String requestTypeToString(SelfServiceRequestType value) {
  switch (value) {
    case SelfServiceRequestType.attendanceCorrection:
      return 'Attendance Correction';
    case SelfServiceRequestType.employmentCertificate:
      return 'Employment Certificate';
    case SelfServiceRequestType.documentRequest:
      return 'Document Request';
    case SelfServiceRequestType.profileUpdate:
      return 'Profile Update';
    case SelfServiceRequestType.bankDetailChange:
      return 'Bank Detail Change';
  }
}

SelfServiceRequestStatus requestStatusFromString(String? value) {
  switch (value) {
    case 'Approved':
      return SelfServiceRequestStatus.approved;
    case 'Rejected':
      return SelfServiceRequestStatus.rejected;
    case 'Completed':
      return SelfServiceRequestStatus.completed;
    default:
      return SelfServiceRequestStatus.pending;
  }
}

String requestStatusToString(SelfServiceRequestStatus value) {
  switch (value) {
    case SelfServiceRequestStatus.pending:
      return 'Pending';
    case SelfServiceRequestStatus.approved:
      return 'Approved';
    case SelfServiceRequestStatus.rejected:
      return 'Rejected';
    case SelfServiceRequestStatus.completed:
      return 'Completed';
  }
}