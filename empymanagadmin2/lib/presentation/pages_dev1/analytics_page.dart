import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 850;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1370,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 7,
                    ),
                    child: Column(
                      children: [
                        _buildHeader(isMobile),
                        const SizedBox(height: 27),
                        _buildReportsGrid(
                          context,
                          isMobile,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 27,
        vertical: isMobile ? 22 : 25,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF171C3D),
            Color(0xFF11172E),
            Color(0xFF10172D),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(17),
          bottomRight: Radius.circular(17),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge(),
          const SizedBox(height: 13),
          const Text(
            'Analytics & Reports',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Export official CSV / Excel records for workforce headcount, attendance registers, leave balances, and payroll disbursements.',
            style: TextStyle(
              color: Color(0xFFB5D1E8),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF302B82).withOpacity(.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4147C8),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Executive Analytics',
            style: TextStyle(
              color: Color(0xFF8C9BFF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 9),
          Text(
            '·',
            style: TextStyle(
              color: Color(0xFF7381B3),
              fontSize: 14,
            ),
          ),
          SizedBox(width: 7),
          Text(
            'Comprehensive Reports',
            style: TextStyle(
              color: Color(0xFFB1BED6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REPORT GRID
  // ============================================================

  Widget _buildReportsGrid(
      BuildContext context,
      bool isMobile,
      ) {
    final reports = [
      ReportData(
        icon: Icons.people_outline_rounded,
        iconBackground: const Color(0xFFEFF1FF),
        iconColor: const Color(0xFF5140F6),
        title: 'Master Workforce Directory Report',
        subtitle:
        'Complete employee master data including salary & roles',
        description:
        'Contains employee codes, full names, email addresses, phone numbers, department codes, designations, employment status, joining dates, and base salaries.',
        buttonText: 'Export Master Directory (CSV)',
        buttonColor: const Color(0xFF5039F5),
      ),
      ReportData(
        icon: Icons.access_time_rounded,
        iconBackground: const Color(0xFFEAFBF4),
        iconColor: const Color(0xFF00A875),
        title: 'Monthly Attendance Register',
        subtitle:
        'Detailed time clocking records and hour totals',
        description:
        'Contains daily check-in times, check-out times, total working hours, late arrival flags, and manual shift notes for compliance audit trails.',
        buttonText: 'Export Attendance Register (CSV)',
        buttonColor: const Color(0xFF00A473),
      ),
      ReportData(
        icon: Icons.calendar_month_outlined,
        iconBackground: const Color(0xFFFFF8E8),
        iconColor: const Color(0xFFEC8100),
        title: 'Leave Balance & Absence Summary',
        subtitle:
        'Annual leave quota tracking and history',
        description:
        'Contains remaining paid leave, casual leave, and sick leave balances per employee, along with approved and rejected leave request logs.',
        buttonText: 'Export Leave Summary (CSV)',
        buttonColor: const Color(0xFFED7B00),
      ),
      ReportData(
        icon: Icons.attach_money_rounded,
        iconBackground: const Color(0xFFEAF2FF),
        iconColor: const Color(0xFF2161F5),
        title: 'Payroll Disbursement Summary',
        subtitle:
        'Monthly gross salary, tax withholding, and net pay',
        description:
        'Contains itemized salary calculations, house rent allowances, transport allowances, tax deductions, insurance contributions, and net payouts.',
        buttonText: 'Export Payroll Summary (CSV)',
        buttonColor: const Color(0xFF2160F5),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < reports.length; i++) ...[
            _buildReportCard(
              context,
              reports[i],
            ),
            if (i != reports.length - 1)
              const SizedBox(height: 18),
          ],
        ],
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 27,
        mainAxisSpacing: 27,
        childAspectRatio: 1.93,
      ),
      itemBuilder: (context, index) {
        return _buildReportCard(
          context,
          reports[index],
        );
      },
    );
  }

  // ============================================================
  // REPORT CARD
  // ============================================================

  Widget _buildReportCard(
      BuildContext context,
      ReportData report,
      ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        27,
        27,
        27,
        27,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFDCE3EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------
          // CARD TITLE
          // ----------------------------------------------------

          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: report.iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  report.icon,
                  color: report.iconColor,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(
                        color: Color(0xFF081A35),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      report.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF627D9D),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------
          // DESCRIPTION
          // ----------------------------------------------------

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FA),
                borderRadius: BorderRadius.circular(13),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                report.description,
                style: const TextStyle(
                  color: Color(0xFF2D4967),
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ----------------------------------------------------
          // EXPORT BUTTON
          // ----------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 41,
            child: ElevatedButton.icon(
              onPressed: () {
                _exportReport(
                  context,
                  report,
                );
              },
              icon: const Icon(
                Icons.download_outlined,
                size: 19,
              ),
              label: Text(
                report.buttonText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: report.buttonColor,
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor:
                report.buttonColor.withOpacity(.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EXPORT ACTION
  // ============================================================

  void _exportReport(
      BuildContext context,
      ReportData report,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${report.title} export started',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ================================================================
// REPORT MODEL
// ================================================================

class ReportData {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String description;
  final String buttonText;
  final Color buttonColor;

  const ReportData({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
  });
}