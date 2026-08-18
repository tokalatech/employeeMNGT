import 'package:flutter/material.dart';

class AuditLogsPage extends StatefulWidget {
  const AuditLogsPage({super.key});

  @override
  State<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends State<AuditLogsPage> {
  final TextEditingController _searchController =
  TextEditingController();

  String selectedSeverity = 'ALL';
  String selectedCategory = 'All Operations';

  final List<AuditLog> auditLogs = [
    AuditLog(
      timestamp: 'Aug 14, 2026, 02:58 PM',
      performer: 'Sarah Jenkins',
      email: 'sarah.jenkins@nexus.com',
      role: 'ADMIN',
      operation: 'SALARY CHANGE',
      severity: 'HIGH',
      target: 'Employee: David Vance (EMP-1004)',
      details:
      'Base salary adjusted from \$125,000 to \$135,000 per annum (+8.0%). Updated HRA and transport allowances.',
      ip: '192.168.1.104 (HQ Node)',
      icon: Icons.attach_money,
    ),
    AuditLog(
      timestamp: 'Aug 14, 2026, 01:28 PM',
      performer: 'Sarah Jenkins',
      email: 'sarah.jenkins@nexus.com',
      role: 'ADMIN',
      operation: 'LEAVE APPROVAL',
      severity: 'MEDIUM',
      target: 'Leave Request: Alex Mercer (LR-2026-0815)',
      details:
      'Approved paid annual leave request for period 2026-08-15 to 2026-08-17. Deducted 3 days from paid balance.',
      ip: '192.168.1.104 (HQ Node)',
      icon: Icons.check_circle_outline,
    ),
    AuditLog(
      timestamp: 'Aug 14, 2026, 11:28 AM',
      performer: 'Sarah Jenkins',
      email: 'sarah.jenkins@nexus.com',
      role: 'ADMIN',
      operation: 'PAYROLL PROCESS',
      severity: 'HIGH',
      target: 'Payroll Batch: July 2026',
      details:
      'Executed monthly batch payroll disbursement for 8 active personnel. Total Net Disbursed: \$68,450.00.',
      ip: '192.168.1.104 (HQ Node)',
      icon: Icons.attach_money,
    ),
    AuditLog(
      timestamp: 'Aug 14, 2026, 05:28 AM',
      performer: 'David Vance',
      email: 'david.vance@nexus.com',
      role: 'MANAGER',
      operation: 'EMPLOYEE UPDATE',
      severity: 'MEDIUM',
      target: 'Employee: Elena Rostova (EMP-1022)',
      details:
      'Updated job designation to Senior UX/UI Specialist and reassigned primary manager.',
      ip: '10.0.4.18 (Eng Subnet)',
      icon: Icons.person_add_alt_1_outlined,
    ),
    AuditLog(
      timestamp: 'Aug 13, 2026, 03:28 PM',
      performer: 'Sarah Jenkins',
      email: 'sarah.jenkins@nexus.com',
      role: 'ADMIN',
      operation: 'EMPLOYEE DELETE',
      severity: 'CRITICAL',
      target: 'Employee Profile: EMP-0992',
      details:
      'Permanently purged contractor profile following contract termination compliance workflow.',
      ip: '192.168.1.104 (HQ Node)',
      icon: Icons.delete_outline,
    ),
    AuditLog(
      timestamp: 'Aug 13, 2026, 10:15 AM',
      performer: 'System',
      email: 'system@nexus.com',
      role: 'SYSTEM',
      operation: 'SECURITY EVENT',
      severity: 'CRITICAL',
      target: 'Authentication Service',
      details:
      'Multiple failed login attempts detected from an unknown client and automatically blocked.',
      ip: '172.16.4.22',
      icon: Icons.security_outlined,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AuditLog> get filteredLogs {
    final query = _searchController.text.trim().toLowerCase();

    return auditLogs.where((log) {
      final matchesSeverity = selectedSeverity == 'ALL' ||
          log.severity == selectedSeverity;

      final matchesCategory =
          selectedCategory == 'All Operations' ||
              log.operation == selectedCategory;

      final matchesSearch = query.isEmpty ||
          log.performer.toLowerCase().contains(query) ||
          log.email.toLowerCase().contains(query) ||
          log.operation.toLowerCase().contains(query) ||
          log.target.toLowerCase().contains(query) ||
          log.details.toLowerCase().contains(query);

      return matchesSeverity &&
          matchesCategory &&
          matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 25),
            _buildStatistics(),
            const SizedBox(height: 25),
            _buildFilters(),
            const SizedBox(height: 20),
            _buildAuditLogs(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade900,
            Colors.deepPurple.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerText(),
                const SizedBox(height: 24),
                _headerButtons(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _headerText(),
              ),
              const SizedBox(width: 25),
              _headerButtons(),
            ],
          );
        },
      ),
    );
  }

