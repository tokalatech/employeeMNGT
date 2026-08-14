import 'flow_detail_screen.dart';

class LeaveDetailsScreen extends FlowDetailScreen {
  const LeaveDetailsScreen({super.key})
    : super(
        title: 'Leave Request Details',
        subtitle: 'Paid Leave · Pending',
        action: 'Cancel request',
        sections: const [
          ('Dates', 'Aug 25 – Aug 28, 2026 · 4 days'),
          ('Reason', 'Family vacation'),
          ('Approval status', 'Awaiting manager review'),
        ],
      );
}
