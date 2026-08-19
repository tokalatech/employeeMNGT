import 'package:flutter/material.dart';

class PerformancePage extends StatefulWidget {
  const PerformancePage({super.key});

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  int selectedTab = 0;

  final List<GoalData> goals = [
    GoalData(
      category: 'TECHNICAL',
      title: 'Complete Flutter & React Architecture Upgrade',
      description:
      'Refactor mobile & web HRMS modules to ensure production-grade clean architecture with sub-100ms load times.',
      progress: 85,
      status: 'IN PROGRESS',
      target: '2026-08-30',
      assignedTo: 'Alex Rivera',
      progressColor: Color(0xFF9C27F5),
    ),
    GoalData(
      category: 'TECHNICAL',
      title: 'Achieve 95%+ Unit Test Code Coverage',
      description:
      'Write comprehensive widget and integration tests for attendance and payroll calculation logic.',
      progress: 60,
      status: 'IN PROGRESS',
      target: '2026-09-15',
      assignedTo: 'Alex Rivera',
      progressColor: Color(0xFF9C27F5),
    ),
    GoalData(
      category: 'INNOVATION',
      title: 'Redesign Mobile Design System v2.0',
      description:
      'Design dark/light theme tokens and accessible Material 3 component library.',
      progress: 100,
      status: 'COMPLETED',
      target: '2026-08-10',
      assignedTo: 'Emily Chen',
      progressColor: Color(0xFF00B982),
    ),
  ];

