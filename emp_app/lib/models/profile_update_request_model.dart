import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileUpdateRequestModel {
  final String id;
  final String employeeId;
  final String employeeName;
  final Map<String, dynamic> requestedChanges;
  final String status;
  final DateTime requestedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? rejectionReason;

  ProfileUpdateRequestModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.requestedChanges,
    required this.status,
    required this.requestedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
  });

  factory ProfileUpdateRequestModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return ProfileUpdateRequestModel(
      id: doc.id,
      employeeId: data['employeeId'] ?? '',
      employeeName: data['employeeName'] ?? '',
      requestedChanges:
      Map<String, dynamic>.from(data['requestedChanges'] ?? {}),
      status: data['status'] ?? 'pending',
      requestedAt:
      (data['requestedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedAt:
      (data['reviewedAt'] as Timestamp?)?.toDate(),
      reviewedBy: data['reviewedBy'],
      rejectionReason: data['rejectionReason'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'requestedChanges': requestedChanges,
      'status': status,
      'requestedAt': Timestamp.fromDate(requestedAt),
      'reviewedAt':
      reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      'reviewedBy': reviewedBy,
      'rejectionReason': rejectionReason,
    };
  }
}