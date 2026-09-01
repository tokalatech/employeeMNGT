import 'package:flutter/material.dart';

class DepartmentsPage extends StatefulWidget {
  const DepartmentsPage({super.key});

  @override
  State<DepartmentsPage> createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  // ============================================================
  // DEPARTMENTS DATA
  // ============================================================

  List<Department> departments = [
    const Department(
      shortName: 'HR',
      name: 'Executive & HR',
      description:
      'Human Resources, Talent Acquisition, People Operations and Executive Leadership.',
      floor: 'Headquarters - Floor 4',
      staff: 1,
      lead: 'Sarah Jenkins',
      avatarLetter: 'SJ',
    ),
    const Department(
      shortName: 'ENG',
      name: 'Engineering & Tech',
      description:
      'Software development, cloud infrastructure, QA, and IT operations.',
      floor: 'Headquarters - Floor 3',
      staff: 3,
      lead: 'David Vance',
      avatarLetter: 'DV',
    ),
    const Department(
      shortName: 'DES',
      name: 'Product & Design',
      description:
      'User experience design, product strategy, and visual brand identity.',
      floor: 'Headquarters - Floor 3',
      staff: 1,
      lead: 'Emily Chen',
      avatarLetter: 'EC',
    ),
    const Department(
      shortName: 'MKT',
      name: 'Marketing & Sales',
      description:
      'Growth marketing, customer acquisition, content creation, and sales strategy.',
      floor: 'Headquarters - Floor 2',
      staff: 2,
      lead: 'Marcus Sterling',
      avatarLetter: 'MS',
    ),
    const Department(
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

  // ============================================================
  // ADD DEPARTMENT
  // ============================================================

  void _addDepartment() {
    _showDepartmentDialog();
  }

  // ============================================================
  // EDIT DEPARTMENT
  // ============================================================

  void _editDepartment(int index) {
    _showDepartmentDialog(
      department: departments[index],
      index: index,
    );
  }

  // ============================================================
  // DELETE DEPARTMENT
  // ============================================================

  Future<void> _deleteDepartment(int index) async {
    final Department department = departments[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Department',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),

          content: Text(
            'Are you sure you want to delete "${department.name}"?',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        departments.removeAt(index);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${department.name} deleted successfully',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ============================================================
  // ADD / EDIT DIALOG
  // ============================================================

  void _showDepartmentDialog({
    Department? department,
    int? index,
  }) {
    final bool isEditing = department != null;

    final TextEditingController shortNameController =
    TextEditingController(
      text: department?.shortName ?? '',
    );

    final TextEditingController nameController =
    TextEditingController(
      text: department?.name ?? '',
    );

    final TextEditingController descriptionController =
    TextEditingController(
      text: department?.description ?? '',
    );

    final TextEditingController floorController =
    TextEditingController(
      text: department?.floor ?? '',
    );

    final TextEditingController staffController =
    TextEditingController(
      text: department?.staff.toString() ?? '',
    );

    final TextEditingController leadController =
    TextEditingController(
      text: department?.lead ?? '',
    );

    final TextEditingController avatarController =
    TextEditingController(
      text: department?.avatarLetter ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isEditing
                ? 'Edit Department'
                : 'Add Department',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),

          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ==================================================
                  // SHORT NAME
                  // ==================================================

                  TextField(
                    controller: shortNameController,
                    textCapitalization:
                    TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Short Name',
                      hintText: 'Example: HR',
                      prefixIcon:
                      Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // DEPARTMENT NAME
                  // ==================================================

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Department Name',
                      hintText:
                      'Example: Executive & HR',
                      prefixIcon:
                      Icon(Icons.business_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================

                  TextField(
                    controller:
                    descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText:
                      'Enter department description',
                      prefixIcon:
                      Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // FLOOR
                  // ==================================================

                  TextField(
                    controller: floorController,
                    decoration: const InputDecoration(
                      labelText: 'Floor / Location',
                      hintText:
                      'Example: Headquarters - Floor 4',
                      prefixIcon:
                      Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // STAFF
                  // ==================================================

                  TextField(
                    controller: staffController,
                    keyboardType:
                    TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Number of Staff',
                      hintText: 'Example: 5',
                      prefixIcon:
                      Icon(Icons.people_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // DEPARTMENT LEAD
                  // ==================================================

                  TextField(
                    controller: leadController,
                    decoration: const InputDecoration(
                      labelText: 'Department Lead',
                      hintText:
                      'Example: Sarah Jenkins',
                      prefixIcon:
                      Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // AVATAR INITIALS
                  // ==================================================

                  TextField(
                    controller: avatarController,
                    textCapitalization:
                    TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Lead Initials',
                      hintText: 'Example: SJ',
                      prefixIcon:
                      Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          actions: [
            // ========================================================
            // CANCEL
            // ========================================================

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
              ),
            ),

            // ========================================================
            // ADD / SAVE
            // ========================================================

            ElevatedButton(
              onPressed: () {
                final String shortName =
                shortNameController.text.trim();

                final String name =
                nameController.text.trim();

                final String description =
                descriptionController.text.trim();

                final String floor =
                floorController.text.trim();

                final String lead =
                leadController.text.trim();

                final String avatar =
                avatarController.text.trim();

                final int staff =
                    int.tryParse(
                      staffController.text
                          .trim(),
                    ) ??
                        0;

                // ==================================================
                // VALIDATION
                // ==================================================

                if (shortName.isEmpty ||
                    name.isEmpty ||
                    description.isEmpty ||
                    floor.isEmpty ||
                    lead.isEmpty) {
                  ScaffoldMessenger.of(
                    dialogContext,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all required fields',
                      ),
                    ),
                  );

                  return;
                }

                // ==================================================
                // CREATE DEPARTMENT OBJECT
                // ==================================================

                final Department newDepartment =
                Department(
                  shortName:
                  shortName.toUpperCase(),
                  name: name,
                  description: description,
                  floor: floor,
                  staff: staff,
                  lead: lead,
                  avatarLetter: avatar.isEmpty
                      ? _generateInitials(lead)
                      : avatar.toUpperCase(),
                );

                // ==================================================
                // EDIT EXISTING
                // ==================================================

                if (isEditing &&
                    index != null) {
                  setState(() {
                    departments[index] =
                        newDepartment;
                  });

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Department updated successfully',
                      ),
                      behavior:
                      SnackBarBehavior.floating,
                    ),
                  );
                }

                // ==================================================
                // ADD NEW
                // ==================================================

                else {
                  setState(() {
                    departments.add(
                      newDepartment,
                    );
                  });

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Department added successfully',
                      ),
                      behavior:
                      SnackBarBehavior.floating,
                    ),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor:
                Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),

              child: Text(
                isEditing
                    ? 'Save Changes'
                    : 'Add Department',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // GENERATE INITIALS
  // ============================================================

  String _generateInitials(String name) {
    final List<String> parts =
    name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty) {
      return '';
    }

    if (parts.length == 1) {
      return parts.first
          .substring(
        0,
        parts.first.length >= 2
            ? 2
            : 1,
      )
          .toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(
        255,
        245,
        247,
        251,
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width =
              constraints.maxWidth;

          final bool isMobile = width < 700;

          final bool isTablet =
              width >= 700 && width < 1200;

          int crossAxisCount;

          if (isMobile) {
            crossAxisCount = 1;
          } else if (isTablet) {
            crossAxisCount = 2;
          } else {
            crossAxisCount = 3;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                isMobile ? 16 : 40,
                vertical:
                isMobile ? 18 : 14,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================

                  _Header(
                    compact: isMobile,
                    onAddDepartment:
                    _addDepartment,
                    departmentCount:
                    departments.length,
                  ),

                  const SizedBox(height: 26),

                  // ==================================================
                  // DEPARTMENT GRID
                  // ==================================================

                  if (departments.isEmpty)
                    _buildEmptyState()
                  else
                    GridView.builder(
                      shrinkWrap: true,

                      physics:
                      const NeverScrollableScrollPhysics(),

                      itemCount:
                      departments.length,

                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                        crossAxisCount,

                        crossAxisSpacing: 18,

                        mainAxisSpacing: 18,

                        // Fixed height prevents
                        // bottom overflow.
                        mainAxisExtent:
                        isMobile
                            ? 330
                            : 335,
                      ),

                      itemBuilder:
                          (context, index) {
                        return DepartmentCard(
                          department:
                          departments[index],

                          onEdit: () {
                            _editDepartment(
                              index,
                            );
                          },

                          onDelete: () {
                            _deleteDepartment(
                              index,
                            );
                          },
                        );
                      },
                    ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        vertical: 70,
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(17),

        border: Border.all(
          color: Colors.blueGrey.shade100,
        ),
      ),

      child: Column(
        children: [
          Icon(
            Icons.business_outlined,
            size: 55,
            color: Colors.blueGrey.shade300,
          ),

          const SizedBox(height: 15),

          const Text(
            'No Departments Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color.fromARGB(
                255,
                12,
                28,
                53,
              ),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Click "Add Department" to create your first department.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _Header extends StatelessWidget {
  final bool compact;
  final VoidCallback onAddDepartment;
  final int departmentCount;

  const _Header({
    required this.compact,
    required this.onAddDepartment,
    required this.departmentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal:
        compact ? 20 : 27,
        vertical:
        compact ? 20 : 25,
      ),

      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          17,
          24,
          52,
        ),

        borderRadius:
        BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.12,
            ),
            blurRadius: 20,
            offset:
            const Offset(0, 10),
          ),
        ],
      ),

      child: compact
          ? Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _headerText(),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: _addButton(),
          ),
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

  // ============================================================
  // HEADER TEXT
  // ============================================================

  Widget _headerText() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Wrap(
          crossAxisAlignment:
          WrapCrossAlignment.center,

          spacing: 10,

          runSpacing: 8,

          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: Colors.indigo
                    .withOpacity(0.20),

                borderRadius:
                BorderRadius.circular(
                  20,
                ),

                border: Border.all(
                  color: Colors
                      .indigoAccent
                      .withOpacity(
                    0.45,
                  ),
                ),
              ),

              child: const Text(
                'Organizational Structure',

                style: TextStyle(
                  color:
                  Colors.indigoAccent,
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),

            Text(
              '· $departmentCount Active Departments',

              style: TextStyle(
                color:
                Colors.blueGrey.shade300,
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
            fontWeight:
            FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'Structure divisions, assign department heads, and monitor workforce density across floors.',

          style: TextStyle(
            color:
            Colors.blueGrey.shade200,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ADD BUTTON
  // ============================================================

  Widget _addButton() {
    return ElevatedButton.icon(
      onPressed: onAddDepartment,

      icon: const Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),

      label: const Text(
        'Add Department',

        style: TextStyle(
          color: Colors.white,
          fontWeight:
          FontWeight.bold,
        ),
      ),

      style: ElevatedButton.styleFrom(
        backgroundColor:
        Colors.deepPurpleAccent,

        foregroundColor:
        Colors.white,

        padding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
            13,
          ),
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
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DepartmentCard({
    super.key,
    required this.department,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(17),

        border: Border.all(
          color:
          Colors.blueGrey.shade100,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.06,
            ),
            blurRadius: 10,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ======================================================
          // TOP ROW
          // ======================================================

          Row(
            children: [
              Container(
                width: 45,
                height: 45,

                alignment:
                Alignment.center,

                decoration:
                BoxDecoration(
                  color: Colors.indigo
                      .withOpacity(0.08),

                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),

                child: Text(
                  department.shortName,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  const TextStyle(
                    color:
                    Colors.indigoAccent,
                    fontSize: 17,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),

              const Spacer(),

              // =================================================
              // EDIT
              // =================================================

              SizedBox(
                width: 36,
                height: 36,

                child: IconButton(
                  padding:
                  EdgeInsets.zero,

                  constraints:
                  const BoxConstraints(),

                  onPressed: onEdit,

                  tooltip: 'Edit',

                  icon: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color:
                    Colors.blueGrey
                        .shade400,
                  ),
                ),
              ),

              const SizedBox(width: 5),

              // =================================================
              // DELETE
              // =================================================

              SizedBox(
                width: 36,
                height: 36,

                child: IconButton(
                  padding:
                  EdgeInsets.zero,

                  constraints:
                  const BoxConstraints(),

                  onPressed: onDelete,

                  tooltip: 'Delete',

                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color:
                    Colors.blueGrey
                        .shade400,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ======================================================
          // NAME
          // ======================================================

          Text(
            department.name,

            maxLines: 1,

            overflow:
            TextOverflow.ellipsis,

            style:
            const TextStyle(
              color: Color.fromARGB(
                255,
                9,
                24,
                49,
              ),
              fontSize: 17,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          // ======================================================
          // DESCRIPTION
          // ======================================================

          SizedBox(
            height: 38,

            child: Text(
              department.description,

              maxLines: 2,

              overflow:
              TextOverflow.ellipsis,

              style: TextStyle(
                color:
                Colors.blueGrey.shade500,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ======================================================
          // DIVIDER
          // ======================================================

          Divider(
            color:
            Colors.blueGrey.shade100,
            height: 1,
          ),

          const SizedBox(height: 11),

          // ======================================================
          // FLOOR + STAFF
          // ======================================================

          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color:
                Colors.blueGrey.shade400,
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  department.floor,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: TextStyle(
                    color:
                    Colors.blueGrey
                        .shade600,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration:
                BoxDecoration(
                  color: Colors.indigo
                      .withOpacity(0.08),

                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),

                child: Text(
                  '${department.staff} Staff',

                  style:
                  const TextStyle(
                    color:
                    Colors.indigoAccent,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // ======================================================
          // DEPARTMENT LEAD
          // ======================================================

          Container(
            width: double.infinity,

            height: 58,

            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),

            decoration:
            BoxDecoration(
              color: Colors.blueGrey
                  .withOpacity(0.04),

              borderRadius:
              BorderRadius.circular(
                11,
              ),
            ),

            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,

                  backgroundColor:
                  _avatarColor(
                    department.shortName,
                  ),

                  child: Text(
                    department.avatarLetter,

                    maxLines: 1,

                    style:
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Department Lead',

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style: TextStyle(
                          color: Colors
                              .blueGrey
                              .shade400,
                          fontSize: 10,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        department.lead,

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style:
                        const TextStyle(
                          color: Color.fromARGB(
                            255,
                            12,
                            28,
                            53,
                          ),
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AVATAR COLOR
  // ============================================================

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
// DEPARTMENT MODEL
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