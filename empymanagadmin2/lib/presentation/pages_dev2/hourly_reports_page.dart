import 'package:flutter/material.dart';

class HourlyReportsPage extends StatefulWidget {
  const HourlyReportsPage({super.key});

  @override
  State<HourlyReportsPage> createState() => _HourlyReportsPageState();
}

class _HourlyReportsPageState extends State<HourlyReportsPage> {
  bool isSubmitted = false;
  bool isSaving = false;

  late final List<TextEditingController> _controllers;

  final List<HourlyReportItem> reportItems = const [
    HourlyReportItem(
      time: '10:00 AM - 11:00 AM',
      type: ReportType.work,
      hint: 'Describe the work completed during this hour...',
    ),
    HourlyReportItem(
      time: '11:00 AM - 12:00 PM',
      type: ReportType.work,
      hint: 'Describe the work completed during this hour...',
    ),
    HourlyReportItem(
      time: '12:00 PM - 01:00 PM',
      type: ReportType.work,
      hint: 'Describe the work completed during this hour...',
    ),
    HourlyReportItem(
      time: '01:00 PM - 02:00 PM',
      type: ReportType.lunch,
      hint: '',
    ),
    HourlyReportItem(
      time: '02:00 PM - 03:00 PM',
      type: ReportType.work,
      hint: 'Describe the work completed during this hour...',
    ),
    HourlyReportItem(
      time: '03:00 PM - 04:00 PM',
      type: ReportType.work,
      hint: 'Describe the work completed during this hour...',
    ),
    HourlyReportItem(
      time: '04:00 PM - 06:00 PM',
      type: ReportType.work,
      hint: 'Describe the work completed during these hours...',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      reportItems.length,
          (index) => TextEditingController(
        text: _defaultDescription(index),
      ),
    );
  }

