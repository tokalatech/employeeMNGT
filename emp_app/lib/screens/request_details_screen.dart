import 'flow_detail_screen.dart';

class RequestDetailsScreen extends FlowDetailScreen {
  const RequestDetailsScreen({super.key})
      : super(
    title: 'Request Details',
    subtitle: 'Self-service request status',
    sections: const [
      ('Status', 'Pending HR review'),
      ('Description', 'Employment confirmation certificate required'),
    ],
  );
}
