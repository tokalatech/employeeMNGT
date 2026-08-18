// import 'dart:typed_data';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
//
// import '../models/daily_report_model.dart';
// import '../services/daily_report_service.dart';
// import '../theme/app_theme.dart';
// import '../widgets/pulse_card.dart';
//
// class DailyReportsScreen extends StatefulWidget {
//   const DailyReportsScreen({super.key});
//
//   @override
//   State<DailyReportsScreen> createState() => _DailyReportsScreenState();
// }
//
// class _DailyReportsScreenState extends State<DailyReportsScreen> {
//   final DailyReportService _reportService = DailyReportService();
//
//   final TextEditingController _descriptionController =
//   TextEditingController();
//
//   String? _selectedFileName;
//   String? _selectedFileType;
//   Uint8List? _selectedFileBytes;
//
//   DateTime _reportDate = DateTime.now();
//
//   bool _uploading = false;
//   String _uploadStatus = '';
//
//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   // ------------------------------------------------------------
//   // FILE SELECTION
//   // Compatible with file_picker 12.0.0
//   // ------------------------------------------------------------
//   Future<void> _selectFile() async {
//     if (_uploading) return;
//
//     try {
//       final files = await FilePicker.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: const [
//           'pdf',
//           'doc',
//           'docx',
//         ],
//       );
//
//       if (files.isEmpty) {
//         return;
//       }
//
//       final file = files.first;
//
//       // file_picker 12.0.0 does not expose file.bytes.
//       // Read the selected file using readAsBytes().
//       final bytes = await file.readAsBytes();
//
//       if (bytes.isEmpty) {
//         throw StateError(
//           'Unable to read the selected file.',
//         );
//       }
//
//       if (!mounted) return;
//
//       setState(() {
//         _selectedFileName = file.name;
//         _selectedFileBytes = bytes;
//         _selectedFileType = _getFileType(file.name);
//       });
//     } catch (e) {
//       if (!mounted) return;
//
//       _showError(e);
//     }
//   }
//
//   String _getFileType(String fileName) {
//     final extension = fileName.split('.').last.toLowerCase();
//     return extension;
//   }
//
//   // ------------------------------------------------------------
//   // UPLOAD REPORT
//   // ------------------------------------------------------------
//   Future<void> _uploadReport() async {
//     if (_uploading) return;
//
//     if (_selectedFileBytes == null ||
//         _selectedFileName == null ||
//         _selectedFileType == null) {
//       _showMessage(
//         'Please select a report document.',
//       );
//       return;
//     }
//
//     setState(() {
//       _uploading = true;
//       _uploadStatus = 'Preparing report...';
//     });
//
//     try {
//       setState(() {
//         _uploadStatus =
//         'Uploading file to Firebase Storage...';
//       });
//
//       await _reportService.uploadDailyReport(
//         bytes: _selectedFileBytes!,
//         fileName: _selectedFileName!,
//         fileType: _selectedFileType!,
//         fileSize: _selectedFileBytes!.length,
//         reportDate: _reportDate,
//         description:
//         _descriptionController.text.trim().isEmpty
//             ? null
//             : _descriptionController.text.trim(),
//       );
//
//       if (!mounted) return;
//
//       setState(() {
//         _selectedFileName = null;
//         _selectedFileType = null;
//         _selectedFileBytes = null;
//         _descriptionController.clear();
//         _uploadStatus = '';
//       });
//
//       _showMessage(
//         'Daily report submitted successfully.',
//       );
//     } catch (e) {
//       if (!mounted) return;
//
//       setState(() {
//         _uploadStatus = '';
//       });
//
//       _showError(e);
//     } finally {
//       if (mounted) {
//         setState(() {
//           _uploading = false;
//         });
//       }
//     }
//   }
//
//   // ------------------------------------------------------------
//   // DATE SELECTION
//   // ------------------------------------------------------------
//   Future<void> _selectDate() async {
//     if (_uploading) return;
//
//     final selected = await showDatePicker(
//       context: context,
//       initialDate: _reportDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );
//
//     if (selected == null || !mounted) return;
//
//     setState(() {
//       _reportDate = selected;
//     });
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}/'
//         '${date.month.toString().padLeft(2, '0')}/'
//         '${date.year}';
//   }
//
//   // ------------------------------------------------------------
//   // MESSAGES
//   // ------------------------------------------------------------
//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//         ),
//       );
//   }
//
//   void _showError(Object error) {
//     var message = error.toString();
//
//     message = message.replaceFirst(
//       'Bad state: ',
//       '',
//     );
//
//     message = message.replaceFirst(
//       'Exception: ',
//       '',
//     );
//
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           duration: const Duration(seconds: 6),
//         ),
//       );
//   }
//
//   // ------------------------------------------------------------
//   // BUILD
//   // ------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         const Text(
//           'DAILY REPORT',
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w800,
//             color: Color(0xFF64748B),
//           ),
//         ),
//         const SizedBox(height: 9),
//         _submissionCard(),
//         const SizedBox(height: 20),
//         const Text(
//           'MY SUBMITTED REPORTS',
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w800,
//             color: Color(0xFF64748B),
//           ),
//         ),
//         const SizedBox(height: 9),
//         _submittedReports(),
//       ],
//     );
//   }
//
//   // ------------------------------------------------------------
//   // SUBMISSION CARD
//   // ------------------------------------------------------------
//   Widget _submissionCard() {
//     return PulseCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Submit Daily Report',
//             style: TextStyle(
//               fontSize: 17,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//           const SizedBox(height: 5),
//           const Text(
//             'Upload your daily work report for review.',
//             style: TextStyle(
//               fontSize: 12,
//               color: Color(0xFF64748B),
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           const Text(
//             'REPORT DATE',
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFF64748B),
//             ),
//           ),
//           const SizedBox(height: 6),
//
//           InkWell(
//             onTap: _uploading ? null : _selectDate,
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(13),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: const Color(0xFFE2E8F0),
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.calendar_today_outlined,
//                     size: 17,
//                     color: AppColors.primary,
//                   ),
//                   const SizedBox(width: 9),
//                   Text(
//                     _formatDate(_reportDate),
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 18),
//
//           const Text(
//             'REPORT DOCUMENT',
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFF64748B),
//             ),
//           ),
//           const SizedBox(height: 6),
//
//           InkWell(
//             onTap: _uploading ? null : _selectFile,
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: const Color(0xFFE2E8F0),
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.cloud_upload_outlined,
//                     size: 34,
//                     color: AppColors.primary,
//                   ),
//                   const SizedBox(height: 9),
//                   Text(
//                     _selectedFileName ??
//                         'Tap to select report document',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   const Text(
//                     'PDF, DOC or DOCX',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Color(0xFF64748B),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           if (_selectedFileName != null) ...[
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const Icon(
//                   Icons.check_circle,
//                   size: 16,
//                   color: Colors.green,
//                 ),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: Text(
//                     _selectedFileName!,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//
//           const SizedBox(height: 18),
//
//           TextField(
//             controller: _descriptionController,
//             maxLines: 3,
//             enabled: !_uploading,
//             decoration: const InputDecoration(
//               labelText: 'Description (optional)',
//               hintText:
//               'Briefly describe today\'s work...',
//               border: OutlineInputBorder(),
//             ),
//           ),
//
//           const SizedBox(height: 18),
//
//           if (_uploading) ...[
//             Text(
//               _uploadStatus,
//               style: const TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF64748B),
//               ),
//             ),
//             const SizedBox(height: 8),
//             const LinearProgressIndicator(),
//             const SizedBox(height: 14),
//           ],
//
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed:
//               _uploading ? null : _uploadReport,
//               icon: _uploading
//                   ? const SizedBox(
//                 width: 17,
//                 height: 17,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                 ),
//               )
//                   : const Icon(Icons.upload_file),
//               label: Text(
//                 _uploading
//                     ? 'Uploading...'
//                     : 'Submit Daily Report',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ------------------------------------------------------------
//   // SUBMITTED REPORTS
//   // ------------------------------------------------------------
//   Widget _submittedReports() {
//     return StreamBuilder<List<DailyReport>>(
//       stream: _reportService.watchMyReports(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return PulseCard(
//             child: Text(
//               'Unable to load submitted reports: '
//                   '${snapshot.error}',
//               style: const TextStyle(
//                 fontSize: 12,
//               ),
//             ),
//           );
//         }
//
//         if (snapshot.connectionState ==
//             ConnectionState.waiting) {
//           return const PulseCard(
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           );
//         }
//
//         final reports = snapshot.data ?? [];
//
//         if (reports.isEmpty) {
//           return const PulseCard(
//             child: Text(
//               'No daily reports submitted yet.',
//               style: TextStyle(
//                 fontSize: 12,
//               ),
//             ),
//           );
//         }
//
//         return Column(
//           children: reports.map(_reportCard).toList(),
//         );
//       },
//     );
//   }
//
//   // ------------------------------------------------------------
//   // REPORT CARD
//   // ------------------------------------------------------------
//   Widget _reportCard(DailyReport report) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 9),
//       child: PulseCard(
//         child: ListTile(
//           contentPadding: EdgeInsets.zero,
//           leading: Icon(
//             Icons.description_outlined,
//             color: AppColors.primary,
//           ),
//           title: Text(
//             report.fileName,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           subtitle: Text(
//             '${report.reportDate} · '
//                 '${_statusText(report.status)}',
//             style: const TextStyle(
//               fontSize: 10,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _statusText(DailyReportStatus status) {
//     switch (status) {
//       case DailyReportStatus.submitted:
//         return 'Submitted';
//
//       case DailyReportStatus.reviewed:
//         return 'Reviewed';
//
//       case DailyReportStatus.rejected:
//         return 'Rejected';
//     }
//   }
// }

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/daily_report_model.dart';
import '../services/daily_report_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class DailyReportsScreen extends StatefulWidget {
  const DailyReportsScreen({super.key});

  @override
  State<DailyReportsScreen> createState() => _DailyReportsScreenState();
}

