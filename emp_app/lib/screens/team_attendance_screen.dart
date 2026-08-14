import 'flow_detail_screen.dart';

class TeamAttendanceScreen extends FlowDetailScreen {
  const TeamAttendanceScreen({super.key})
    : super(
        title: 'Team Attendance',
        subtitle: 'Live attendance overview',
        sections: const [
          ('Today', '3 present · 1 work from home · 1 late'),
          ('Attention', 'One pending attendance correction'),
        ],
      );
}
