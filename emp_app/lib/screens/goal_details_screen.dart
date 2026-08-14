import 'flow_detail_screen.dart';

class GoalDetailsScreen extends FlowDetailScreen {
  const GoalDetailsScreen({super.key})
    : super(
        title: 'Goal Details',
        subtitle: 'Objective progress and feedback',
        sections: const [
          ('Progress', '84% complete · On Track'),
          (
            'Manager feedback',
            'Strong work; continue the current delivery pace',
          ),
        ],
      );
}
