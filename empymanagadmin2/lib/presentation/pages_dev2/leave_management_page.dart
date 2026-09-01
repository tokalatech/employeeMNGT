import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaveManagementPage extends StatefulWidget {
  const LeaveManagementPage({super.key});

  @override
  State<LeaveManagementPage> createState() => _LeaveManagementPageState();
}

class _LeaveManagementPageState extends State<LeaveManagementPage> {
  String selectedFilter = 'All Requests';

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  // ============================================================
  // FIRESTORE STATE
  // ============================================================

  List<LeaveRequest> leaveRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FIRESTORE HELPERS
  // ============================================================

  Future<void> _fetchLeaveRequests() async {
    setState(() {
      isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('leave_requests')
          .orderBy('createdAt', descending: true)
          .get();

      if (!mounted) return;

      setState(() {
        leaveRequests = snapshot.docs
            .map((doc) => LeaveRequest.fromFirestore(doc.id, doc.data()))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to fetch leave requests: $e');

      if (!mounted) return;

      setState(() {
        leaveRequests = [];
        isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(LeaveRequest request, String status) async {
    // Optimistic local update
    setState(() {
      request.status = status;
    });

    try {
      await FirebaseFirestore.instance
          .collection('leave_requests')
          .doc(request.id)
          .update({
        'status': status,
        'reviewedAt': DateTime.now().toIso8601String(),
        'reviewedBy': 'Sarah Jenkins',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${request.employee} leave request $status.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Failed to update leave status: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update leave request. Try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Re-fetch to reflect the true server state on failure.
      _fetchLeaveRequests();
    }
  }

  Future<void> _createLeaveRequest({
    required String employeeName,
    required String leaveType,
    required String reason,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final int totalDays = endDate.difference(startDate).inDays + 1;

    try {
      final docRef =
      await FirebaseFirestore.instance.collection('leave_requests').add({
        'employeeName': employeeName,
        'employeeId': '',
        'employeeAvatar': '',
        'department': '',
        'leaveType': leaveType,
        'reason': reason,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'totalDays': totalDays,
        'status': 'Pending',
        'appliedDate': DateTime.now().toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
        'attachmentName': '',
        'rejectionReason': null,
        'reviewedAt': null,
        'reviewedBy': null,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leave request created successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Insert locally so the UI updates immediately, then re-sync.
      setState(() {
        leaveRequests.insert(
          0,
          LeaveRequest(
            id: docRef.id,
            employee: employeeName,
            employeeId: '',
            leaveType: leaveType,
            fromDate: _formatDate(startDate),
            toDate: _formatDate(endDate),
            startDateRaw: startDate,
            endDateRaw: endDate,
            days: totalDays,
            reason: reason,
            status: 'Pending',
            initials: _getInitials(employeeName),
          ),
        );
      });
    } catch (e) {
      debugPrint('Failed to create leave request: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create leave request. Try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // FILTERING
  // ============================================================

  List<LeaveRequest> get filteredRequests {
    Iterable<LeaveRequest> result = leaveRequests;

    if (selectedFilter != 'All Requests') {
      result = result.where((request) => request.status == selectedFilter);
    }

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();

      result = result.where((request) =>
      request.employee.toLowerCase().contains(query) ||
          request.leaveType.toLowerCase().contains(query) ||
          request.reason.toLowerCase().contains(query));
    }

    return result.toList();
  }

  // ============================================================
  // STAT COMPUTATIONS
  // ============================================================

  int get _pendingCount =>
      leaveRequests.where((r) => r.status == 'Pending').length;

  int get _approvedCount =>
      leaveRequests.where((r) => r.status == 'Approved').length;

  int get _onLeaveTodayCount {
    final DateTime today = DateTime.now();
    final DateTime todayDateOnly = DateTime(today.year, today.month, today.day);

    return leaveRequests.where((r) {
      if (r.status != 'Approved') return false;
      if (r.startDateRaw == null || r.endDateRaw == null) return false;

      final start = DateTime(
        r.startDateRaw!.year,
        r.startDateRaw!.month,
        r.startDateRaw!.day,
      );
      final end = DateTime(
        r.endDateRaw!.year,
        r.endDateRaw!.month,
        r.endDateRaw!.day,
      );

      return !todayDateOnly.isBefore(start) && !todayDateOnly.isAfter(end);
    }).length;
  }

  int get _totalDaysThisMonth {
    final DateTime now = DateTime.now();

    return leaveRequests
        .where((r) =>
    r.startDateRaw != null &&
        r.startDateRaw!.year == now.year &&
        r.startDateRaw!.month == now.month)
        .fold<int>(0, (sum, r) => sum + r.days);
  }

  // ============================================================
  // DATE FORMATTING
  // ============================================================

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) {
    final String month = _months[date.month - 1];
    final String day = date.day.toString().padLeft(2, '0');
    return '$month $day, ${date.year}';
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
            _buildFilterBar(),
            const SizedBox(height: 20),
            _buildLeaveTable(),
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
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 850;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerText(),
                const SizedBox(height: 22),
                _newRequestButton(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _headerText(),
              ),
              const SizedBox(width: 20),
              _newRequestButton(),
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
                horizontal: 14,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.indigoAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.indigoAccent.withOpacity(0.40),
                ),
              ),
              child: const Text(
                'Leave Administration',
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '· $_pendingCount Pending Requests',
              style: TextStyle(
                color: Colors.blueGrey.shade300,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Leave Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 31,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Review employee leave requests, manage balances, and monitor leave activity.',
          style: TextStyle(
            color: Colors.blueGrey.shade200,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _newRequestButton() {
    return ElevatedButton.icon(
      onPressed: _showNewLeaveDialog,
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: const Text(
        'Create Leave Request',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigoAccent,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 4,
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 850;

        final cards = [
          _statCard(
            title: 'PENDING REQUESTS',
            value: '$_pendingCount',
            subtitle: 'Awaiting approval',
            icon: Icons.pending_actions_outlined,
            iconColor: Colors.orange,
          ),
          _statCard(
            title: 'APPROVED',
            value: '$_approvedCount',
            subtitle: 'Approved leave requests',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
          ),
          _statCard(
            title: 'ON LEAVE TODAY',
            value: '$_onLeaveTodayCount',
            subtitle: 'Employees currently away',
            icon: Icons.beach_access_outlined,
            iconColor: Colors.blue,
          ),
          _statCard(
            title: 'TOTAL DAYS',
            value: '$_totalDaysThisMonth',
            subtitle: 'Leave days this month',
            icon: Icons.calendar_month_outlined,
            iconColor: Colors.deepPurple,
          ),
        ];

        if (compact) {
          return Column(
            children: cards
                .map(
                  (card) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
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
      height: 170,
      padding: const EdgeInsets.all(23),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 23,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Color.fromARGB(255, 13, 27, 53),
              fontSize: 30,
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
  // FILTER BAR
  // ============================================================

  Widget _buildFilterBar() {
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
          final compact = constraints.maxWidth < 700;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchBox(),
                const SizedBox(height: 14),
                _filterDropdown(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _searchBox(),
              ),
              const SizedBox(width: 15),
              _filterDropdown(),
            ],
          );
        },
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.blueGrey,
          ),
          hintText: 'Search employee, leave type or reason...',
          contentPadding: EdgeInsets.symmetric(
            vertical: 13,
          ),
        ),
      ),
    );
  }

  Widget _filterDropdown() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedFilter,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: const [
            DropdownMenuItem(
              value: 'All Requests',
              child: Text('All Requests'),
            ),
            DropdownMenuItem(
              value: 'Pending',
              child: Text('Pending'),
            ),
            DropdownMenuItem(
              value: 'Approved',
              child: Text('Approved'),
            ),
            DropdownMenuItem(
              value: 'Rejected',
              child: Text('Rejected'),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedFilter = value;
            });
          },
        ),
      ),
    );
  }

  // ============================================================
  // LEAVE TABLE
  // ============================================================

  Widget _buildLeaveTable() {
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
                    'Leave Requests',
                    style: TextStyle(
                      color: Color.fromARGB(255, 10, 28, 54),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${filteredRequests.length} Requests',
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
          _buildTableHeader(),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              ),
            )
          else if (filteredRequests.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'No leave requests match the current filters.',
                  style: TextStyle(
                    color: Colors.blueGrey.shade400,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ...filteredRequests.map(
                  (request) => _buildLeaveRow(request),
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 14,
      ),
      color: Colors.grey.shade50,
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'EMPLOYEE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'LEAVE TYPE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'DATES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'DAYS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'STATUS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              'ACTION',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRow(LeaveRequest request) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: Colors.indigo.withOpacity(0.10),
                  child: Text(
                    request.initials,
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.employee,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 12, 29, 54),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        request.employeeId.isEmpty
                            ? '--'
                            : request.employeeId,
                        style: TextStyle(
                          color: Colors.blueGrey.shade400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              request.leaveType,
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              '${request.fromDate}\n${request.toDate}',
              style: TextStyle(
                color: Colors.blueGrey.shade600,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              '${request.days}',
              style: const TextStyle(
                color: Color.fromARGB(255, 15, 31, 57),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: _statusBadge(request.status),
          ),

          SizedBox(
            width: 90,
            child: request.status == 'Pending'
                ? Row(
              children: [
                IconButton(
                  onPressed: () {
                    _updateStatus(
                      request,
                      'Approved',
                    );
                  },
                  tooltip: 'Approve',
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _updateStatus(
                      request,
                      'Rejected',
                    );
                  },
                  tooltip: 'Reject',
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ],
            )
                : IconButton(
              onPressed: () {
                _showRequestDetails(request);
              },
              tooltip: 'View',
              icon: Icon(
                Icons.visibility_outlined,
                color: Colors.blueGrey.shade500,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color background;
    Color foreground;

    switch (status) {
      case 'Approved':
        background = Colors.green.shade50;
        foreground = Colors.green.shade700;
        break;

      case 'Rejected':
        background = Colors.red.shade50;
        foreground = Colors.red.shade700;
        break;

      default:
        background = Colors.orange.shade50;
        foreground = Colors.orange.shade800;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: foreground,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DETAILS DIALOG
  // ============================================================

  void _showRequestDetails(LeaveRequest request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Leave Request Details',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow(
                'Employee',
                request.employee,
              ),
              _detailRow(
                'Employee ID',
                request.employeeId.isEmpty ? '--' : request.employeeId,
              ),
              _detailRow(
                'Leave Type',
                request.leaveType,
              ),
              _detailRow(
                'From',
                request.fromDate,
              ),
              _detailRow(
                'To',
                request.toDate,
              ),
              _detailRow(
                'Days',
                request.days.toString(),
              ),
              _detailRow(
                'Reason',
                request.reason,
              ),
              _detailRow(
                'Status',
                request.status,
              ),
            ],
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
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
                color: Color.fromARGB(255, 14, 29, 53),
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
  // CREATE REQUEST DIALOG
  // ============================================================

  void _showNewLeaveDialog() {
    final employeeController = TextEditingController();
    final reasonController = TextEditingController();

    String leaveType = 'Annual Leave';
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickStartDate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: startDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );

              if (picked != null) {
                setDialogState(() {
                  startDate = picked;

                  if (endDate != null && endDate!.isBefore(startDate!)) {
                    endDate = startDate;
                  }
                });
              }
            }

            Future<void> pickEndDate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: endDate ?? startDate ?? DateTime.now(),
                firstDate: startDate ?? DateTime(2020),
                lastDate: DateTime(2035),
              );

              if (picked != null) {
                setDialogState(() {
                  endDate = picked;
                });
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                'Create Leave Request',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: SizedBox(
                width: 430,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: employeeController,
                        decoration: InputDecoration(
                          labelText: 'Employee Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: leaveType,
                        decoration: InputDecoration(
                          labelText: 'Leave Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Annual Leave',
                            child: Text('Annual Leave'),
                          ),
                          DropdownMenuItem(
                            value: 'Sick Leave',
                            child: Text('Sick Leave'),
                          ),
                          DropdownMenuItem(
                            value: 'Personal Leave',
                            child: Text('Personal Leave'),
                          ),
                          DropdownMenuItem(
                            value: 'Paid Leave',
                            child: Text('Paid Leave'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            leaveType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: pickStartDate,
                              child: Text(
                                startDate == null
                                    ? 'From Date'
                                    : _formatDate(startDate!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: pickEndDate,
                              child: Text(
                                endDate == null
                                    ? 'To Date'
                                    : _formatDate(endDate!),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Reason',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                    if (employeeController.text.trim().isEmpty) {
                      return;
                    }

                    if (startDate == null || endDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select from and to dates.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    Navigator.pop(dialogContext);

                    _createLeaveRequest(
                      employeeName: employeeController.text.trim(),
                      leaveType: leaveType,
                      reason: reasonController.text.trim().isEmpty
                          ? 'No reason provided'
                          : reasonController.text.trim(),
                      startDate: startDate!,
                      endDate: endDate!,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');

    if (parts.length == 1) {
      return parts.first.isEmpty
          ? 'NA'
          : parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}

// ============================================================
// MODEL
// ============================================================

class LeaveRequest {
  final String id;
  final String employee;
  final String employeeId;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final DateTime? startDateRaw;
  final DateTime? endDateRaw;
  final int days;
  final String reason;
  String status;
  final String initials;

  LeaveRequest({
    required this.id,
    required this.employee,
    required this.employeeId,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    this.startDateRaw,
    this.endDateRaw,
    required this.days,
    required this.reason,
    required this.status,
    required this.initials,
  });

  // ============================================================
  // FIRESTORE MAPPING
  // ============================================================

  factory LeaveRequest.fromFirestore(String id, Map<String, dynamic> data) {
    final String employeeName =
    (data['employeeName'] ?? 'Unknown').toString();

    final DateTime? start = _parseDate(data['startDate']);
    final DateTime? end = _parseDate(data['endDate']);

    final int totalDays = data['totalDays'] is int
        ? data['totalDays'] as int
        : int.tryParse('${data['totalDays'] ?? 0}') ?? 0;

    return LeaveRequest(
      id: id,
      employee: employeeName,
      employeeId: (data['employeeId'] ?? '').toString(),
      leaveType: (data['leaveType'] ?? '--').toString(),
      fromDate: start != null ? _staticFormatDate(start) : '--',
      toDate: end != null ? _staticFormatDate(end) : '--',
      startDateRaw: start,
      endDateRaw: end,
      days: totalDays,
      reason: (data['reason'] ?? '').toString(),
      status: (data['status'] ?? 'Pending').toString(),
      initials: _staticInitials(employeeName),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  static const List<String> _staticMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String _staticFormatDate(DateTime date) {
    final String month = _staticMonths[date.month - 1];
    final String day = date.day.toString().padLeft(2, '0');
    return '$month $day, ${date.year}';
  }

  static String _staticInitials(String name) {
    final parts = name.trim().split(' ');

    if (parts.isEmpty || parts.first.isEmpty) {
      return 'NA';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}