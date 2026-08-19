import 'dart:async';

import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  Timer? _timer;

  bool isClockedIn = false;

  DateTime currentTime = DateTime.now();
  DateTime selectedDate = DateTime(2026, 8, 18);

  String selectedDepartment = 'All Departments';
  String selectedStatus = 'All Statuses';

  final TextEditingController shiftNoteController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (mounted) {
          setState(() {
            currentTime = DateTime.now();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    shiftNoteController.dispose();
    super.dispose();
  }

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
                        _buildPersonalTracker(isMobile),
                        const SizedBox(height: 27),
                        _buildAttendanceRegister(isMobile),
                        const SizedBox(height: 30),
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
            Color(0xFF171B3C),
            Color(0xFF11172E),
            Color(0xFF11172D),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(17),
          bottomRight: Radius.circular(17),
        ),
      ),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge(),
          const SizedBox(height: 13),
          _buildHeaderTitle(),
          const SizedBox(height: 6),
          _buildHeaderDescription(),
          const SizedBox(height: 18),
          _buildManualAttendanceButton(),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _buildHeaderBadge(),
                const SizedBox(height: 13),
                _buildHeaderTitle(),
                const SizedBox(height: 6),
                _buildHeaderDescription(),
              ],
            ),
          ),
          _buildManualAttendanceButton(),
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
        color: const Color(0xFF006F67).withOpacity(.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF008F82),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Attendance & Time Tracking',
            style: TextStyle(
              color: Color(0xFF38E6BA),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '·',
            style: TextStyle(
              color: Color(0xFF7793A7),
              fontSize: 14,
            ),
          ),
          SizedBox(width: 7),
          Text(
            'Real-Time Duty Clock',
            style: TextStyle(
              color: Color(0xFF9CB3C9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return const Text(
      'Time & Attendance Management',
      style: TextStyle(
        color: Colors.white,
        fontSize: 27,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildHeaderDescription() {
    return const Text(
      'Live check-in console, shift notes, daily attendance registers, and manual HR time adjustments.',
      style: TextStyle(
        color: Color(0xFFB8D0E4),
        fontSize: 13,
        height: 1.4,
      ),
    );
  }

  Widget _buildManualAttendanceButton() {
    return ElevatedButton.icon(
      onPressed: _showManualAttendanceDialog,
      icon: const Icon(
        Icons.add,
        size: 19,
      ),
      label: const Text(
        'Log Manual Attendance',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5739F4),
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: const Color(0xFF5739F4).withOpacity(.35),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ============================================================
  // PERSONAL TIME TRACKER
  // ============================================================

  Widget _buildPersonalTracker(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 27),
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
      child: isMobile
          ? Column(
        children: [
          _buildTrackerInformation(),
          const SizedBox(height: 18),
          _buildTrackerControls(),
        ],
      )
          : Row(
        children: [
          _buildClockIcon(),
          const SizedBox(width: 18),
          Expanded(
            child: _buildTrackerInformation(),
          ),
          const SizedBox(width: 20),
          _buildTrackerControls(),
        ],
      ),
    );
  }

  Widget _buildClockIcon() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F9),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Icon(
        Icons.access_time_outlined,
        color: Color(0xFF536982),
        size: 39,
      ),
    );
  }

  Widget _buildTrackerInformation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (MediaQuery.of(context).size.width < 850)
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: _buildClockIcon(),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isClockedIn
                          ? const Color(0xFFE5F8F1)
                          : const Color(0xFFF1F4F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isClockedIn
                          ? 'CLOCKED IN'
                          : 'NOT CLOCKED IN',
                      style: TextStyle(
                        color: isClockedIn
                            ? const Color(0xFF009A70)
                            : const Color(0xFF5B7189),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _formatTime(currentTime),
                    style: const TextStyle(
                      color: Color(0xFF8095AC),
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              const Text(
                'Personal Time Tracker (Sarah Jenkins)',
                style: TextStyle(
                  color: Color(0xFF0A1B35),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isClockedIn
                    ? 'Your shift is currently active'
                    : 'Start your shift by clocking in below',
                style: const TextStyle(
                  color: Color(0xFF607A99),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackerControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 288,
          height: 43,
          child: TextField(
            controller: shiftNoteController,
            decoration: InputDecoration(
              hintText: 'Add shift note...',
              hintStyle: const TextStyle(
                color: Color(0xFF8BA0B5),
                fontSize: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE4EC),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE4EC),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xFF00A97B),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 13),
        SizedBox(
          height: 43,
          child: ElevatedButton.icon(
            onPressed: _toggleClock,
            icon: Icon(
              isClockedIn
                  ? Icons.stop_rounded
                  : Icons.play_arrow_rounded,
              size: 20,
            ),
            label: Text(
              isClockedIn ? 'Clock Out' : 'Clock In',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A274),
              foregroundColor: Colors.white,
              elevation: 3,
              shadowColor:
              const Color(0xFF00A274).withOpacity(.25),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ATTENDANCE REGISTER
  // ============================================================

  Widget _buildAttendanceRegister(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 18 : 23,
        24,
        isMobile ? 18 : 23,
        28,
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
        children: [
          _buildRegisterHeader(isMobile),
          const SizedBox(height: 17),
          Container(
            height: 1,
            color: const Color(0xFFE6EBF0),
          ),
          const SizedBox(height: 18),
          _buildAttendanceTable(isMobile),
        ],
      ),
    );
  }

  Widget _buildRegisterHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRegisterTitle(),
          const SizedBox(height: 15),
          _buildFilters(true),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildRegisterTitle(),
        ),
        _buildFilters(false),
      ],
    );
  }

  Widget _buildRegisterTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Attendance Register',
          style: TextStyle(
            color: Color(0xFF0B1C35),
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Filtered logs for organization',
          style: TextStyle(
            color: Color(0xFF607D9F),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(bool isMobile) {
    if (isMobile) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildDateSelector(),
          _buildDepartmentDropdown(),
          _buildStatusDropdown(),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDateSelector(),
        const SizedBox(width: 13),
        _buildDepartmentDropdown(),
        const SizedBox(width: 13),
        _buildStatusDropdown(),
      ],
    );
  }

  // ============================================================
  // DATE SELECTOR
  // ============================================================

  Widget _buildDateSelector() {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: _selectDate,
      child: Container(
        width: 150,
        height: 37,
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFDDE5ED),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatDate(selectedDate),
                style: const TextStyle(
                  color: Color(0xFF304967),
                  fontSize: 12,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 15,
              color: Color(0xFF17293E),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DEPARTMENT DROPDOWN
  // ============================================================

  Widget _buildDepartmentDropdown() {
    return Container(
      width: 176,
      height: 37,
      padding: const EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFDDE5ED),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedDepartment,
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 7),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 19,
              color: Color(0xFF1D3047),
            ),
          ),
          style: const TextStyle(
            color: Color(0xFF304967),
            fontSize: 12,
          ),
          items: const [
            DropdownMenuItem(
              value: 'All Departments',
              child: Text('All Departments'),
            ),
            DropdownMenuItem(
              value: 'Engineering',
              child: Text('Engineering'),
            ),
            DropdownMenuItem(
              value: 'Finance',
              child: Text('Finance'),
            ),
            DropdownMenuItem(
              value: 'HR',
              child: Text('HR'),
            ),
            DropdownMenuItem(
              value: 'Sales',
              child: Text('Sales'),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedDepartment = value;
            });
          },
        ),
      ),
    );
  }

  // ============================================================
  // STATUS DROPDOWN
  // ============================================================

  Widget _buildStatusDropdown() {
    return Container(
      width: 128,
      height: 37,
      padding: const EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFDDE5ED),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 7),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 19,
              color: Color(0xFF1D3047),
            ),
          ),
          style: const TextStyle(
            color: Color(0xFF304967),
            fontSize: 12,
          ),
          items: const [
            DropdownMenuItem(
              value: 'All Statuses',
              child: Text('All Statuses'),
            ),
            DropdownMenuItem(
              value: 'Present',
              child: Text('Present'),
            ),
            DropdownMenuItem(
              value: 'Late',
              child: Text('Late'),
            ),
            DropdownMenuItem(
              value: 'Absent',
              child: Text('Absent'),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedStatus = value;
            });
          },
        ),
      ),
    );
  }

  // ============================================================
  // ATTENDANCE TABLE
  // ============================================================

  Widget _buildAttendanceTable(bool isMobile) {
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 950,
          child: _buildTableContent(),
        ),
      );
    }

    return _buildTableContent();
  }

  Widget _buildTableContent() {
    return Column(
      children: [
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F7F9),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 18,
                child: _TableHeader(
                  'EMPLOYEE',
                ),
              ),
              Expanded(
                flex: 12,
                child: _TableHeader(
                  'DATE',
                ),
              ),
              Expanded(
                flex: 16,
                child: _TableHeader(
                  'CHECK IN',
                ),
              ),
              Expanded(
                flex: 18,
                child: _TableHeader(
                  'CHECK OUT',
                ),
              ),
              Expanded(
                flex: 18,
                child: _TableHeader(
                  'TOTAL HOURS',
                ),
              ),
              Expanded(
                flex: 14,
                child: _TableHeader(
                  'STATUS',
                ),
              ),
              Expanded(
                flex: 14,
                child: _TableHeader(
                  'NOTES',
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 105,
          alignment: Alignment.center,
          child: const Text(
            'No attendance logs match the current filters.',
            style: TextStyle(
              color: Color(0xFF8197B0),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF513AF4),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF17263B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ============================================================
  // CLOCK IN / OUT
  // ============================================================

  void _toggleClock() {
    setState(() {
      isClockedIn = !isClockedIn;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isClockedIn
              ? 'Clocked in successfully'
              : 'Clocked out successfully',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // MANUAL ATTENDANCE
  // ============================================================

  void _showManualAttendanceDialog() {
    final TextEditingController employeeController =
    TextEditingController();

    final TextEditingController noteController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Log Manual Attendance',
            style: TextStyle(
              color: Color(0xFF0A1B35),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: employeeController,
                  decoration: InputDecoration(
                    labelText: 'Employee',
                    hintText: 'Enter employee name',
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Add attendance note...',
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Manual attendance logged successfully',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF5739F4),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FORMATTERS
  // ============================================================

  String _formatTime(DateTime time) {
    int hour = time.hour;

    final String period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    final String minute =
    time.minute.toString().padLeft(2, '0');

    final String second =
    time.second.toString().padLeft(2, '0');

    return '$hour:$minute:$second $period';
  }

  String _formatDate(DateTime date) {
    final String month =
    date.month.toString().padLeft(2, '0');

    final String day =
    date.day.toString().padLeft(2, '0');

    return '$month/$day/${date.year}';
  }
}

// ================================================================
// TABLE HEADER
// ================================================================

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF526B88),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}