  String _defaultDescription(int index) {
    switch (index) {
      case 0:
        return 'Reviewed and responded to emails and IT support requests.';

      case 1:
        return 'Worked on assigned tasks and followed up on pending issues.';

      case 2:
        return 'Updated project activities and coordinated with team members.';

      case 4:
        return 'Worked on assigned project tasks and completed priority items.';

      case 5:
        return 'Reviewed progress, resolved issues, and updated task status.';

      case 6:
        return 'Completed pending work and prepared updates for the next working day.';

      default:
        return '';
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // SAVE REPORT
  // ============================================================

  Future<void> _saveDraft() async {
    setState(() {
      isSaving = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hourly report saved as draft.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // SUBMIT REPORT
  // ============================================================

  Future<void> _submitReport() async {
    FocusScope.of(context).unfocus();

    final bool hasEmptyReport = _controllers.asMap().entries.any(
          (entry) {
        final int index = entry.key;

        if (reportItems[index].type == ReportType.lunch) {
          return false;
        }

        return entry.value.text.trim().isEmpty;
      },
    );

    if (hasEmptyReport) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a description for all work hours.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      isSaving = false;
      isSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hourly report submitted successfully.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isMobile = constraints.maxWidth < 700;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 28,
                      vertical: isMobile ? 18 : 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1450,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(),
                            const SizedBox(height: 12),

                            _buildTodayHeader(isMobile),

                            const SizedBox(height: 18),

                            _buildReportList(isMobile),

                            const SizedBox(height: 20),

                            _buildBottomButtons(isMobile),

                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      height: 68,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE4E8EF),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 27,
              color: Color(0xFF1B1F27),
            ),
          ),

          const SizedBox(width: 10),

          const Text(
            'Hourly Reports',
            style: TextStyle(
              color: Color(0xFF17191F),
              fontSize: 29,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle() {
    return const Text(
      'HOURLY WORK REPORT',
      style: TextStyle(
        color: Color(0xFF657894),
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );
  }

  // ============================================================
  // TODAY HEADER
  // ============================================================

  Widget _buildTodayHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 24,
        vertical: isMobile ? 18 : 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEF4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildClockIcon(),
              const SizedBox(width: 15),
              Expanded(
                child: _buildReportTitle(),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _buildStatusBadge(),
        ],
      )
          : Row(
        children: [
          _buildClockIcon(),

          const SizedBox(width: 16),

          Expanded(
            child: _buildReportTitle(),
          ),

          const SizedBox(width: 15),

          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildClockIcon() {
    return Container(
      width: 53,
      height: 53,
      decoration: BoxDecoration(
        color: const Color(0xFFE0DBFF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Icon(
        Icons.access_time,
        color: Color(0xFF5542FF),
        size: 29,
      ),
    );
  }

  Widget _buildReportTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Work Report",
          style: TextStyle(
            color: Color(0xFF171923),
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 5),

        Text(
          '31 August 2026',
          style: TextStyle(
            color: Color(0xFF7485A1),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: isSubmitted
            ? const Color(0xFFD9F1E0)
            : const Color(0xFFE9EDF3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isSubmitted ? 'SUBMITTED' : 'DRAFT',
        style: TextStyle(
          color: isSubmitted
              ? const Color(0xFF32A24C)
              : const Color(0xFF6E7F98),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ============================================================
  // REPORT LIST
  // ============================================================

  Widget _buildReportList(bool isMobile) {
    return Column(
      children: List.generate(
        reportItems.length,
            (index) {
          final item = reportItems[index];

          if (item.type == ReportType.lunch) {
            return _buildLunchBreak(item);
          }

          return _buildWorkReport(
            item,
            index,
            isMobile,
          );
        },
      ),
    );
  }

  // ============================================================
  // WORK REPORT BOX
  // ============================================================

  Widget _buildWorkReport(
      HourlyReportItem item,
      int index,
      bool isMobile,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(
        isMobile ? 14 : 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEF4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // TIME HEADER
          // ======================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.work_outline,
                color: Color(0xFF5142FF),
                size: 22,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  item.time,
                  style: TextStyle(
                    color: const Color(0xFF171923),
                    fontSize: isMobile ? 15 : 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Text(
                'WORK',
                style: TextStyle(
                  color: Color(0xFF657894),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ======================================================
          // DESCRIPTION FIELD
          // ======================================================

          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 105,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFFB5BAC2),
              ),
            ),
            child: TextField(
              controller: _controllers[index],
              enabled: !isSubmitted,
              minLines: 3,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              style: const TextStyle(
                color: Color(0xFF242934),
                fontSize: 16,
                height: 1.45,
              ),
              decoration: InputDecoration(
                hintText: item.hint,
                hintStyle: const TextStyle(
                  color: Color(0xFFA8ABB1),
                  fontSize: 16,
                ),
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LUNCH BREAK
  // ============================================================

  Widget _buildLunchBreak(HourlyReportItem item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 19,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E5EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.restaurant_outlined,
            color: Color(0xFF75849C),
            size: 23,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lunch Break',
                  style: TextStyle(
                    color: Color(0xFF252933),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.time,
                  style: const TextStyle(
                    color: Color(0xFF71829D),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const Text(
            'NO REPORT',
            style: TextStyle(
              color: Color(0xFF91A0B7),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM BUTTONS
  // ============================================================

  Widget _buildBottomButtons(bool isMobile) {
    if (isSubmitted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F7EE),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFC5E8CF),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Color(0xFF35A44D),
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your hourly work report has been submitted successfully.',
                style: TextStyle(
                  color: Color(0xFF277C3B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return isMobile
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSaveButton(),
        const SizedBox(height: 10),
        _buildSubmitButton(),
      ],
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildSaveButton(),
        const SizedBox(width: 12),
        _buildSubmitButton(),
      ],
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    return OutlinedButton.icon(
      onPressed: isSaving ? null : _saveDraft,
      icon: const Icon(
        Icons.save_outlined,
        size: 19,
      ),
      label: const Text(
        'Save Draft',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF4D5F79),
        side: const BorderSide(
          color: Color(0xFFD0D7E1),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
  }

  // ============================================================
  // SUBMIT BUTTON
  // ============================================================

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: isSaving ? null : _submitReport,
      icon: isSaving
          ? const SizedBox(
        width: 17,
        height: 17,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Icon(
        Icons.send_outlined,
        size: 18,
      ),
      label: Text(
        isSaving ? 'Submitting...' : 'Submit Report',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5142FF),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFF9E98F7),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
  }
}

// ================================================================
// REPORT MODEL
// ================================================================

enum ReportType {
  work,
  lunch,
}

class HourlyReportItem {
  final String time;
  final ReportType type;
  final String hint;

  const HourlyReportItem({
    required this.time,
    required this.type,
    required this.hint,
  });
}