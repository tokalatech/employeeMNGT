import 'package:flutter/material.dart';

class PayrollPage extends StatefulWidget {
  const PayrollPage({super.key});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  String selectedMonth = 'July 2026';

  final List<Map<String, dynamic>> employees = [
    {
      'name': 'Sarah Jenkins',
      'role': 'VP of Human Resources',
      'initial': 'S',
      'payPeriod': '2026-07-01 to 2026-07-31',
      'salary': '\$9,583.33',
      'allowances': '+\$3,750',
      'deductions': '-\$2,625',
      'netPay': '\$10,708.33',
    },
    {
      'name': 'Alex Rivera',
      'role': 'Senior Frontend Engineer',
      'initial': 'A',
      'payPeriod': '2026-07-01 to 2026-07-31',
      'salary': '\$7,916.67',
      'allowances': '+\$2,916.67',
      'deductions': '-\$2,083.34',
      'netPay': '\$8,750',
    },
    {
      'name': 'Emily Chen',
      'role': 'Lead Product Designer',
      'initial': 'E',
      'payPeriod': '2026-07-01 to 2026-07-31',
      'salary': '\$8,166.67',
      'allowances': '+\$3,083.34',
      'deductions': '-\$2,233.34',
      'netPay': '\$9,016.67',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1216,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 28),
                    _buildSummaryCards(),
                    const SizedBox(height: 28),
                    _buildPayslipSection(),
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
      height: 146,
      padding: const EdgeInsets.symmetric(
        horizontal: 27,
        vertical: 26,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF111A32),
            Color(0xFF171A46),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.13),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF063C37),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF008E75),
                        ),
                      ),
                      child: const Text(
                        'Compensation & Payroll',
                        style: TextStyle(
                          color: Color(0xFF29F1B2),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      '· Automated Disbursements',
                      style: TextStyle(
                        color: Color(0xFFADB5CA),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                const Text(
                  'Payroll & Payslips',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 9),

                const Text(
                  'Process monthly payroll, generate printable payslips, and manage employee salary structures.',
                  style: TextStyle(
                    color: Color(0xFFD8DCE9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          _buildProcessButton(),
        ],
      ),
    );
  }

  Widget _buildProcessButton() {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Monthly payroll processing started.'),
          ),
        );
      },
      icon: const Icon(
        Icons.attach_money,
        size: 19,
      ),
      label: const Text(
        'Process Monthly Payroll',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00A875),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: const Color(0x5500A875),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY CARDS
  // ============================================================

  Widget _buildSummaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return Column(
            children: [
              _summaryCard(
                title: 'GROSS EARNINGS TOTAL',
                amount: '\$35,417',
                description:
                'Basic Salary + Allowances (July 2026)',
                amountColor: const Color(0xFF061B3A),
              ),
              const SizedBox(height: 16),
              _summaryCard(
                title: 'TAX & BENEFIT DEDUCTIONS',
                amount: '\$6,942',
                description:
                'Tax + Health + PF/Retirement',
                amountColor: const Color(0xFFF00045),
              ),
              const SizedBox(height: 16),
              _summaryCard(
                title: 'NET TAKE-HOME PAY',
                amount: '\$28,475',
                description: 'Total Disbursed Net Pay',
                amountColor: const Color(0xFF009E68),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'GROSS EARNINGS TOTAL',
                amount: '\$35,417',
                description:
                'Basic Salary + Allowances (July 2026)',
                amountColor: const Color(0xFF061B3A),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: _summaryCard(
                title: 'TAX & BENEFIT DEDUCTIONS',
                amount: '\$6,942',
                description:
                'Tax + Health + PF/Retirement',
                amountColor: const Color(0xFFF00045),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: _summaryCard(
                title: 'NET TAKE-HOME PAY',
                amount: '\$28,475',
                description: 'Total Disbursed Net Pay',
                amountColor: const Color(0xFF009E68),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryCard({
    required String title,
    required String amount,
    required String description,
    required Color amountColor,
  }) {
    return Container(
      height: 146,
      padding: const EdgeInsets.fromLTRB(
        23,
        27,
        23,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE3EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.045),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: amountColor == const Color(0xFF061B3A)
                  ? const Color(0xFF60718C)
                  : amountColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: .3,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              height: .95,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF506582),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYSLIP SECTION
  // ============================================================

  Widget _buildPayslipSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        22,
        24,
        22,
        22,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFDCE3EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.045),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPayslipHeader(),
          const SizedBox(height: 18),
          Container(
            height: 1,
            color: const Color(0xFFE7EBF0),
          ),
          const SizedBox(height: 18),
          _buildEmployeeTable(),
        ],
      ),
    );
  }

  Widget _buildPayslipHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generated Employee Payslips',
                style: TextStyle(
                  color: Color(0xFF111D35),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Select any record to view or print official payslip statement',
                style: TextStyle(
                  color: Color(0xFF60718C),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        _buildMonthDropdown(),
      ],
    );
  }

  Widget _buildMonthDropdown() {
    return Container(
      width: 136,
      height: 36,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFD),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFDCE4EE),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMonth,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Color(0xFF19304F),
          ),
          style: const TextStyle(
            color: Color(0xFF1A3150),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            DropdownMenuItem(
              value: 'July 2026',
              child: Text('July 2026'),
            ),
            DropdownMenuItem(
              value: 'June 2026',
              child: Text('June 2026'),
            ),
            DropdownMenuItem(
              value: 'May 2026',
              child: Text('May 2026'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedMonth = value;
              });
            }
          },
        ),
      ),
    );
  }

  // ============================================================
  // EMPLOYEE TABLE
  // ============================================================

  Widget _buildEmployeeTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 950) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1120,
              child: _tableContent(),
            ),
          );
        }

        return _tableContent();
      },
    );
  }

  Widget _tableContent() {
    return Column(
      children: [
        _buildTableHeader(),
        ...employees.map(
              (employee) => _buildEmployeeRow(employee),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      color: const Color(0xFFF7F9FB),
      child: Row(
        children: [
          _headerCell('EMPLOYEE', 1.45),
          _headerCell('PAY PERIOD', 1.7),
          _headerCell('BASIC SALARY', 1.05),
          _headerCell('ALLOWANCES', 1.05),
          _headerCell('DEDUCTIONS', 1.05),
          _headerCell('NET PAY', .95),
          _headerCell('STATUS', .8),
          _headerCell('ACTION', 1.1),
        ],
      ),
    );
  }

  Widget _headerCell(String text, double flex) {
    return Expanded(
      flex: (flex * 100).round(),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF5D718E),
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: .35,
        ),
      ),
    );
  }

  Widget _buildEmployeeRow(
      Map<String, dynamic> employee,
      ) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE9EDF2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 145,
            child: _employeeCell(employee),
          ),

          Expanded(
            flex: 170,
            child: Text(
              employee['payPeriod'],
              style: const TextStyle(
                color: Color(0xFF35547B),
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            flex: 105,
            child: Text(
              employee['salary'],
              style: const TextStyle(
                color: Color(0xFF071C39),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Expanded(
            flex: 105,
            child: Text(
              employee['allowances'],
              style: const TextStyle(
                color: Color(0xFF4439FF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 105,
            child: Text(
              employee['deductions'],
              style: const TextStyle(
                color: Color(0xFFFF003D),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 95,
            child: Text(
              employee['netPay'],
              style: const TextStyle(
                color: Color(0xFF008E5E),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          Expanded(
            flex: 80,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD5F8E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'PAID',
                  style: TextStyle(
                    color: Color(0xFF009B68),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 110,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildViewButton(employee),
            ),
          ),
        ],
      ),
    );
  }

  Widget _employeeCell(
      Map<String, dynamic> employee,
      ) {
    return Row(
      children: [
        _buildAvatar(employee['initial']),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                employee['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF17243A),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                employee['role'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF60718C),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String initial) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: initial == 'S'
              ? const [
            Color(0xFFFFAA55),
            Color(0xFF5A6470),
          ]
              : initial == 'A'
              ? const [
            Color(0xFF9D8BEF),
            Color(0xFF6D8EF1),
          ]
              : const [
            Color(0xFFE6E6E6),
            Color(0xFFBFC4CB),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildViewButton(
      Map<String, dynamic> employee,
      ) {
    return TextButton.icon(
      onPressed: () {
        _showPayslip(employee);
      },
      icon: const Icon(
        Icons.description_outlined,
        size: 15,
      ),
      label: const Text(
        'View Payslip',
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFEFF1FF),
        foregroundColor: const Color(0xFF4C42F4),
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 6,
        ),
        minimumSize: Size.zero,
        tapTargetSize:
        MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // PAYSLIP DIALOG
  // ============================================================

  void _showPayslip(
      Map<String, dynamic> employee,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '${employee['name']} - Payslip',
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogRow(
                  'Pay Period',
                  employee['payPeriod'],
                ),
                _dialogRow(
                  'Basic Salary',
                  employee['salary'],
                ),
                _dialogRow(
                  'Allowances',
                  employee['allowances'],
                ),
                _dialogRow(
                  'Deductions',
                  employee['deductions'],
                ),
                const Divider(),
                _dialogRow(
                  'Net Pay',
                  employee['netPay'],
                  bold: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Payslip print action selected.',
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.print_outlined,
                size: 17,
              ),
              label: const Text('Print'),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogRow(
      String title,
      String value, {
        bool bold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF60718C),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF12233D),
              fontSize: 12,
              fontWeight:
              bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}