  Widget _headerText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.red.withOpacity(0.55),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Security Audit Trail',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '· ${auditLogs.length} events logged',
              style: TextStyle(
                color: Colors.blueGrey.shade200,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Audit & Compliance Logs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Real-time immutable security ledger tracking salary adjustments, leave decisions, profile mutations, and payroll disbursements.',
          style: TextStyle(
            color: Colors.blueGrey.shade100,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _headerButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        OutlinedButton.icon(
          onPressed: _exportCsv,
          icon: const Icon(
            Icons.download_outlined,
            color: Colors.white,
          ),
          label: const Text(
            'Export CSV',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            side: BorderSide(
              color: Colors.white.withOpacity(0.25),
            ),
            backgroundColor:
            Colors.white.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _purgeTrail,
          icon: const Icon(
            Icons.delete_sweep_outlined,
            color: Colors.white,
          ),
          label: const Text(
            'Purge Trail',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    final critical = auditLogs
        .where((log) => log.severity == 'CRITICAL')
        .length;

    final high = auditLogs
        .where((log) => log.severity == 'HIGH')
        .length;

    final medium = auditLogs
        .where((log) => log.severity == 'MEDIUM')
        .length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 850;

        final cards = [
          _statCard(
            title: 'TOTAL EVENTS',
            value: '${auditLogs.length}',
            subtitle: 'Logged audit events',
            icon: Icons.receipt_long_outlined,
            iconColor: Colors.indigo,
          ),
          _statCard(
            title: 'CRITICAL',
            value: '$critical',
            subtitle: 'Requires attention',
            icon: Icons.warning_amber_outlined,
            iconColor: Colors.redAccent,
          ),
          _statCard(
            title: 'HIGH',
            value: '$high',
            subtitle: 'High-risk operations',
            icon: Icons.priority_high_outlined,
            iconColor: Colors.orange,
          ),
          _statCard(
            title: 'MEDIUM',
            value: '$medium',
            subtitle: 'Standard review items',
            icon: Icons.info_outline,
            iconColor: Colors.blue,
          ),
        ];

        if (compact) {
          return Column(
            children: cards
                .map(
                  (card) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 14,
                ),
                child: card,
              ),
            )
                .toList(),
          );
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 18),
            Expanded(child: cards[1]),
            const SizedBox(width: 18),
            Expanded(child: cards[2]),
            const SizedBox(width: 18),
            Expanded(child: cards[3]),
          ],
        );
      },
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      height: 165,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.blueGrey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  title,
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Color.fromARGB(255, 13, 27, 53),
              fontSize: 29,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.blueGrey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.blueGrey.shade100,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchField(),
                const SizedBox(height: 14),
                _filterControls(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _searchField(),
              ),
              const SizedBox(width: 14),
              _filterControls(),
            ],
          );
        },
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText:
        'Search performer, operation, target...',
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.blueGrey,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _filterControls() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _dropdown(
          value: selectedSeverity,
          items: const [
            'ALL',
            'CRITICAL',
            'HIGH',
            'MEDIUM',
            'LOW',
          ],
          onChanged: (value) {
            setState(() {
              selectedSeverity = value;
            });
          },
        ),
        _dropdown(
          value: selectedCategory,
          items: const [
            'All Operations',
            'SALARY CHANGE',
            'LEAVE APPROVAL',
            'PAYROLL PROCESS',
            'EMPLOYEE UPDATE',
            'EMPLOYEE DELETE',
            'SECURITY EVENT',
          ],
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
          },
        ),
      ],
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }

  // ============================================================
  // AUDIT LOG LIST
  // ============================================================

  Widget _buildAuditLogs() {
    final logs = filteredLogs;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.blueGrey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              22,
              24,
              18,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Audit Event Ledger',
                    style: TextStyle(
                      color: Color.fromARGB(
                        255,
                        10,
                        28,
                        54,
                      ),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${logs.length} Events',
                  style: TextStyle(
                    color: Colors.blueGrey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.blueGrey.shade100,
          ),
          if (logs.isEmpty)
            _emptyState()
          else
            ...logs.map(
                  (log) => _auditLogCard(log),
            ),
        ],
      ),
    );
  }

  Widget _auditLogCard(AuditLog log) {
    return InkWell(
      onTap: () => _showLogDetails(log),
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          20,
          16,
          20,
          0,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _operationColor(
                      log.operation,
                    ).withOpacity(0.10),
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: Icon(
                    log.icon,
                    color: _operationColor(
                      log.operation,
                    ),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 7,
                        children: [
                          _operationBadge(
                            log.operation,
                          ),
                          _severityBadge(
                            log.severity,
                          ),
                          _roleBadge(log.role),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Text(
                        log.target,
                        style: const TextStyle(
                          color: Color.fromARGB(
                            255,
                            9,
                            27,
                            52,
                          ),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showLogDetails(log);
                  },
                  tooltip: 'View details',
                  icon: Icon(
                    Icons.visibility_outlined,
                    color: Colors.blueGrey.shade400,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              log.details,
              style: TextStyle(
                color: Colors.blueGrey.shade600,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            Divider(
              height: 1,
              color: Colors.grey.shade200,
            ),

            const SizedBox(height: 13),

            Wrap(
              spacing: 22,
              runSpacing: 10,
              children: [
                _infoItem(
                  Icons.access_time_outlined,
                  log.timestamp,
                ),
                _infoItem(
                  Icons.person_outline,
                  '${log.performer} · ${log.email}',
                ),
                _infoItem(
                  Icons.language_outlined,
                  log.ip,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _operationBadge(String operation) {
    final color = _operationColor(operation);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        operation,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _severityBadge(String severity) {
    Color color;

    switch (severity) {
      case 'CRITICAL':
        color = Colors.redAccent;
        break;
      case 'HIGH':
        color = Colors.orange;
        break;
      case 'MEDIUM':
        color = Colors.blue;
        break;
      default:
        color = Colors.blueGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        severity,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _roleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: Colors.blueGrey.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _infoItem(
      IconData icon,
      String text,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.blueGrey.shade400,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.blueGrey.shade500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(55),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 55,
              color: Colors.blueGrey.shade200,
            ),
            const SizedBox(height: 14),
            Text(
              'No audit logs found',
              style: TextStyle(
                color: Colors.blueGrey.shade600,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Try changing the search or filters.',
              style: TextStyle(
                color: Colors.blueGrey.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // OPERATION COLORS
  // ============================================================

  Color _operationColor(String operation) {
    switch (operation) {
      case 'SALARY CHANGE':
      case 'PAYROLL PROCESS':
        return Colors.green.shade600;

      case 'LEAVE APPROVAL':
        return Colors.blue.shade600;

      case 'EMPLOYEE UPDATE':
        return Colors.deepPurpleAccent;

      case 'EMPLOYEE DELETE':
        return Colors.redAccent;

      case 'SECURITY EVENT':
        return Colors.indigoAccent;

      default:
        return Colors.blueGrey;
    }
  }

  // ============================================================
  // LOG DETAILS
  // ============================================================

  void _showLogDetails(AuditLog log) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Icon(
                log.icon,
                color: _operationColor(
                  log.operation,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Audit Log Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _detailRow(
                    'Timestamp',
                    log.timestamp,
                  ),
                  _detailRow(
                    'Performer',
                    log.performer,
                  ),
                  _detailRow(
                    'Email',
                    log.email,
                  ),
                  _detailRow(
                    'Role',
                    log.role,
                  ),
                  _detailRow(
                    'Operation',
                    log.operation,
                  ),
                  _detailRow(
                    'Severity',
                    log.severity,
                  ),
                  _detailRow(
                    'Target',
                    log.target,
                  ),
                  _detailRow(
                    'IP Address',
                    log.ip,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    log.details,
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.blueGrey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color.fromARGB(
                  255,
                  12,
                  28,
                  53,
                ),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EXPORT CSV
  // ============================================================

  void _exportCsv() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Audit logs are ready to export as CSV.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // PURGE AUDIT TRAIL
  // ============================================================

  void _purgeTrail() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Purge Audit Trail',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to purge the audit trail? '
                'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Audit trail purge request submitted.',
                    ),
                    behavior:
                    SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Purge'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// AUDIT LOG MODEL
// ============================================================

class AuditLog {
  final String timestamp;
  final String performer;
  final String email;
  final String role;
  final String operation;
  final String severity;
  final String target;
  final String details;
  final String ip;
  final IconData icon;

  AuditLog({
    required this.timestamp,
    required this.performer,
    required this.email,
    required this.role,
    required this.operation,
    required this.severity,
    required this.target,
    required this.details,
    required this.ip,
    required this.icon,
  });
}