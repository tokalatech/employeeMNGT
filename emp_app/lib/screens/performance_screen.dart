import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import '../models/goal_model.dart';
import '../models/performance_model.dart';
import '../services/goal_service.dart';
import '../services/performance_service.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  String _tab = 'Goals';
  final GoalService _goalService = GoalService();
  final PerformanceService _performanceService = PerformanceService();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _tabs(),
      const SizedBox(height: 14),
      if (_tab == 'Goals') _goals() else _reviews(),    ],
  );

  Widget _tabs() => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: ['Goals', 'Reviews']
          .map(
            (x) => Expanded(
              child: TextButton(
                onPressed: () => setState(() => _tab = x),
                style: TextButton.styleFrom(
                  backgroundColor: _tab == x
                      ? Theme.of(context).colorScheme.surface
                      : null,
                ),
                child: Text(
                  x,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _tab == x ? AppColors.primary : null,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _goal(Goal goal) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: PulseCard(
      onTap: () => _details(goal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                goalStatusToString(goal.status),
                style: TextStyle(
                  color: goal.status == GoalStatus.atRisk
                      ? AppColors.danger
                      : AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: goal.progressPercent / 100,
            color: goal.status == GoalStatus.atRisk
                ? AppColors.danger
                : AppColors.primary,
            minHeight: 7,
          ),
          const SizedBox(height: 5),
          Text(
            '${goal.progressPercent}% complete',
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    ),
  );

  Widget _goals() => StreamBuilder<List<Goal>>(
    stream: _goalService.watchMyGoals(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Text('Error loading goals: ${snapshot.error}');
      }

      final goals = snapshot.data ?? [];

      if (goals.isEmpty) {
        return const Text('No goals found.');
      }

      return Column(
        children: goals.map(_goal).toList(),
      );
    },
  );

  Widget _reviews() => StreamBuilder<List<PerformanceReview>>(
    stream: _performanceService.watchMyReviews(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Text('Error loading reviews: ${snapshot.error}');
      }

      final reviews = snapshot.data ?? [];

      if (reviews.isEmpty) {
        return const Text('No performance reviews found.');
      }

      return Column(
        children: reviews.map(_review).toList(),
      );
    },
  );

  Widget _review(PerformanceReview review) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: PulseCard(
      onTap: () => _reviewDetails(review),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEDE9FE),
          child: Icon(Icons.star, color: AppColors.primary),
        ),
        title: Text(
          review.period,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${review.status == PerformanceReviewStatus.completed ? 'Completed' : 'Pending Review'} · ${review.reviewDate}',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: Text(
          '${review.overallRating} / 5',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
      ),
    ),
  );

  void _details(Goal goal) => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (c) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Text('KPI: ${goal.kpi}'),
          Text(
            'Progress: ${goal.progressPercent}% · ${goalStatusToString(goal.status)}',
          ),
          const SizedBox(height: 10),
          Text(
            'Manager comments: ${goal.managerComments ?? 'No manager comments.'}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );

  void _reviewDetails(PerformanceReview review) => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (c) => Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.period,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10),
          Text('Overall Rating: ${review.overallRating} / 5.0'),
          SizedBox(height: 8),
          Text(
            'Strengths: ${review.strengths.join(', ')}',
          ),
          SizedBox(height: 8),
          Text(
            'Areas for improvement: ${review.areasForImprovement.join(', ')}',
          ),
          SizedBox(height: 15),
          Text(
            'Manager feedback: ${review.managerFeedback}',
          ),
        ],
      ),
    ),
  );
}
