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

  final List<Employee> employees = [
    Employee(
      name: 'Sarah Jenkins',
      designation: 'VP of Human Resources',
      code: 'EMP-1001',
      department: 'Executive & HR',
      role: 'ADMIN',
      email: 'sarah.jenkins@nexus.com',
      phone: '+1 (555) 234-5678',
      employmentType: 'FULL TIME',
      status: 'ACTIVE',
      initials: 'SJ',
      avatarColor: Color(0xFFE7A36C),
    ),
    Employee(
      name: 'David Vance',
      designation: 'Engineering Director',
      code: 'EMP-1002',
      department: 'Engineering & Tech',
      role: 'MANAGER',
      email: 'david.vance@nexus.com',
      phone: '+1 (555) 345-6789',
      employmentType: 'FULL TIME',
      status: 'ACTIVE',
      initials: 'DV',
      avatarColor: Color(0xFFB8C7D9),
    ),
    Employee(
      name: 'Alex Rivera',
      designation: 'Senior Frontend Engineer',
      code: 'EMP-1003',
      department: 'Engineering & Tech',
      role: 'EMPLOYEE',
      email: 'alex.rivera@nexus.com',
      phone: '+1 (555) 456-7890',
      employmentType: 'FULL TIME',
      status: 'ACTIVE',
      initials: 'AR',
      avatarColor: Color(0xFF556DDC),
    ),
    Employee(
      name: 'Emily Chen',
      designation: 'Lead Product Designer',
      code: 'EMP-1004',
      department: 'Product & Design',
      role: 'EMPLOYEE',
      email: 'emily.chen@nexus.com',
      phone: '+1 (555) 567-8901',
      employmentType: 'FULL TIME',
      status: 'ACTIVE',
      initials: 'EC',
      avatarColor: Color(0xFFF2D8D0),
    ),
    Employee(
      name: 'Marcus Sterling',
      designation: 'Head of Growth Marketing',
      code: 'EMP-1005',
      department: 'Marketing & Sales',
      role: 'MANAGER',
      email: 'marcus.sterling@nexus.com',
      phone: '+1 (555) 678-9012',
      employmentType: 'FULL TIME',
      status: 'ACTIVE',
      initials: 'MS',
      avatarColor: Color(0xFF9B6540),
    ),
    Employee(
      name: 'Priya Patel',
      designation: 'Senior Finance Lead',
      code: 'EMP-1006',
      department: 'Finance & Accounts',
      role: 'HR',
      email: 'priya.patel@nexus.com',
      phone: '+1 (555) 789-0123',
      employmentType: 'FULL TIME',
      status: 'ACTIVE',
      initials: 'PP',
      avatarColor: Color(0xFF1D2730),
    ),
    Employee(
      name: "Liam O'Connor",
      designation: 'Backend Cloud Architect',
      code: 'EMP-1007',
      department: 'Engineering & Tech',
      role: 'EMPLOYEE',
      email: 'liam.oconnor@nexus.com',
      phone: '+1 (555) 890-1234',
      employmentType: 'FULL TIME',
      status: 'ACTIVE',
      initials: 'LO',
      avatarColor: Color(0xFF657788),
    ),
    Employee(
      name: 'Sophia Kim',
      designation: 'Content & PR Specialist',
      code: 'EMP-1008',
      department: 'Marketing & Sales',
      role: 'EMPLOYEE',
      email: 'sophia.kim@nexus.com',
      phone: '+1 (555) 901-2345',
      employmentType: 'FULL TIME',
      status: 'ON LEAVE',
      initials: 'SK',
      avatarColor: Color(0xFF3D91B5),
    ),
  ];

  List<Employee> get filteredEmployees {
    final search = _searchController.text.toLowerCase().trim();

    return employees.where((employee) {
      final matchesSearch =
          search.isEmpty ||
              employee.name.toLowerCase().contains(search) ||
              employee.code.toLowerCase().contains(search) ||
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: LayoutBuilder(
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
                  _buildHeader(compact),
                  const SizedBox(height: 24),
                  _buildFilters(compact),
                  const SizedBox(height: 24),
                  _buildEmployeeContent(compact),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader(bool compact) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    const Text(
                      '· 8 record(s)',
                      style: TextStyle(
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
              letterSpacing: -0.6,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Search, filter, view complete personnel profiles, manage compensation, and onboard team members.',
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
        icon: Icon(
          icon,
          size: 18,
          color: filled ? Colors.white : const Color(0xFFDDE3F2),
        ),
        label: Text(
          title,
          style: TextStyle(
            color: filled ? Colors.white : const Color(0xFFDDE3F2),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
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

  // ------------------------------------------------------------
  // FILTERS
  // ------------------------------------------------------------

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: compact
          ? Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 12),
          _buildDropdown(
            value: selectedDepartment,
            items: const [
              'All Departments',
              'Executive & HR',
              'Engineering & Tech',
              'Product & Design',
              'Marketing & Sales',
              'Finance & Accounts',
            ],
            onChanged: (value) {
              setState(() {
                selectedDepartment = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            value: selectedEmploymentType,
            items: const [
              'All Employment Types',
              'FULL TIME',
              'PART TIME',
              'CONTRACT',
            ],
            onChanged: (value) {
              setState(() {
                selectedEmploymentType = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown(
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
          ),
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
            child: _buildDropdown(
              value: selectedDepartment,
              items: const [
                'All Departments',
                'Executive & HR',
                'Engineering & Tech',
                'Product & Design',
                'Marketing & Sales',
                'Finance & Accounts',
              ],
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDropdown(
              value: selectedEmploymentType,
              items: const [
                'All Employment Types',
                'FULL TIME',
                'PART TIME',
                'CONTRACT',
              ],
              onChanged: (value) {
                setState(() {
                  selectedEmploymentType = value;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDropdown(
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
            ),
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
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF17213A),
        ),
        decoration: InputDecoration(
          hintText: 'Search directory...',
          hintStyle: const TextStyle(
            color: Color(0xFF8EA0BD),
            fontSize: 12,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: Color(0xFF8EA0BD),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
            },
            icon: const Icon(
              Icons.close,
              size: 17,
            ),
          )
              : null,
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFD9E2ED),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFD9E2ED),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF5942F5),
            ),
          ),
        ),
      ),
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
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Color(0xFF52637E),
          ),
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF253653),
            fontWeight: FontWeight.w500,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
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
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
            ),
          ]
              : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected
              ? const Color(0xFF4F42E8)
              : const Color(0xFF71819B),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPLOYEE CONTENT
  // ------------------------------------------------------------

  Widget _buildEmployeeContent(bool compact) {
    final data = filteredEmployees;

    if (data.isEmpty) {
      return _buildEmptyState();
    }

    if (!isListView) {
      return _buildGridView(data);
    }

    return _buildTable(data, compact);
  }

  // ------------------------------------------------------------
  // TABLE
  // ------------------------------------------------------------

  Widget _buildTable(List<Employee> data, bool compact) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE3EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
                ...data.map(
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
                          color: Color(0xFF13203A),
                          fontSize: 13,
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

          SizedBox(
            width: 112,
            child: Text(
              employee.code,
              style: const TextStyle(
                color: Color(0xFF28436B),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(
            width: 190,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.department,
                  style: const TextStyle(
                    color: Color(0xFF1C2A44),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                _roleBadge(employee.role),
              ],
            ),
          ),

          SizedBox(
            width: 235,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.email,
                  style: const TextStyle(
                    color: Color(0xFF2C4D76),
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

          SizedBox(
            width: 118,
            child: Text(
              employee.employmentType,
              style: const TextStyle(
                color: Color(0xFF17233A),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(
            width: 130,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _statusBadge(employee.status),
            ),
          ),

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

  // ------------------------------------------------------------
  // GRID VIEW
  // ------------------------------------------------------------

  Widget _buildGridView(List<Employee> data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 430,
        mainAxisExtent: 230,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final employee = data[index];

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFDCE3EC),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatar(
                    employee,
                    radius: 27,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF13203A),
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
                employee.code,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF405675),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // AVATAR
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // BADGES
  // ------------------------------------------------------------

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
        role,
        style: const TextStyle(
          color: Color(0xFF4D45F3),
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final bool active = status == 'ACTIVE';

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
        status,
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
        borderRadius: BorderRadius.circular(6),
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

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE3EC),
        ),
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
              color: Color(0xFF26344D),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try changing your search or filter options.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF8291A8),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ACTIONS
  // ------------------------------------------------------------

  void _exportCsv() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee CSV export started.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addEmployee() {
    showDialog(
      context: context,
      builder: (context) {
        return const _AddEmployeeDialog();
      },
    );
  }

  void _viewEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(employee.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employee.designation),
              const SizedBox(height: 12),
              Text('Employee Code: ${employee.code}'),
              Text('Department: ${employee.department}'),
              Text('Role: ${employee.role}'),
              Text('Email: ${employee.email}'),
              Text('Phone: ${employee.phone}'),
              Text('Status: ${employee.status}'),
            ],
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

  void _editEmployee(Employee employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${employee.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Employee'),
          content: Text(
            'Are you sure you want to delete ${employee.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  employees.remove(employee);
                });

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Employee deleted successfully.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
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
  final String name;
  final String designation;
  final String code;
  final String department;
  final String role;
  final String email;
  final String phone;
  final String employmentType;
  final String status;
  final String initials;
  final Color avatarColor;

  Employee({
    required this.name,
    required this.designation,
    required this.code,
    required this.department,
    required this.role,
    required this.email,
    required this.phone,
    required this.employmentType,
    required this.status,
    required this.initials,
    required this.avatarColor,
  });
}

// ============================================================
// ADD EMPLOYEE DIALOG
// ============================================================

class _AddEmployeeDialog extends StatefulWidget {
  const _AddEmployeeDialog();

  @override
  State<_AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<_AddEmployeeDialog> {
  final nameController = TextEditingController();
  final designationController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Employee',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SizedBox(
        width: 430,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(
                controller: nameController,
                label: 'Employee Name',
              ),
              const SizedBox(height: 12),
              _field(
                controller: designationController,
                label: 'Designation',
              ),
              const SizedBox(height: 12),
              _field(
                controller: emailController,
                label: 'Email',
              ),
              const SizedBox(height: 12),
              _field(
                controller: phoneController,
                label: 'Phone',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Employee added successfully.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5138F5),
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Employee'),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
  }) {
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