  final List<ReviewData> reviews = [
    ReviewData(
      employee: 'Alex Rivera',
      role: 'Senior Frontend Engineer',
      reviewPeriod: 'Q2 2026',
      rating: '4.5',
      status: 'COMPLETED',
    ),
    ReviewData(
      employee: 'Emily Chen',
      role: 'Lead Product Designer',
      reviewPeriod: 'Q2 2026',
      rating: '4.8',
      status: 'COMPLETED',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTabs(),
              const SizedBox(height: 24),
              selectedTab == 0
                  ? _buildGoalsGrid()
                  : _buildReviewsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF5B1B93),
            Color(0xFF242A61),
            Color(0xFF10182F),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8E3FE7),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFB25BFF),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Talent Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Goals, KPIs & Reviews',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Track key performance indicators, OKRs, progress milestones, and quarterly performance appraisals.',
                  style: TextStyle(
                    color: Color(0xFFE0DFFF),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          _buildAssignGoalButton(),
        ],
      ),
    );
  }

  Widget _buildAssignGoalButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: ElevatedButton.icon(
        onPressed: _showAssignGoalDialog,
        icon: const Icon(
          Icons.add,
          size: 18,
        ),
        label: const Text(
          'Assign New Goal',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA832FF),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // TABS
  // ----------------------------------------------------------

  Widget _buildTabs() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDCE2EC),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTab(
            icon: Icons.track_changes,
            title: 'Active Goals & KPIs',
            count: '3',
            index: 0,
          ),
          const SizedBox(width: 8),
          _buildTab(
            icon: Icons.star_border,
            title: 'Performance Reviews',
            count: '2',
            index: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String title,
    required String count,
    required int index,
  }) {
    final bool selected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF9B20F4)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFF9B20F4)
                : const Color(0xFFE0E5EE),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 17,
              color: selected
                  ? Colors.white
                  : const Color(0xFF41516C),
            ),
            const SizedBox(width: 7),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : const Color(0xFF34445E),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '($count)',
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : const Color(0xFF34445E),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // GOALS GRID
  // ----------------------------------------------------------

  Widget _buildGoalsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= 900;

        if (wide) {
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: goals.map((goal) {
              return SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildGoalCard(goal),
              );
            }).toList(),
          );
        }

        return Column(
          children: goals.map((goal) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildGoalCard(goal),
            );
          }).toList(),
        );
      },
    );
  }

  // ----------------------------------------------------------
  // GOAL CARD
  // ----------------------------------------------------------

  Widget _buildGoalCard(GoalData goal) {
    final bool completed = goal.progress == 100;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE2EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9EFFF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  goal.category,
                  style: const TextStyle(
                    color: Color(0xFF8B13D6),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: completed
                      ? const Color(0xFFD4F7E9)
                      : const Color(0xFFDCE5FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  goal.status,
                  style: TextStyle(
                    color: completed
                        ? const Color(0xFF008C64)
                        : const Color(0xFF2639B8),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            goal.title,
            style: const TextStyle(
              color: Color(0xFF101A31),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            goal.description,
            style: const TextStyle(
              color: Color(0xFF647995),
              fontSize: 12,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          // Progress title
          Row(
            children: [
              const Text(
                'Progress Level',
                style: TextStyle(
                  color: Color(0xFF24334D),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${goal.progress}%',
                style: const TextStyle(
                  color: Color(0xFF263A58),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: goal.progress / 100,
              minHeight: 10,
              backgroundColor: const Color(0xFFE9EDF4),
              valueColor: AlwaysStoppedAnimation<Color>(
                goal.progressColor,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Slider
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 5,
                    activeTrackColor: const Color(0xFFA323F4),
                    inactiveTrackColor: const Color(0xFFE0E4EA),
                    thumbColor: const Color(0xFFA323F4),
                    overlayColor: const Color(0x229B20F4),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                    ),
                  ),
                  child: Slider(
                    value: goal.progress.toDouble(),
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        goal.progress = value.round();

                        if (goal.progress == 100) {
                          goal.status = 'COMPLETED';
                          goal.progressColor =
                          const Color(0xFF00B982);
                        } else {
                          goal.status = 'IN PROGRESS';
                          goal.progressColor =
                          const Color(0xFF9C27F5);
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Slide to update',
                style: TextStyle(
                  color: Color(0xFF61718A),
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Divider(
            color: Color(0xFFE7EBF1),
            height: 1,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.access_time_outlined,
                size: 15,
                color: Color(0xFF8293AD),
              ),
              const SizedBox(width: 6),
              const Text(
                'Target:',
                style: TextStyle(
                  color: Color(0xFF71839E),
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                goal.target,
                style: const TextStyle(
                  color: Color(0xFF41638B),
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              const Text(
                'Assigned to:',
                style: TextStyle(
                  color: Color(0xFF71839E),
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                goal.assignedTo,
                style: const TextStyle(
                  color: Color(0xFF14233F),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PERFORMANCE REVIEWS
  // ----------------------------------------------------------

  Widget _buildReviewsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= 900;

        if (wide) {
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: reviews.map((review) {
              return SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildReviewCard(review),
              );
            }).toList(),
          );
        }

        return Column(
          children: reviews.map((review) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildReviewCard(review),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildReviewCard(ReviewData review) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDCE2EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE8E9FF),
                child: Text(
                  review.employee
                      .split(' ')
                      .map((e) => e[0])
                      .take(2)
                      .join(),
                  style: const TextStyle(
                    color: Color(0xFF5D3CF5),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.employee,
                      style: const TextStyle(
                        color: Color(0xFF14213B),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      review.role,
                      style: const TextStyle(
                        color: Color(0xFF71839C),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD3F7E8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  review.status,
                  style: const TextStyle(
                    color: Color(0xFF008A61),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(
            color: Color(0xFFE7EBF1),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Color(0xFF7588A4),
              ),
              const SizedBox(width: 8),
              Text(
                review.reviewPeriod,
                style: const TextStyle(
                  color: Color(0xFF536B8B),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              const Text(
                'Rating',
                style: TextStyle(
                  color: Color(0xFF71839C),
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 7),
              const Icon(
                Icons.star,
                size: 16,
                color: Color(0xFFFFB000),
              ),
              const SizedBox(width: 3),
              Text(
                review.rating,
                style: const TextStyle(
                  color: Color(0xFF182741),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ASSIGN GOAL DIALOG
  // ----------------------------------------------------------

  void _showAssignGoalDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final employeeController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Assign New Goal',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField(
                    controller: titleController,
                    label: 'Goal Title',
                    hint: 'Enter goal title',
                  ),
                  const SizedBox(height: 12),
                  _dialogField(
                    controller: descriptionController,
                    label: 'Description',
                    hint: 'Enter goal description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  _dialogField(
                    controller: employeeController,
                    label: 'Assign To',
                    hint: 'Employee name',
                  ),
                  const SizedBox(height: 12),
                  _dialogField(
                    controller: targetController,
                    label: 'Target Date',
                    hint: 'YYYY-MM-DD',
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  goals.add(
                    GoalData(
                      category: 'TECHNICAL',
                      title: titleController.text.trim(),
                      description:
                      descriptionController.text.trim(),
                      progress: 0,
                      status: 'IN PROGRESS',
                      target: targetController.text.trim().isEmpty
                          ? 'Not Set'
                          : targetController.text.trim(),
                      assignedTo:
                      employeeController.text.trim().isEmpty
                          ? 'Unassigned'
                          : employeeController.text.trim(),
                      progressColor:
                      const Color(0xFF9C27F5),
                    ),
                  );
                });

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B20F4),
                foregroundColor: Colors.white,
              ),
              child: const Text('Assign Goal'),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------
// DATA MODELS
// ----------------------------------------------------------

class GoalData {
  String category;
  String title;
  String description;
  int progress;
  String status;
  String target;
  String assignedTo;
  Color progressColor;

  GoalData({
    required this.category,
    required this.title,
    required this.description,
    required this.progress,
    required this.status,
    required this.target,
    required this.assignedTo,
    required this.progressColor,
  });
}

class ReviewData {
  final String employee;
  final String role;
  final String reviewPeriod;
  final String rating;
  final String status;

  ReviewData({
    required this.employee,
    required this.role,
    required this.reviewPeriod,
    required this.rating,
    required this.status,
  });
}