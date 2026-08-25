import 'package:cloud_firestore/cloud_firestore.dart';

class HourlyReportSlot {
  final String id;
  final String time;
  final String type;

  const HourlyReportSlot({
    required this.id,
    required this.time,
    required this.type,
  });

  bool get isWork => type == 'work';
  bool get isBreak => type == 'break';
  bool get isLunch => type == 'lunch';
}

/// Fixed company working schedule.
///
/// These timings are defined by the application and are NOT stored
/// repeatedly in Firestore.
const List<HourlyReportSlot> hourlyReportSlots = [
  HourlyReportSlot(
    id: '10_11',
    time: '10:00 AM - 11:00 AM',
    type: 'work',
  ),
  HourlyReportSlot(
    id: '11_1115',
    time: '11:00 AM - 11:15 AM',
    type: 'break',
  ),
  HourlyReportSlot(
    id: '1115_1',
    time: '11:15 AM - 01:00 PM',
    type: 'work',
  ),
  HourlyReportSlot(
    id: '1_2',
    time: '01:00 PM - 02:00 PM',
    type: 'lunch',
  ),
  HourlyReportSlot(
    id: '2_3',
    time: '02:00 PM - 03:00 PM',
    type: 'work',
  ),
  HourlyReportSlot(
    id: '3_4',
    time: '03:00 PM - 04:00 PM',
    type: 'work',
  ),
  HourlyReportSlot(
    id: '4_415',
    time: '04:00 PM - 04:15 PM',
    type: 'break',
  ),
  HourlyReportSlot(
    id: '415_5',
    time: '04:15 PM - 05:00 PM',
    type: 'work',
  ),
  HourlyReportSlot(
    id: '5_6',
    time: '05:00 PM - 06:00 PM',
    type: 'work',
  ),
];

class HourlyReportEntry {
  final String slotId;
  final String description;

  const HourlyReportEntry({
    required this.slotId,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'slotId': slotId,
      'description': description,
    };
  }

  factory HourlyReportEntry.fromMap(
      Map<String, dynamic> map,
      ) {
    return HourlyReportEntry(
      slotId: map['slotId']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
    );
  }
}

class HourlyReport {
  final String id;
  final String employeeId;
  final String reportDate;
  final List<HourlyReportEntry> entries;
  final String status;
  final DateTime? createdAt;
  final DateTime? submittedAt;

  const HourlyReport({
    required this.id,
    required this.employeeId,
    required this.reportDate,
    required this.entries,
    required this.status,
    this.createdAt,
    this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'reportDate': reportDate,
      'entries': entries.map((e) => e.toMap()).toList(),
      'status': status,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'submittedAt': submittedAt != null
          ? Timestamp.fromDate(submittedAt!)
          : null,
    };
  }

  factory HourlyReport.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    final rawEntries = map['entries'];

    final entries = <HourlyReportEntry>[];

    if (rawEntries is List) {
      for (final item in rawEntries) {
        if (item is Map) {
          entries.add(
            HourlyReportEntry.fromMap(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    DateTime? parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }

      if (value is DateTime) {
        return value;
      }

      return null;
    }

    return HourlyReport(
      id: id,
      employeeId: map['employeeId']?.toString() ?? '',
      reportDate: map['reportDate']?.toString() ?? '',
      entries: entries,
      status: map['status']?.toString() ?? 'draft',
      createdAt: parseDate(map['createdAt']),
      submittedAt: parseDate(map['submittedAt']),
    );
  }
}