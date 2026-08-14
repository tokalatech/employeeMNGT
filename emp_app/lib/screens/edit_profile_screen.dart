import 'flow_detail_screen.dart';

class EditProfileScreen extends FlowDetailScreen {
  const EditProfileScreen({super.key})
    : super(
        title: 'Edit Profile',
        subtitle: 'Update contact information',
        action: 'Save Profile',
        sections: const [
          ('Personal details', 'Name, phone, and address'),
          ('Emergency contact', 'Name, relationship, and phone number'),
        ],
      );
}
