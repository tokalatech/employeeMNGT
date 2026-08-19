import 'dart:math' as math;
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // ============================================================
  // DATA
  // ============================================================

  final List<Map<String, dynamic>> leaveRequests = [
    {
      'name': 'Alex Rivera',
      'type': 'CASUAL',
      'days': '2 day(s)',
      'period': '2026-08-18 to 2026-08-19',
      'reason': 'Personal errands and home maintenance.',
      'initial': 'A',
      'color': const Color(0xFF566FEA),
    },
    {
      'name': "Liam O'Connor",
      'type': 'PAID',
      'days': '4 day(s)',
      'period': '2026-08-25 to 2026-08-28',
      'reason': 'Attending cloud infrastructure conference in Denver.',
      'initial': 'L',
      'color': const Color(0xFF455B72),
    },
  ];

  final List<Map<String, dynamic>> announcements = [
    {
      'type': 'EVENT',
      'date': '2026-08-08',
      'title': 'Annual Q3 Townhall & Employee Recognition Awards',
      'description':
      'Join us on Friday, August 22nd at 3:00 PM EST for our quarterly company-wide town hall meeting. We will share strategic updates, product roadmaps, and celebrate team achievements!',
      'icon': '🎉',
      'color': const Color(0xFF5969FF),
    },
    {
      'type': 'POLICY',
      'date': '2026-08-04',
      'title': 'Updated Remote Work & Hybrid Office Guidelines',
      'description':
      'We have updated our flexible hybrid policy. Employees are encouraged to align with department leads for key team sync days. Please review the updated handbook in the Documents section.',
      'icon': '⚠️',
      'color': const Color(0xFF5969FF),
    },
    {
      'type': 'URGENT',
      'date': '2026-08-02',
      'title': 'Open Enrollment for Health & Dental Benefits',
      'description':
      'The annual open enrollment window for healthcare benefits begins on September 1st. Please review your elected coverage and make updates before September 15th.',
      'icon': '📢',
      'color': const Color(0xFF5969FF),
    },
  ];

  final List<Map<String, dynamic>> auditLogs = [
    {
      'level': 'HIGH',
      'title': 'SALARY CHANGE',
      'subtitle': 'Employee: David Vance (EMP-1002)',
      'description':
      'Base salary adjusted from \$125,000 to \$135,000 per annum (+8.0%). Updated HRA and transport allowances.',
      'user': 'Sarah Jenkins',
      'time': '02:58 PM',
    },
    {
      'level': 'MEDIUM',
      'title': 'LEAVE APPROVAL',
      'subtitle': 'Leave Request: Alex Mercer (3 Days PAID)',
      'description':
      'Approved paid annual leave request for period 2026-08-15 to 2026-08-17. Deducted 3 days from paid balance.',
      'user': 'Sarah Jenkins',
      'time': '01:28 PM',
    },
    {
      'level': 'HIGH',
      'title': 'PAYROLL PROCESS',
      'subtitle': 'Payroll Batch: July 2026',
      'description':
      'Executed monthly batch payroll disbursement for 8 active personnel. Total Net Disbursed: \$68,450.00.',
      'user': 'Sarah Jenkins',
      'time': '11:28 AM',
    },
    {
      'level': 'MEDIUM',
      'title': 'EMPLOYEE UPDATE',
      'subtitle': 'Employee: Elena Rostova (EMP-1004)',
      'description':
      'Updated job designation to Senior UX/UI Specialist and reassigned primary manager.',
      'user': 'David Vance',
      'time': '05:28 AM',
    },
  ];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1220,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildKpiCards(),
                    const SizedBox(height: 24),
                    _buildChartsSection(),
                    const SizedBox(height: 24),
                    _buildRequestsAndAnnouncements(),
                    const SizedBox(height: 24),
                    _buildAuditSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      constraints: const BoxConstraints(minHeight: 138),
      padding: const EdgeInsets.symmetric(
        horizontal: 23,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF171B42),
            Color(0xFF10192E),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool compact = constraints.maxWidth < 700;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderTop(),
                const SizedBox(height: 14),
                _buildHeaderTitle(),
                const SizedBox(height: 15),
                _buildHeaderButtons(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderTop(),
                    const SizedBox(height: 13),
                    _buildHeaderTitle(),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              _buildHeaderButtons(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderTop() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF24245D),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF4141A2),
            ),
          ),
          child: const Text(
            'Admin & HR Command Center',
            style: TextStyle(
              color: Color(0xFF9AA6FF),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Text(
          '· Tuesday, Aug 18, 2026',
          style: TextStyle(
            color: Color(0xFF9CA8C2),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Executive HR Overview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Real-time workforce stats, today's attendance logs, pending leave approvals, and payroll overview.",
          style: TextStyle(
            color: Colors.white.withOpacity(.82),
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.person_add_alt_1_outlined,
            size: 16,
          ),
          label: const Text('Add Employee'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5339F5),
            foregroundColor: Colors.white,
            elevation: 5,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 11,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.attach_money,
            size: 17,
            color: Color(0xFF00C991),
          ),
          label: const Text('Process Payroll'),
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFF252D43),
            foregroundColor: Colors.white,
            side: const BorderSide(
              color: Color(0xFF39445C),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 11,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // KPI CARDS
  // ============================================================

  Widget _buildKpiCards() {
    final cards = [
      _KpiData(
        title: 'TOTAL WORKFORCE',
        value: '8',
        icon: Icons.people_outline,
        iconBg: const Color(0xFFF0F2FF),
        iconColor: const Color(0xFF5447F5),
        footer: '7 Active · 1 On Leave',
        extra: '+2 this month',
      ),
      _KpiData(
        title: "TODAY'S ATTENDANCE",
        value: '0%',
        icon: Icons.check_circle_outline,
        iconBg: const Color(0xFFEAFBF5),
        iconColor: const Color(0xFF00A873),
        footer: '0 Late Arrivals · 1 Approved Absences',
        extra: '(0/8 Present)',
      ),
      _KpiData(
        title: 'PENDING REQUESTS',
        value: '2',
        icon: Icons.calendar_month_outlined,
        iconBg: const Color(0xFFFFF8E9),
        iconColor: const Color(0xFFFFA400),
        footer: 'Average approval turnaround: < 4 hours',
        extra: 'Requires Review',
      ),
      _KpiData(
        title: 'MONTHLY PAYROLL EST.',
        value: '\$95,875',
        icon: Icons.attach_money,
        iconBg: const Color(0xFFEFF5FF),
        iconColor: const Color(0xFF2974F2),
        footer: 'Gross Base + HRA + Allowances',
        extra: '',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 650) {
          return Column(
            children: cards
                .map(
                  (card) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildKpiCard(card),
              ),
            )
                .toList(),
          );
        }

        if (constraints.maxWidth < 950) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildKpiCard(cards[0])),
                  const SizedBox(width: 14),
                  Expanded(child: _buildKpiCard(cards[1])),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _buildKpiCard(cards[2])),
                  const SizedBox(width: 14),
                  Expanded(child: _buildKpiCard(cards[3])),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: _buildKpiCard(cards[0])),
            const SizedBox(width: 16),
            Expanded(child: _buildKpiCard(cards[1])),
            const SizedBox(width: 16),
            Expanded(child: _buildKpiCard(cards[2])),
            const SizedBox(width: 16),
            Expanded(child: _buildKpiCard(cards[3])),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(_KpiData data) {
    return Container(
      height: 151,
      padding: const EdgeInsets.fromLTRB(
        20,
        19,
        18,
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFDCE3EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    color: Color(0xFF5A708D),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .3,
                  ),
                ),
              ),
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  data.icon,
                  color: data.iconColor,
                  size: 21,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.value,
                style: const TextStyle(
                  color: Color(0xFF071A35),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              if (data.extra.isNotEmpty) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      data.extra,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: data.title == 'PENDING REQUESTS'
                            ? const Color(0xFFFF9000)
                            : data.title == 'TOTAL WORKFORCE'
                            ? const Color(0xFF00A77A)
                            : const Color(0xFF315780),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const Spacer(),
          Text(
            data.footer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF607694),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHARTS SECTION
  // ============================================================

  Widget _buildChartsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return Column(
            children: [
              _buildAttendanceCard(),
              const SizedBox(height: 18),
              _buildDepartmentCard(),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: _buildAttendanceCard(),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: _buildDepartmentCard(),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ATTENDANCE CHART
  // ============================================================

  Widget _buildAttendanceCard() {
    return _dashboardCard(
      child: Column(
        children: [
          _sectionHeader(
            icon: Icons.bar_chart_rounded,
            iconColor: const Color(0xFF5144F6),
            title: 'Weekly Attendance Breakdown',
            subtitle:
            'Present vs Late vs Absent counts for the current week',
            action: 'View Attendance Log →',
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 285,
            child: CustomPaint(
              painter: _AttendanceChartPainter(),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DEPARTMENT DONUT
  // ============================================================

  Widget _buildDepartmentCard() {
    return _dashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader(
            icon: Icons.pie_chart_outline,
            iconColor: const Color(0xFF5144F6),
            title: 'Department Distribution',
            subtitle: 'Employee allocation by department',
            action: 'Manage',
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 190,
            child: CustomPaint(
              painter: _DepartmentDonutPainter(),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: const Color(0xFFE9EDF2),
          ),
          const SizedBox(height: 11),
          _departmentLegend(
            'Executive & HR',
            '1',
            const Color(0xFF6366E8),
          ),
          _departmentLegend(
            'Engineering & Tech',
            '3',
            const Color(0xFF3B82F6),
          ),
          _departmentLegend(
            'Product & Design',
            '1',
            const Color(0xFF10B981),
          ),
          _departmentLegend(
            'Marketing & Sales',
            '2',
            const Color(0xFFFF9D00),
          ),
          _departmentLegend(
            'Finance & Accounts',
            '1',
            const Color(0xFFE84692),
          ),
        ],
      ),
    );
  }

  Widget _departmentLegend(
      String title,
      String count,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF263C5C),
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              color: Color(0xFF152844),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REQUESTS + ANNOUNCEMENTS
  // ============================================================

  Widget _buildRequestsAndAnnouncements() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return Column(
            children: [
              _buildLeaveRequests(),
              const SizedBox(height: 18),
              _buildAnnouncements(),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildLeaveRequests(),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildAnnouncements(),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LEAVE REQUESTS
  // ============================================================

  Widget _buildLeaveRequests() {
    return _dashboardCard(
      minHeight: 360,
      child: Column(
        children: [
          _sectionHeader(
            icon: Icons.calendar_month_outlined,
            iconColor: const Color(0xFFFFA000),
            title: 'Pending Leave Approvals',
            subtitle: 'Requires HR or Manager decision',
            action: 'View All (4)',
          ),
          const SizedBox(height: 16),
          ...leaveRequests.map(
                (request) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _leaveRequestItem(request),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaveRequestItem(
      Map<String, dynamic> request,
      ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFDCE4EE),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 500) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _leavePerson(request),
                const SizedBox(height: 12),
                _leaveButtons(request),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _leavePerson(request),
              ),
              const SizedBox(width: 12),
              _leaveButtons(request),
            ],
          );
        },
      ),
    );
  }

  Widget _leavePerson(
      Map<String, dynamic> request,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _avatar(
          request['initial'],
          request['color'],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request['name'],
                style: const TextStyle(
                  color: Color(0xFF172840),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF536E94),
                    fontSize: 10,
                  ),
                  children: [
                    TextSpan(
                      text:
                      '${request['type']} · ${request['days']} ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: '(${request['period']})',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '"${request['reason']}"',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF5E7697),
                  fontSize: 9.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _leaveButtons(
      Map<String, dynamic> request,
      ) {
    return Wrap(
      spacing: 7,
      runSpacing: 6,
      children: [
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${request['name']} leave approved.',
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A474),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 8,
            ),
            minimumSize: Size.zero,
            tapTargetSize:
            MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text('Approve'),
        ),
        OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${request['name']} leave rejected.',
                ),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFF1744),
            side: const BorderSide(
              color: Color(0xFFDDE3ED),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 8,
            ),
            minimumSize: Size.zero,
            tapTargetSize:
            MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text('Reject'),
        ),
      ],
    );
  }

  // ============================================================
  // ANNOUNCEMENTS
  // ============================================================

  Widget _buildAnnouncements() {
    return _dashboardCard(
      minHeight: 360,
      child: Column(
        children: [
          _sectionHeader(
            icon: Icons.campaign_outlined,
            iconColor: const Color(0xFF5144F6),
            title: 'Company Announcements',
            subtitle: 'Broadcasting updates to workforce',
            action: 'Broadcast New',
          ),
          const SizedBox(height: 16),
          ...announcements.map(
                (announcement) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _announcementItem(announcement),
            ),
          ),
        ],
      ),
    );
  }

  Widget _announcementItem(
      Map<String, dynamic> item,
      ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE4EAF1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EBFF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item['type'],
                  style: const TextStyle(
                    color: Color(0xFF4D5CF3),
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                item['date'],
                style: const TextStyle(
                  color: Color(0xFF7D91AC),
                  fontSize: 8.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            '${item['icon']}  ${item['title']}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF152A46),
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item['description'],
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF536E91),
              fontSize: 9.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AUDIT LOG
  // ============================================================

  Widget _buildAuditSection() {
    return _dashboardCard(
      child: Column(
        children: [
          _sectionHeader(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFFFF1744),
            title: 'Live Security & Operational Audit Log',
            subtitle:
            'Tracking sensitive salary changes, leave approvals, profile updates, and system operations',
            action: 'View Full Audit Ledger →',
          ),
          const SizedBox(height: 16),
          ...auditLogs.map(
                (log) => _auditItem(log),
          ),
        ],
      ),
    );
  }

  Widget _auditItem(
      Map<String, dynamic> log,
      ) {
    final bool high = log['level'] == 'HIGH';

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 11,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFE8EDF2),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _severityBadge(
                      log['level'],
                      high,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        log['title'],
                        style: const TextStyle(
                          color: Color(0xFF172A46),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                  ),
                  child: _auditDescription(log),
                ),
                const SizedBox(height: 7),
                Text(
                  '${log['user']} · ${log['time']}',
                  style: const TextStyle(
                    color: Color(0xFF647995),
                    fontSize: 9,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _severityBadge(
                log['level'],
                high,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _auditDescription(log),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      log['user'],
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1A3558),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      log['time'],
                      style: const TextStyle(
                        color: Color(0xFF7D91AC),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _auditDescription(
      Map<String, dynamic> log,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 7,
          runSpacing: 3,
          children: [
            Text(
              log['title'],
              style: const TextStyle(
                color: Color(0xFF172A46),
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '· ${log['subtitle']}',
              style: const TextStyle(
                color: Color(0xFF7B91AD),
                fontSize: 9,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          log['description'],
          style: const TextStyle(
            color: Color(0xFF476486),
            fontSize: 9.5,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _severityBadge(
      String level,
      bool high,
      ) {
    return Container(
      width: 54,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: high
            ? const Color(0xFFFFF2C9)
            : const Color(0xFFE2ECFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: high
              ? const Color(0xFFFFC629)
              : const Color(0xFFC9DAFF),
        ),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: high
              ? const Color(0xFFEF9B00)
              : const Color(0xFF3C6EF5),
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ============================================================
  // COMMON CARD
  // ============================================================

  Widget _dashboardCard({
    required Widget child,
    double? minHeight,
  }) {
    return Container(
      constraints: minHeight != null
          ? BoxConstraints(minHeight: minHeight)
          : null,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE3EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String action,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(.08),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 17,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF13253F),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF647B99),
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF5144F6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(
                  action,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Container(
          height: 1,
          color: const Color(0xFFE9EDF2),
        ),
      ],
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _avatar(
      String initial,
      Color color,
      ) {
    return Container(
      width: 39,
      height: 39,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ================================================================
// KPI MODEL
// ================================================================

class _KpiData {
  final String title;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String footer;
  final String extra;

  const _KpiData({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.footer,
    required this.extra,
  });
}

// ================================================================
// ATTENDANCE CHART PAINTER
// ================================================================

class _AttendanceChartPainter extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final double left = 40;
    final double right = 10;
    final double top = 12;
    final double bottom = 32;

    final double chartWidth =
        size.width - left - right;
    final double chartHeight =
        size.height - top - bottom;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Grid
    for (int i = 0; i <= 4; i++) {
      final double y =
          top + chartHeight * (i / 4);

      paint.color = const Color(0xFFE9EDF3);

      final Path path = Path();

      for (double x = left; x <= size.width - right; x += 7) {
        if ((x - left) % 14 < 7) {
          path.moveTo(x, y);
          path.lineTo(
            math.min(x + 5, size.width - right),
            y,
          );
        }
      }

      canvas.drawPath(path, paint);

      final text = TextPainter(
        text: TextSpan(
          text: '${8 - i * 2}',
          style: const TextStyle(
            color: Color(0xFF617897),
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      text.paint(
        canvas,
        Offset(
          left - 25,
          y - text.height / 2,
        ),
      );
    }

    final days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri (Today)',
    ];

    final present = [7, 6, 8, 7, 0];
    final late = [1, 1, 0, 1, 0];
    final absent = [0, 1, 0, 0, 1];

    final groupWidth = chartWidth / days.length;

    final presentPaint = Paint()
      ..color = const Color(0xFF6265EB);

    final latePaint = Paint()
      ..color = const Color(0xFFFFA000);

    final absentPaint = Paint()
      ..color = const Color(0xFFF23D46);

    for (int i = 0; i < days.length; i++) {
      final centerX =
          left + groupWidth * i + groupWidth / 2;

      _drawBar(
        canvas,
        centerX - 25,
        present[i],
        chartHeight,
        top,
        presentPaint,
      );

      _drawBar(
        canvas,
        centerX + 4,
        late[i],
        chartHeight,
        top,
        latePaint,
        width: 20,
      );

      _drawBar(
        canvas,
        centerX + 28,
        absent[i],
        chartHeight,
        top,
        absentPaint,
        width: 20,
      );

      final text = TextPainter(
        text: TextSpan(
          text: days[i],
          style: const TextStyle(
            color: Color(0xFF667B98),
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      text.paint(
        canvas,
        Offset(
          centerX - text.width / 2,
          size.height - 20,
        ),
      );
    }
  }

  void _drawBar(
      Canvas canvas,
      double x,
      int value,
      double chartHeight,
      double top,
      Paint paint, {
        double width = 36,
      }) {
    if (value <= 0) return;

    final double height =
        chartHeight * value / 8;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        x,
        top + chartHeight - height,
        width,
        height,
      ),
      const Radius.circular(4),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}

// ================================================================
// DONUT CHART PAINTER
// ================================================================

class _DepartmentDonutPainter extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final double radius =
        math.min(size.width, size.height) * .32;

    final values = [1, 3, 1, 2, 1];

    final colors = [
      const Color(0xFF6366E8),
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFFF9D00),
      const Color(0xFFE84692),
    ];

    final total = values.reduce((a, b) => a + b);

    double startAngle = -math.pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweep =
          (values[i] / total) * math.pi * 2;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * .28
        ..strokeCap = StrokeCap.butt
        ..color = colors[i];

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        startAngle + .025,
        sweep - .05,
        false,
        paint,
      );

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}