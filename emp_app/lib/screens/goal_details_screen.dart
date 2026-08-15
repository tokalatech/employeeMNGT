import 'flow_detail_screen.dart';
import '../models/goal_model.dart';
class GoalDetailsScreen extends FlowDetailScreen {
  final Goal goal;
  GoalDetailsScreen({super.key,required this.goal})
    : super(
        title: goal.title,
        subtitle: goal.description,
        sections: [
          (
          'Progress',
          '${goal.progressPercent}% complete · ${goalStatusToString(goal.status)}',
          ),
          (
          'KPI',
          goal.kpi,
          ),
          (
          'Target',
          goal.target,
          ),
          (
          'Current Value',
          goal.currentValue,
          ),
          (
          'Deadline',
          goal.deadline,
          ),
          (
          'Manager Feedback',
          goal.managerComments ?? 'No manager comments.',
          ),
        ],
      );
}
