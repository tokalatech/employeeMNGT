enum AttendanceStatus {
  notCheckedIn,
  working,
  completed,
  late,
  halfDay,
  absent,
  onLeave,
}

enum AttendanceRecordStatus {
  present,
  late,
  halfDay,
  absent,
  onLeave,
}

class AttendanceRecord {
  final String id;
  final String date;
  final AttendanceRecordStatus status;
  final String? clockIn;
  final String? clockOut;
  final String? totalHours;
  final String? breakDuration;
  final String? notes;
  final bool? isCorrectionRequested;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.status,
    this.clockIn,
    this.clockOut,
    this.totalHours,
    this.breakDuration,
    this.notes,
    this.isCorrectionRequested,
  });

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      status: _recordStatusFromString(map['status']),
      clockIn: map['clockIn'],
      clockOut: map['clockOut'],
      totalHours: map['totalHours'],
      breakDuration: map['breakDuration'],
      notes: map['notes'],
      isCorrectionRequested: map['isCorrectionRequested'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'status': _recordStatusToString(status),
      'clockIn': clockIn,
      'clockOut': clockOut,
      'totalHours': totalHours,
      'breakDuration': breakDuration,
      'notes': notes,
      'isCorrectionRequested': isCorrectionRequested,
    };
  }
}

class AttendanceCorrectionRequest {
  final String id;
  final String date;
  final String? existingClockIn;
  final String? existingClockOut;
  final String requestedClockIn;
  final String requestedClockOut;
  final String reason;
  final CorrectionRequestStatus status;
  final String createdAt;

  AttendanceCorrectionRequest({
    required this.id,
    required this.date,
    this.existingClockIn,
    this.existingClockOut,
    required this.requestedClockIn,
    required this.requestedClockOut,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  factory AttendanceCorrectionRequest.fromMap(
      Map<String, dynamic> map,
      ) {
    return AttendanceCorrectionRequest(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      existingClockIn: map['existingClockIn'],
      existingClockOut: map['existingClockOut'],
      requestedClockIn: map['requestedClockIn'] ?? '',
      requestedClockOut: map['requestedClockOut'] ?? '',
      reason: map['reason'] ?? '',
      status: _correctionStatusFromString(map['status']),
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'existingClockIn': existingClockIn,
      'existingClockOut': existingClockOut,
      'requestedClockIn': requestedClockIn,
      'requestedClockOut': requestedClockOut,
      'reason': reason,
      'status': _correctionStatusToString(status),
      'createdAt': createdAt,
    };
  }
}

enum CorrectionRequestStatus {
  pending,
  approved,
  rejected,
}

AttendanceRecordStatus _recordStatusFromString(String? value) {
  switch (value) {
    case 'Late':
      return AttendanceRecordStatus.late;
    case 'Half Day':
      return AttendanceRecordStatus.halfDay;
    case 'Absent':
      return AttendanceRecordStatus.absent;
    case 'On Leave':
      return AttendanceRecordStatus.onLeave;
    default:
      return AttendanceRecordStatus.present;
  }
}

String _recordStatusToString(AttendanceRecordStatus value) {
  switch (value) {
    case AttendanceRecordStatus.present:
      return 'Present';
    case AttendanceRecordStatus.late:
      return 'Late';
    case AttendanceRecordStatus.halfDay:
      return 'Half Day';
    case AttendanceRecordStatus.absent:
      return 'Absent';
    case AttendanceRecordStatus.onLeave:
      return 'On Leave';
  }
}

CorrectionRequestStatus _correctionStatusFromString(String? value) {
  switch (value) {
    case 'Approved':
      return CorrectionRequestStatus.approved;
    case 'Rejected':
      return CorrectionRequestStatus.rejected;
    default:
      return CorrectionRequestStatus.pending;
  }
}

String _correctionStatusToString(CorrectionRequestStatus value) {
  switch (value) {
    case CorrectionRequestStatus.pending:
      return 'Pending';
    case CorrectionRequestStatus.approved:
      return 'Approved';
    case CorrectionRequestStatus.rejected:
      return 'Rejected';
  }
}