import 'flow_detail_screen.dart';

class CreateRequestScreen extends FlowDetailScreen {
  const CreateRequestScreen({super.key})
    : super(
        title: 'New Self-Service Request',
        subtitle: 'Submit a request to HR',
        action: 'Submit Request',
        sections: const [
          (
            'Request type',
            'Employment certificate, profile update, or bank change',
          ),
          ('Details', 'Provide a clear purpose for HR processing'),
        ],
      );
}
