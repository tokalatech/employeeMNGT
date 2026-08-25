import 'package:flutter/material.dart';

import '../models/hourly_report_model.dart';
import '../services/hourly_report_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class HourlyReportsScreen extends StatefulWidget {
  const HourlyReportsScreen({super.key});

  @override
  State<HourlyReportsScreen> createState() =>
      _HourlyReportsScreenState();
}

class _HourlyReportsScreenState
    extends State<HourlyReportsScreen> {
  final HourlyReportService _reportService =
  HourlyReportService();

  final Map<String, TextEditingController> _controllers = {};

  HourlyReport? _report;

  bool _loading = true;
  bool _saving = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();

    for (final slot in hourlyReportSlots) {
      if (slot.isWork) {
        _controllers[slot.id] = TextEditingController();
      }
    }

    _loadReport();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // LOAD TODAY'S REPORT
  // ============================================================

  Future<void> _loadReport() async {
    try {
      final report =
      await _reportService.getOrCreateTodayReport();

      if (!mounted) return;

      _report = report;
      _submitted = report.status == 'submitted';

      for (final entry in report.entries) {
        final controller = _controllers[entry.slotId];

        if (controller != null) {
          controller.text = entry.description;
        }
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showError(e);
    }
  }

  // ============================================================
  // BUILD ENTRIES
  // ============================================================

  List<HourlyReportEntry> _buildEntries() {
    return hourlyReportSlots
        .where((slot) => slot.isWork)
        .map(
          (slot) => HourlyReportEntry(
        slotId: slot.id,
        description:
        _controllers[slot.id]?.text.trim() ?? '',
      ),
    )
        .toList();
  }

  // ============================================================
  // SAVE DRAFT
  // ============================================================

  Future<void> _saveDraft() async {
    if (_saving || _submitted || _report == null) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final entries = _buildEntries();

      await _reportService.updateDraft(
        reportId: _report!.id,
        entries: entries,
      );

      if (!mounted) return;

      _showMessage(
        'Report saved successfully.',
      );
    } catch (e) {
      if (!mounted) return;

      _showError(e);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ============================================================
  // SUBMIT REPORT
  // ============================================================

  Future<void> _submitReport() async {
    if (_saving || _submitted || _report == null) {
      return;
    }

    final entries = _buildEntries();

    // Validate before submitting.
    for (final slot in hourlyReportSlots) {
      if (!slot.isWork) continue;

      final description = _controllers[slot.id]
          ?.text
          .trim() ??
          '';

      if (description.isEmpty) {
        _showMessage(
          'Please enter your work for ${slot.time}.',
        );

        return;
      }
    }

    final confirmed = await _confirmSubmission();

    if (!confirmed) return;

    setState(() {
      _saving = true;
    });

    try {
      await _reportService.submitReport(
        reportId: _report!.id,
        entries: entries,
      );

      if (!mounted) return;

      setState(() {
        _submitted = true;
        _report = HourlyReport(
          id: _report!.id,
          employeeId: _report!.employeeId,
          reportDate: _report!.reportDate,
          entries: entries,
          status: 'submitted',
          createdAt: _report!.createdAt,
          submittedAt: DateTime.now(),
        );
      });

      _showMessage(
        'Hourly report submitted successfully.',
      );
    } catch (e) {
      if (!mounted) return;

      _showError(e);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ============================================================
  // CONFIRM SUBMISSION
  // ============================================================

  Future<bool> _confirmSubmission() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Submit Hourly Report?',
          ),
          content: const Text(
            'Once submitted, you will not be able to edit '
                'today\'s report.\n\n'
                'Make sure all your work descriptions are complete.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} '
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
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'HOURLY WORK REPORT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 8),

        _headerCard(),

        const SizedBox(height: 14),

        ...hourlyReportSlots.map(
              (slot) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _slotCard(slot),
          ),
        ),

        const SizedBox(height: 8),

        if (!_submitted) _actionCard(),

        if (_submitted) _submittedCard(),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _headerCard() {
    return PulseCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
            AppColors.primary.withValues(alpha: .12),
            child: Icon(
              Icons.access_time,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Work Report',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatDate(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          _statusBadge(),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _submitted
            ? Colors.green.withValues(alpha: .1)
            : AppColors.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _submitted ? 'SUBMITTED' : 'DRAFT',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: _submitted
              ? Colors.green
              : AppColors.primary,
        ),
      ),
    );
  }

  // ============================================================
  // SLOT CARD
  // ============================================================

  Widget _slotCard(HourlyReportSlot slot) {
    if (slot.isBreak) {
      return _breakCard(
        icon: Icons.free_breakfast_outlined,
        label: 'Break',
        time: slot.time,
      );
    }

    if (slot.isLunch) {
      return _breakCard(
        icon: Icons.restaurant_outlined,
        label: 'Lunch Break',
        time: slot.time,
      );
    }

    return _workCard(slot);
  }

  // ============================================================
  // WORK CARD
  // ============================================================

  Widget _workCard(HourlyReportSlot slot) {
    final controller = _controllers[slot.id]!;

    return PulseCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.work_outline,
                size: 18,
                color: AppColors.primary,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  slot.time,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const Text(
                'WORK',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          TextField(
            controller: controller,
            enabled: !_submitted && !_saving,
            maxLines: 3,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText:
              'Describe what you worked on during this period...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BREAK / LUNCH CARD
  // ============================================================

  Widget _breakCard({
    required IconData icon,
    required String label,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: const Color(0xFF64748B),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const Text(
            'NO REPORT',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION CARD
  // ============================================================

  Widget _actionCard() {
    return PulseCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          const Text(
            'END OF DAY SUBMISSION',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Complete all work descriptions before submitting '
                'your report.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 14),

          OutlinedButton(
            onPressed: _saving ? null : _saveDraft,
            child: _saving
                ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Text(
              'Save Progress',
            ),
          ),

          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed:
            _saving ? null : _submitReport,
            icon: const Icon(
              Icons.send_outlined,
            ),
            label: const Text(
              'Submit End-of-Day Report',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUBMITTED CARD
  // ============================================================

  Widget _submittedCard() {
    return PulseCard(
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Report Submitted',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'Your hourly work report has been submitted successfully.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}