import 'flow_detail_screen.dart';

class LeaveApprovalsScreen extends FlowDetailScreen {
  const LeaveApprovalsScreen({super.key})
    : super(
        title: 'Leave Approvals',
        subtitle: 'Manager review queue',
        action: 'Approve selected request',
        sections: const [
          ('Pending request', 'Casual Leave · Aug 18 – Aug 19'),
          ('Employee note', 'Family event'),
          ('Review', 'Approve or reject with a reason'),
        ],
      );
}
