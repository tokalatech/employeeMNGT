import 'flow_detail_screen.dart';

class AnnouncementDetailsScreen extends FlowDetailScreen {
  const AnnouncementDetailsScreen({super.key})
    : super(
        title: 'Announcement',
        subtitle: 'Official company notice',
        sections: const [
          ('Company update', 'Q3 all-hands meeting and product roadmap'),
          ('Published by', 'People Operations'),
        ],
      );
}
