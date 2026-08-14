import 'flow_detail_screen.dart';

class ApplyLeaveScreen extends FlowDetailScreen {
  const ApplyLeaveScreen({super.key})
    : super(
        title: 'Apply for Leave',
        subtitle: 'Create a local leave request',
        action: 'Submit leave request',
        sections: const [
          ('Leave type', 'Paid Leave'),
          ('Dates', 'Select start and end date'),
          ('Supporting document', 'Optional attachment'),
        ],
      );
}