class _DailyReportsScreenState extends State<DailyReportsScreen> {
  final DailyReportService _reportService = DailyReportService();

  final TextEditingController _descriptionController =
  TextEditingController();

  String? _selectedFileName;
  String? _selectedFileType;
  Uint8List? _selectedFileBytes;

  DateTime _reportDate = DateTime.now();

  bool _uploading = false;
  String _uploadStatus = '';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // ============================================================
  // FILE SELECTION
  // ============================================================

  Future<void> _selectFile() async {
    if (_uploading) return;

    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const [
          'pdf',
          'doc',
          'docx',
        ],
      );

      if (files.isEmpty) {
        return;
      }

      final file = files.first;

      final bytes = await file.readAsBytes();

      if (bytes.isEmpty) {
        throw StateError(
          'Unable to read the selected file.',
        );
      }

      if (!mounted) return;

      setState(() {
        _selectedFileName = file.name;
        _selectedFileBytes = bytes;
        _selectedFileType = _getFileType(file.name);
      });
    } catch (e) {
      if (!mounted) return;

      _showError(e);
    }
  }

  String _getFileType(String fileName) {
    final parts = fileName.split('.');

    if (parts.length < 2) {
      return 'unknown';
    }

    return parts.last.toLowerCase();
  }

  // ============================================================
  // SAVE REPORT TO FIRESTORE
  // ============================================================

  Future<void> _uploadReport() async {
    if (_uploading) return;

    if (_selectedFileBytes == null ||
        _selectedFileName == null ||
        _selectedFileType == null) {
      _showMessage(
        'Please select a report document.',
      );
      return;
    }

    setState(() {
      _uploading = true;
      _uploadStatus = 'Preparing report...';
    });

    try {
      setState(() {
        _uploadStatus = 'Saving report to Firestore...';
      });

      await _reportService.uploadDailyReport(
        bytes: _selectedFileBytes!,
        fileName: _selectedFileName!,
        fileType: _selectedFileType!,
        fileSize: _selectedFileBytes!.length,
        reportDate: _reportDate,
        description:
        _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _selectedFileName = null;
        _selectedFileType = null;
        _selectedFileBytes = null;

        _descriptionController.clear();

        _uploadStatus = '';
      });

      _showMessage(
        'Daily report submitted successfully.',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _uploadStatus = '';
      });

      _showError(e);
    } finally {
      if (mounted) {
        setState(() {
          _uploading = false;
        });
      }
    }
  }

  // ============================================================
  // DATE SELECTION
  // ============================================================

  Future<void> _selectDate() async {
    if (_uploading) return;

    final selected = await showDatePicker(
      context: context,
      initialDate: _reportDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selected == null || !mounted) return;

    setState(() {
      _reportDate = selected;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // MESSAGES
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  void _showError(Object error) {
    var message = error.toString();

    message = message.replaceFirst(
      'Bad state: ',
      '',
    );

    message = message.replaceFirst(
      'Exception: ',
      '',
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 6),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'DAILY REPORT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 9),

        _submissionCard(),

        const SizedBox(height: 20),

        const Text(
          'MY SUBMITTED REPORTS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 9),

        _submittedReports(),
      ],
    );
  }

  // ============================================================
  // SUBMISSION CARD
  // ============================================================

  Widget _submissionCard() {
    return PulseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Submit Daily Report',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Upload your daily work report for review.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 20),

          // ----------------------------------------------------
          // REPORT DATE
          // ----------------------------------------------------

          const Text(
            'REPORT DATE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 6),

          InkWell(
            onTap: _uploading ? null : _selectDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 17,
                    color: AppColors.primary,
                  ),

                  const SizedBox(width: 9),

                  Text(
                    _formatDate(_reportDate),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------
          // REPORT DOCUMENT
          // ----------------------------------------------------

          const Text(
            'REPORT DOCUMENT',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 6),

          InkWell(
            onTap: _uploading ? null : _selectFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 34,
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: 9),

                  Text(
                    _selectedFileName ??
                        'Tap to select report document',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'PDF, DOC or DOCX',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ----------------------------------------------------
          // SELECTED FILE
          // ----------------------------------------------------

          if (_selectedFileName != null) ...[
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.green,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    _selectedFileName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 18),

          // ----------------------------------------------------
          // DESCRIPTION
          // ----------------------------------------------------

          TextField(
            controller: _descriptionController,
            maxLines: 3,
            enabled: !_uploading,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              hintText: 'Briefly describe today\'s work...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------
          // SAVE PROGRESS
          // ----------------------------------------------------

          if (_uploading) ...[
            Text(
              _uploadStatus,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),

            const SizedBox(height: 8),

            const LinearProgressIndicator(),

            const SizedBox(height: 14),
          ],

          // ----------------------------------------------------
          // SUBMIT BUTTON
          // ----------------------------------------------------

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
              _uploading ? null : _uploadReport,

              icon: _uploading
                  ? const SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Icon(
                Icons.upload_file,
              ),

              label: Text(
                _uploading
                    ? 'Saving...'
                    : 'Submit Daily Report',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUBMITTED REPORTS
  // ============================================================

  Widget _submittedReports() {
    return StreamBuilder<List<DailyReport>>(
      stream: _reportService.watchMyReports(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return PulseCard(
            child: Text(
              'Unable to load submitted reports: '
                  '${snapshot.error}',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const PulseCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final reports = snapshot.data ?? [];

        if (reports.isEmpty) {
          return const PulseCard(
            child: Text(
              'No daily reports submitted yet.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          );
        }

        return Column(
          children: reports
              .map(_reportCard)
              .toList(),
        );
      },
    );
  }

  // ============================================================
  // REPORT CARD
  // ============================================================

  Widget _reportCard(DailyReport report) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: PulseCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,

          leading: Icon(
            Icons.description_outlined,
            color: AppColors.primary,
          ),

          title: Text(
            report.fileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),

          subtitle: Text(
            '${report.reportDate} · '
                '${_statusText(report.status)}',
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  String _statusText(
      DailyReportStatus status,
      ) {
    switch (status) {
      case DailyReportStatus.submitted:
        return 'Submitted';

      case DailyReportStatus.reviewed:
        return 'Reviewed';

      case DailyReportStatus.rejected:
        return 'Rejected';
    }
  }
}