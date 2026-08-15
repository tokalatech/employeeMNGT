import 'flow_detail_screen.dart';
import '../models/announcement_model.dart';
class AnnouncementDetailsScreen extends FlowDetailScreen {
  AnnouncementDetailsScreen({super.key,required Announcement announcement,})
    : super(
    title: announcement.title,
    subtitle:
    '${announcementCategoryToString(announcement.category)} · ${announcement.publishedDate}',
    sections: [
      (
      'Summary',
      announcement.summary,
      ),
      (
      'Announcement',
      announcement.content,
      ),
      (
      'Published by',
      announcement.author,
      ),
      (
      'Priority',
      announcement.priority == AnnouncementPriority.high
          ? 'High'
          : 'Normal',
      ),
        ],
      );
}
