// import 'package:cloud_firestore/cloud_firestore.dart';
//
// enum DailyReportStatus {
//   submitted,
//   reviewed,
//   rejected,
// }
//
// class DailyReport {
//   final String id;
//   final String employeeId;
//   final String? employeeName;
//   final String? managerId;
//
//   final String reportDate;
//   final String fileName;
//   final String fileUrl;
//   final String fileType;
//   final int? fileSize;
//
//   final String? description;
//   final String uploadedAt;
//   final DailyReportStatus status;
//
//   DailyReport({
//     required this.id,
//     required this.employeeId,
//     this.employeeName,
//     this.managerId,
//     required this.reportDate,
//     required this.fileName,
//     required this.fileUrl,
//     required this.fileType,
//     this.fileSize,
//     this.description,
//     required this.uploadedAt,
//     required this.status,
//   });
//
//   factory DailyReport.fromMap(Map<String, dynamic> map) {
//     final uploadedAtValue = map['uploadedAt'];
//
//     String uploadedAt = '';
//
//     if (uploadedAtValue is Timestamp) {
//       uploadedAt = uploadedAtValue.toDate().toIso8601String();
//     } else if (uploadedAtValue != null) {
//       uploadedAt = uploadedAtValue.toString();
//     }
//
//     return DailyReport(
//       id: map['id'] ?? '',
//       employeeId: map['employeeId'] ?? '',
//       employeeName: map['employeeName'],
//       managerId: map['managerId'],
//       reportDate: map['reportDate'] ?? '',
//       fileName: map['fileName'] ?? '',
//       fileUrl: map['fileUrl'] ?? '',
//       fileType: map['fileType'] ?? '',
//       fileSize: map['fileSize'],
//       description: map['description'],
//       uploadedAt: uploadedAt,
//       status: _statusFromString(map['status']),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'employeeId': employeeId,
//       'employeeName': employeeName,
//       'managerId': managerId,
//       'reportDate': reportDate,
//       'fileName': fileName,
//       'fileUrl': fileUrl,
//       'fileType': fileType,
//       'fileSize': fileSize,
//       'description': description,
//       'uploadedAt': uploadedAt,
//       'status': _statusToString(status),
//     };
//   }
// }
//
// DailyReportStatus _statusFromString(String? value) {
//   switch (value) {
//     case 'Reviewed':
//       return DailyReportStatus.reviewed;
//
//     case 'Rejected':
//       return DailyReportStatus.rejected;
//
//     default:
//       return DailyReportStatus.submitted;
//   }
// }
//
// String _statusToString(DailyReportStatus value) {
//   switch (value) {
//     case DailyReportStatus.submitted:
//       return 'Submitted';
//
//     case DailyReportStatus.reviewed:
//       return 'Reviewed';
//
//     case DailyReportStatus.rejected:
//       return 'Rejected';
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

enum DailyReportStatus {
  submitted,
  reviewed,
  rejected,
}

class DailyReport {
  final String id;
  final String employeeId;
  final String? employeeName;
  final String? managerId;

  final String reportDate;
  final String fileName;
  final String fileType;
  final int? fileSize;

  // Actual file data stored in Firestore
  final Blob? fileData;

  final String? description;
  final String uploadedAt;
  final DailyReportStatus status;

  DailyReport({
    required this.id,
    required this.employeeId,
    this.employeeName,
    this.managerId,
    required this.reportDate,
    required this.fileName,
    required this.fileType,
    this.fileSize,
    this.fileData,
    this.description,
    required this.uploadedAt,
    required this.status,
  });

  // ============================================================
  // FROM FIRESTORE DOCUMENT
  // ============================================================

  factory DailyReport.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return DailyReport.fromMap({
      ...data,
      'id': doc.id,
    });
  }

  // ============================================================
  // FROM MAP
  // ============================================================

  factory DailyReport.fromMap(
      Map<String, dynamic> map,
      ) {
    final uploadedAtValue = map['uploadedAt'];

    String uploadedAt = '';

    if (uploadedAtValue is Timestamp) {
      uploadedAt =
          uploadedAtValue.toDate().toIso8601String();
    } else if (uploadedAtValue != null) {
      uploadedAt = uploadedAtValue.toString();
    }

    return DailyReport(
      id: map['id'] ?? '',

      employeeId:
      map['employeeId'] ?? '',

      employeeName:
      map['employeeName'],

      managerId:
      map['managerId'],

      reportDate:
      map['reportDate'] ?? '',

      fileName:
      map['fileName'] ?? '',

      fileType:
      map['fileType'] ?? '',

      fileSize:
      map['fileSize'] is num
          ? (map['fileSize'] as num).toInt()
          : null,

      // Actual file bytes
      fileData:
      map['fileData'] as Blob?,

      description:
      map['description'],

      uploadedAt:
      uploadedAt,

      status:
      _statusFromString(
        map['status'],
      ),
    );
  }

  // ============================================================
  // TO MAP / FIRESTORE
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'managerId': managerId,

      'reportDate': reportDate,

      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,

      // Actual file bytes
      'fileData': fileData,

      'description': description,

      'uploadedAt': uploadedAt,

      'status': _statusToString(status),
    };
  }
}

// ============================================================
// STATUS FROM STRING
// ============================================================

DailyReportStatus _statusFromString(
    String? value,
    ) {
  switch (value) {
    case 'Reviewed':
      return DailyReportStatus.reviewed;

    case 'Rejected':
      return DailyReportStatus.rejected;

    case 'Submitted':
    default:
      return DailyReportStatus.submitted;
  }
}

// ============================================================
// STATUS TO STRING
// ============================================================

String _statusToString(
    DailyReportStatus value,
    ) {
  switch (value) {
    case DailyReportStatus.submitted:
      return 'Submitted';

    case DailyReportStatus.reviewed:
      return 'Reviewed';

    case DailyReportStatus.rejected:
      return 'Rejected';
  }
}