import 'flow_detail_screen.dart';

class TicketDetailsScreen extends FlowDetailScreen {
  const TicketDetailsScreen({super.key})
    : super(
        title: 'Support Ticket',
        subtitle: 'Conversation and status',
        action: 'Send Reply',
        sections: const [
          ('Status', 'In Progress'),
          ('Latest reply', 'The support team is reviewing your request'),
        ],
      );
}
