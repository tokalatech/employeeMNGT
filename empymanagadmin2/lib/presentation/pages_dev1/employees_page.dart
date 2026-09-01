import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final TextEditingController _searchController = TextEditingController();

  String selectedDepartment = 'All Departments';
  String selectedEmploymentType = 'All Employment Types';
  String selectedStatus = 'All Statuses';

  bool isListView = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FILTER EMPLOYEES
  // ============================================================

  List<Employee> filterEmployees(List<Employee> employees) {
    final search = _searchController.text.toLowerCase().trim();

    return employees.where((employee) {
      final matchesSearch =
          search.isEmpty ||
              employee.name.toLowerCase().contains(search) ||
              employee.employeeId.toLowerCase().contains(search) ||
              employee.department.toLowerCase().contains(search) ||
              employee.email.toLowerCase().contains(search);

      final matchesDepartment =
          selectedDepartment == 'All Departments' ||
              employee.department == selectedDepartment;

      final matchesType =
          selectedEmploymentType == 'All Employment Types' ||
              employee.employmentType == selectedEmploymentType;

      final matchesStatus =
          selectedStatus == 'All Statuses' ||
              employee.status == selectedStatus;

      return matchesSearch &&
          matchesDepartment &&
          matchesType &&
          matchesStatus;
    }).toList();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final employees = snapshot.data!.docs.map((doc) {
              return Employee.fromFirestore(doc);
            }).toList();

            final filteredEmployees = filterEmployees(employees);

            return LayoutBuilder(
              builder: (context, constraints) {
                final bool compact = constraints.maxWidth < 900;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 18 : 24,
                    compact ? 18 : 0,
                    compact ? 18 : 24,
                    40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        compact,
                        employees.length,
                      ),

                      const SizedBox(height: 24),

                      _buildFilters(compact),

                      const SizedBox(height: 24),

                      _buildEmployeeContent(
                        filteredEmployees,
                        compact,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(bool compact, int employeeCount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 20 : 24,
        vertical: compact ? 24 : 28,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF171B43),
            Color(0xFF11162F),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303685),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF4C5BE7),
                        ),
                      ),
                      child: const Text(
                        'Workforce Directory',
                        style: TextStyle(
                          color: Color(0xFFB6C4FF),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Text(
                      '· $employeeCount record(s)',
                      style: const TextStyle(
                        color: Color(0xFFAEB8D2),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              if (!compact)
                Row(
                  children: [
                    _headerButton(
                      icon: Icons.download_outlined,
                      title: 'Export CSV',
                      filled: false,
                      onTap: _exportCsv,
                    ),

                    const SizedBox(width: 10),

                    _headerButton(
                      icon: Icons.person_add_alt_1_outlined,
                      title: 'Add Employee',
                      filled: true,
                      onTap: _addEmployee,
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Employee Directory',
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 26 : 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Search, filter, view complete personnel profiles, manage employees and onboard team members.',
            style: TextStyle(
              color: Color(0xFFC6CEE1),
              fontSize: 13,
              height: 1.5,
            ),
          ),

          if (compact) ...[
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _headerButton(
                    icon: Icons.download_outlined,
                    title: 'Export CSV',
                    filled: false,
                    onTap: _exportCsv,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _headerButton(
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Add Employee',
                    filled: true,
                    onTap: _addEmployee,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _headerButton({
    required IconData icon,
    required String title,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          filled ? const Color(0xFF5138F5) : const Color(0xFF252B48),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
            side: filled
                ? BorderSide.none
                : const BorderSide(
              color: Color(0xFF4A516B),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _buildFilters(bool compact) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE3EC),
        ),
      ),
      child: compact
          ? Column(
        children: [
          _buildSearchField(),

          const SizedBox(height: 12),

          _departmentDropdown(),

          const SizedBox(height: 12),

          _employmentDropdown(),

          const SizedBox(height: 12),

          _statusDropdown(),

          const SizedBox(height: 12),

          _buildViewToggle(),
        ],
      )
          : Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildSearchField(),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _departmentDropdown(),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _employmentDropdown(),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _statusDropdown(),
          ),

          const SizedBox(width: 12),

          _buildViewToggle(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search directory...',
          prefixIcon: const Icon(Icons.search),

          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,

          filled: true,
          fillColor: const Color(0xFFF8FAFC),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _departmentDropdown() {
    return _buildDropdown(
      value: selectedDepartment,
      items: const [
        'All Departments',
        'Executive & HR',
        'Engineering',
        'Engineering & Tech',
        'Product & Design',
        'Marketing & Sales',
        'Finance & Accounts',
        'HR',
      ],
      onChanged: (value) {
        setState(() {
          selectedDepartment = value;
        });
      },
    );
  }

  Widget _employmentDropdown() {
    return _buildDropdown(
      value: selectedEmploymentType,
      items: const [
        'All Employment Types',
        'Full-time',
        'Full Time',
        'FULL TIME',
        'Part-time',
        'PART TIME',
        'Contract',
        'CONTRACT',
      ],
      onChanged: (value) {
        setState(() {
          selectedEmploymentType = value;
        });
      },
    );
  }

  Widget _statusDropdown() {
    return _buildDropdown(
      value: selectedStatus,
      items: const [
        'All Statuses',
        'ACTIVE',
        'ON LEAVE',
        'INACTIVE',
      ],
      onChanged: (value) {
        setState(() {
          selectedStatus = value;
        });
      },
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFD9E2ED),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          _toggleButton(
            icon: Icons.format_list_bulleted,
            selected: isListView,
            onTap: () {
              setState(() {
                isListView = true;
              });
            },
          ),

          _toggleButton(
            icon: Icons.grid_view_outlined,
            selected: !isListView,
            onTap: () {
              setState(() {
                isListView = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: selected
              ? const Color(0xFF4F42E8)
              : const Color(0xFF71819B),
        ),
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildEmployeeContent(
      List<Employee> employees,
      bool compact,
      ) {
    if (employees.isEmpty) {
      return _buildEmptyState();
    }

    if (!isListView) {
      return _buildGridView(employees);
    }

    return _buildTable(employees, compact);
  }

  // ============================================================
  // TABLE
  // ============================================================

  Widget _buildTable(
      List<Employee> employees,
      bool compact,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE3EC),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: compact ? 1250 : 1210,
            child: Column(
              children: [
                _buildTableHeader(),

                ...employees.map(
                      (employee) => _buildEmployeeRow(employee),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 48,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          SizedBox(
            width: 260,
            child: _HeaderText('EMPLOYEE'),
          ),

          SizedBox(
            width: 112,
            child: _HeaderText('CODE'),
          ),

          SizedBox(
            width: 190,
            child: _HeaderText('DEPARTMENT & ROLE'),
          ),

          SizedBox(
            width: 235,
            child: _HeaderText('CONTACT'),
          ),

          SizedBox(
            width: 118,
            child: _HeaderText('TYPE'),
          ),

          SizedBox(
            width: 130,
            child: _HeaderText('STATUS'),
          ),

          Expanded(
            child: _HeaderText(
              'ACTIONS',
              align: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeRow(Employee employee) {
    return Container(
      height: 81,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFE8EDF3),
          ),
        ),
      ),
      child: Row(
        children: [
          // EMPLOYEE

          SizedBox(
            width: 260,
            child: Row(
              children: [
                _buildAvatar(employee),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        employee.designation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF7485A0),
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // CODE

          SizedBox(
            width: 112,
            child: Text(
              employee.employeeId,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // DEPARTMENT

          SizedBox(
            width: 190,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.department,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                _roleBadge(employee.role),
              ],
            ),
          ),

          // CONTACT

          SizedBox(
            width: 235,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.email,
                  style: const TextStyle(
                    fontSize: 10.5,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  employee.phone,
                  style: const TextStyle(
                    color: Color(0xFF8A9BB5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // TYPE

          SizedBox(
            width: 118,
            child: Text(
              employee.employmentType.toUpperCase(),
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // STATUS

          SizedBox(
            width: 130,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _statusBadge(employee.status),
            ),
          ),

          // ACTIONS

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton(
                  icon: Icons.visibility_outlined,
                  tooltip: 'View',
                  onTap: () => _viewEmployee(employee),
                ),

                const SizedBox(width: 10),

                _actionButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'Edit',
                  onTap: () => _editEmployee(employee),
                ),

                const SizedBox(width: 10),

                _actionButton(
                  icon: Icons.delete_outline,
                  tooltip: 'Delete',
                  onTap: () => _deleteEmployee(employee),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRID VIEW
  // ============================================================

  Widget _buildGridView(List<Employee> employees) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 430,
        mainAxisExtent: 230,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final employee = employees[index];

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFDCE3EC),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatar(employee, radius: 27),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          employee.designation,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF7586A0),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _statusBadge(employee.status),
                ],
              ),

              const SizedBox(height: 18),

              _gridInfoRow(
                Icons.badge_outlined,
                employee.employeeId,
              ),

              const SizedBox(height: 8),

              _gridInfoRow(
                Icons.business_outlined,
                employee.department,
              ),

              const SizedBox(height: 8),

              _gridInfoRow(
                Icons.email_outlined,
                employee.email,
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _actionButton(
                    icon: Icons.visibility_outlined,
                    tooltip: 'View',
                    onTap: () => _viewEmployee(employee),
                  ),

                  const SizedBox(width: 10),

                  _actionButton(
                    icon: Icons.edit_outlined,
                    tooltip: 'Edit',
                    onTap: () => _editEmployee(employee),
                  ),

                  const SizedBox(width: 10),

                  _actionButton(
                    icon: Icons.delete_outline,
                    tooltip: 'Delete',
                    onTap: () => _deleteEmployee(employee),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _gridInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF7185A3),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar(
      Employee employee, {
        double radius = 21,
      }) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: employee.avatarColor,
      ),
      alignment: Alignment.center,
      child: Text(
        employee.initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.48,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ============================================================
  // BADGES
  // ============================================================

  Widget _roleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2FF),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF4D45F3),
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final bool active = status.toUpperCase() == 'ACTIVE';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFD5F8E9)
            : const Color(0xFFFFF0C8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: active
              ? const Color(0xFF009B67)
              : const Color(0xFFBD7900),
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFF667C9B),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 50,
            color: Color(0xFFA0AEC0),
          ),

          SizedBox(height: 15),

          Text(
            'No employees found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Try changing your search or filter options.',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  void _exportCsv() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV export feature can be added next.'),
      ),
    );
  }

  // ADD EMPLOYEE

  void _addEmployee() {
    showDialog(
      context: context,
      builder: (context) {
        return _EmployeeDialog(
          onSave: (data) async {
            await _firestore.collection('users').add(data);

            if (mounted) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Employee added successfully'),
                ),
              );
            }
          },
        );
      },
    );
  }

  // VIEW EMPLOYEE

  void _viewEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(employee.name),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Designation: ${employee.designation}'),
                const SizedBox(height: 8),

                Text('Employee ID: ${employee.employeeId}'),
                const SizedBox(height: 8),

                Text('Department: ${employee.department}'),
                const SizedBox(height: 8),

                Text('Role: ${employee.role}'),
                const SizedBox(height: 8),

                Text('Email: ${employee.email}'),
                const SizedBox(height: 8),

                Text('Phone: ${employee.phone}'),
                const SizedBox(height: 8),

                Text('Employment Type: ${employee.employmentType}'),
                const SizedBox(height: 8),

                Text('Status: ${employee.status}'),
                const SizedBox(height: 8),

                Text('Address: ${employee.address}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // EDIT EMPLOYEE

  void _editEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) {
        return _EmployeeDialog(
          employee: employee,
          onSave: (data) async {
            await _firestore
                .collection('users')
                .doc(employee.documentId)
                .update(data);

            if (mounted) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Employee updated successfully'),
                ),
              );
            }
          },
        );
      },
    );
  }

  // DELETE EMPLOYEE

  void _deleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Employee'),
          content: Text(
            'Are you sure you want to delete ${employee.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await _firestore
                    .collection('users')
                    .doc(employee.documentId)
                    .delete();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Employee deleted successfully'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// HEADER TEXT
// ============================================================

class _HeaderText extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _HeaderText(
      this.text, {
        this.align = TextAlign.left,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        color: Color(0xFF647693),
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ============================================================
// EMPLOYEE MODEL
// ============================================================

class Employee {
  final String documentId;

  final String name;
  final String designation;
  final String employeeId;
  final String department;
  final String role;
  final String email;
  final String phone;
  final String employmentType;
  final String status;
  final String address;
  final String avatar;

  Employee({
    required this.documentId,
    required this.name,
    required this.designation,
    required this.employeeId,
    required this.department,
    required this.role,
    required this.email,
    required this.phone,
    required this.employmentType,
    required this.status,
    required this.address,
    required this.avatar,
  });

  // ============================================================
  // FIRESTORE DATA
  // ============================================================

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return Employee(
      documentId: doc.id,

      name: data['name']?.toString() ?? 'Unknown',

      designation:
      data['designation']?.toString() ??
          data['position']?.toString() ??
          'Employee',

      employeeId:
      data['employeeId']?.toString() ??
          data['code']?.toString() ??
          doc.id,

      department: data['department']?.toString() ?? 'Not Assigned',

      role: data['role']?.toString() ?? 'EMPLOYEE',

      email: data['email']?.toString() ?? '',

      phone: data['phone']?.toString() ?? '',

      employmentType:
      data['employmentType']?.toString() ??
          'Full-time',

      status:
      data['status']?.toString() ??
          'ACTIVE',

      address: data['address']?.toString() ?? '',

      avatar: data['avatar']?.toString() ?? '',
    );
  }

  String get initials {
    if (name.trim().isEmpty) return 'U';

    final parts = name.trim().split(' ');

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Color get avatarColor {
    final colors = [
      const Color(0xFF556DDC),
      const Color(0xFF3D91B5),
      const Color(0xFFE7A36C),
      const Color(0xFF657788),
      const Color(0xFF9B6540),
      const Color(0xFF7B61FF),
    ];

    return colors[name.hashCode.abs() % colors.length];
  }
}

// ============================================================
// ADD / EDIT EMPLOYEE DIALOG
// ============================================================

class _EmployeeDialog extends StatefulWidget {
  final Employee? employee;

  final Future<void> Function(Map<String, dynamic> data) onSave;

  const _EmployeeDialog({
    this.employee,
    required this.onSave,
  });

  @override
  State<_EmployeeDialog> createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends State<_EmployeeDialog> {
  late TextEditingController nameController;
  late TextEditingController designationController;
  late TextEditingController employeeIdController;
  late TextEditingController departmentController;
  late TextEditingController roleController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController employmentTypeController;
  late TextEditingController statusController;
  late TextEditingController addressController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    final employee = widget.employee;

    nameController = TextEditingController(
      text: employee?.name ?? '',
    );

    designationController = TextEditingController(
      text: employee?.designation ?? '',
    );

    employeeIdController = TextEditingController(
      text: employee?.employeeId ?? '',
    );

    departmentController = TextEditingController(
      text: employee?.department ?? '',
    );

    roleController = TextEditingController(
      text: employee?.role ?? 'EMPLOYEE',
    );

    emailController = TextEditingController(
      text: employee?.email ?? '',
    );

    phoneController = TextEditingController(
      text: employee?.phone ?? '',
    );

    employmentTypeController = TextEditingController(
      text: employee?.employmentType ?? 'Full-time',
    );

    statusController = TextEditingController(
      text: employee?.status ?? 'ACTIVE',
    );

    addressController = TextEditingController(
      text: employee?.address ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    employeeIdController.dispose();
    departmentController.dispose();
    roleController.dispose();
    emailController.dispose();
    phoneController.dispose();
    employmentTypeController.dispose();
    statusController.dispose();
    addressController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    final data = {
      'name': nameController.text.trim(),
      'designation': designationController.text.trim(),
      'employeeId': employeeIdController.text.trim(),
      'department': departmentController.text.trim(),
      'role': roleController.text.trim().toUpperCase(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'employmentType': employmentTypeController.text.trim(),
      'status': statusController.text.trim().toUpperCase(),
      'address': addressController.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (widget.employee == null) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    try {
      await widget.onSave(data);
    } catch (e) {
      setState(() {
        loading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.employee != null;

    return AlertDialog(
      title: Text(
        isEditing ? 'Edit Employee' : 'Add Employee',
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _field(
                nameController,
                'Employee Name',
              ),

              const SizedBox(height: 12),

              _field(
                designationController,
                'Designation',
              ),

              const SizedBox(height: 12),

              _field(
                employeeIdController,
                'Employee ID',
              ),

              const SizedBox(height: 12),

              _field(
                departmentController,
                'Department',
              ),

              const SizedBox(height: 12),

              _field(
                roleController,
                'Role (ADMIN / MANAGER / EMPLOYEE)',
              ),

              const SizedBox(height: 12),

              _field(
                emailController,
                'Email',
              ),

              const SizedBox(height: 12),

              _field(
                phoneController,
                'Phone',
              ),

              const SizedBox(height: 12),

              _field(
                employmentTypeController,
                'Employment Type',
              ),

              const SizedBox(height: 12),

              _field(
                statusController,
                'Status',
              ),

              const SizedBox(height: 12),

              _field(
                addressController,
                'Address',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading
              ? null
              : () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: loading ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5138F5),
            foregroundColor: Colors.white,
          ),
          child: loading
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(
            isEditing ? 'Update Employee' : 'Add Employee',
          ),
        ),
      ],
    );
  }

  Widget _field(
      TextEditingController controller,
      String label,
      ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
  }
}
