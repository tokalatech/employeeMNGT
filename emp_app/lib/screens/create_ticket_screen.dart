import 'flow_detail_screen.dart';

class CreateTicketScreen extends FlowDetailScreen {
  const CreateTicketScreen({super.key})
    : super(
        title: 'Raise Support Ticket',
        subtitle: 'IT, payroll, or HR support',
        action: 'Submit Ticket',
        sections: const [
          ('Category & priority', 'Choose category and priority'),
          ('Description', 'Tell us what you need help with'),
        ],
      );
}
