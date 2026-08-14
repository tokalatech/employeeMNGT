import 'flow_detail_screen.dart';

class TeamMemberDetailsScreen extends FlowDetailScreen {
  const TeamMemberDetailsScreen({super.key})
    : super(
        title: 'Team Member Profile',
        subtitle: 'Contact and performance summary',
        sections: const [
          ('Contact', 'employee@company.com · +1 555 0100'),
          ('Attendance', 'Present · clocked in 09:02 AM'),
          ('Performance', '4.8 / 5 · 84% goal completion'),
        ],
      );
}
