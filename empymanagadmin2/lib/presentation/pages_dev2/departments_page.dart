import 'package:flutter/material.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 245, 247, 251),
      child: const _DepartmentsContent(),
    );
  }
}

// ============================================================
// MAIN CONTENT
// ============================================================

class _DepartmentsContent extends StatelessWidget {
  const _DepartmentsContent();

  static const List<Department> departments = [
    Department(
      shortName: 'HR',
      name: 'Executive & HR',
      description:
      'Human Resources, Talent Acquisition, People Operations and Executive Leadership.',
      floor: 'Headquarters - Floor 4',
      staff: 1,
      lead: 'Sarah Jenkins',
      avatarLetter: 'SJ',
    ),
    Department(
      shortName: 'ENG',
      name: 'Engineering & Tech',
      description:
      'Software development, cloud infrastructure, QA, and IT operations.',
      floor: 'Headquarters - Floor 3',
      staff: 3,
      lead: 'David Vance',
      avatarLetter: 'DV',
    ),
    Department(
      shortName: 'DES',
      name: 'Product & Design',
      description:
      'User experience design, product strategy, and visual brand identity.',
      floor: 'Headquarters - Floor 3',
      staff: 1,
      lead: 'Emily Chen',
      avatarLetter: 'EC',
    ),
    Department(
      shortName: 'MKT',
      name: 'Marketing & Sales',
      description:
      'Growth marketing, customer acquisition, content creation, and sales strategy.',
      floor: 'Headquarters - Floor 2',
      staff: 2,
      lead: 'Marcus Sterling',
      avatarLetter: 'MS',
    ),
    Department(
      shortName: 'FIN',
      name: 'Finance & Accounts',
      description:
      'Financial planning, payroll management, auditing, and corporate accounting.',
      floor: 'Headquarters - Floor 4',
      staff: 1,
      lead: 'Priya Patel',
      avatarLetter: 'PP',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmall = constraints.maxWidth < 900;
        final bool isTablet = constraints.maxWidth < 1250;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 18 : 40,
              vertical: isSmall ? 20 : 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(
                  compact: isSmall,
                ),

                const SizedBox(height: 26),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: departments.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isSmall
                        ? 1
                        : isTablet
                        ? 2
                        : 3,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: isSmall
                        ? 2.1
                        : isTablet
                        ? 1.65
                        : 1.50,
                  ),
                  itemBuilder: (context, index) {
                    return DepartmentCard(
                      department: departments[index],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _Header extends StatelessWidget {
  final bool compact;

  const _Header({
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 22 : 27,
        vertical: compact ? 20 : 25,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 17, 24, 52),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: compact
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerText(),
          const SizedBox(height: 18),
          _addButton(),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: _headerText(),
          ),
          const SizedBox(width: 20),
          _addButton(),
        ],
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
                horizontal: 13,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.indigoAccent.withOpacity(0.45),
                ),
              ),
              child: const Text(
                'Organizational Structure',
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '· 5 Active Departments',
              style: TextStyle(
                color: Colors.blueGrey.shade300,
                fontSize: 15,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        const Text(
          'Departments & Divisions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'Structure divisions, assign department heads, and monitor workforce density across floors.',
          style: TextStyle(
            color: Colors.blueGrey.shade200,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _addButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),
      label: const Text(
        'Add Department',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 0,
      ),
    );
  }
}

// ============================================================
// DEPARTMENT CARD
// ============================================================

class DepartmentCard extends StatelessWidget {
  final Department department;

  const DepartmentCard({
    super.key,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.blueGrey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  department.shortName,
                  style: const TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: () {},
                tooltip: 'Edit',
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Colors.blueGrey.shade400,
                ),
              ),

              IconButton(
                onPressed: () {},
                tooltip: 'Delete',
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.blueGrey.shade400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Department name
          Text(
            department.name,
            style: const TextStyle(
              color: Color.fromARGB(255, 9, 24, 49),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          // Description
          Text(
            department.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 17),

          Divider(
            color: Colors.blueGrey.shade100,
            height: 1,
          ),

          const SizedBox(height: 12),

          // Floor and staff
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.blueGrey.shade400,
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  department.floor,
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${department.staff} Staff',
                  style: const TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Department lead
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.04),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _avatarColor(
                    department.shortName,
                  ),
                  child: Text(
                    department.avatarLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department Lead',
                      style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      department.lead,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 12, 28, 53),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _avatarColor(String name) {
    switch (name) {
      case 'HR':
        return Colors.deepOrange;

      case 'ENG':
        return Colors.blueGrey;

      case 'DES':
        return Colors.pinkAccent;

      case 'MKT':
        return Colors.orange;

      case 'FIN':
        return Colors.teal;

      default:
        return Colors.indigo;
    }
  }
}

// ============================================================
// MODEL
// ============================================================

class Department {
  final String shortName;
  final String name;
  final String description;
  final String floor;
  final int staff;
  final String lead;
  final String avatarLetter;

  const Department({
    required this.shortName,
    required this.name,
    required this.description,
    required this.floor,
    required this.staff,
    required this.lead,
    required this.avatarLetter,
  });
}