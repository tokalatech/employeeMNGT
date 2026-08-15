import 'package:flutter/material.dart';
import '../models/announcement_model.dart';
import '../services/announcement_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final AnnouncementService _announcementService = AnnouncementService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Announcement>>(
      stream: _announcementService.watchAnnouncements(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 40,
                    color: AppColors.danger,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unable to load announcements',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final announcements = snapshot.data ?? [];

        // Empty
        if (announcements.isEmpty) {
          return const Center(
            child: Text(
              'No announcements available',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'COMPANY ANNOUNCEMENTS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 10),

            ...announcements.map(_card),
          ],
        );
      },
    );
  }

  Widget _card(Announcement announcement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PulseCard(
        onTap: () async {
          // Mark announcement as read in Firebase
          if (!announcement.isRead) {
            await _announcementService.markAsRead(announcement.id);
          }

          if (!mounted) return;

          _details(announcement);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _categoryColor(
                      announcement.category,
                    ).withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    announcementCategoryToString(
                      announcement.category,
                    ),
                    style: TextStyle(
                      color: _categoryColor(
                        announcement.category,
                      ),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  announcement.publishedDate,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),

                if (!announcement.isRead)
                  const Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.danger,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 9),

            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              announcement.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(AnnouncementCategory category) {
    switch (category) {
      case AnnouncementCategory.company:
        return AppColors.warning;

      case AnnouncementCategory.policy:
        return AppColors.primary;

      case AnnouncementCategory.event:
        return Colors.green;

      case AnnouncementCategory.hrNotice:
        return Colors.orange;
    }
  }

  void _details(Announcement announcement) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '${announcementCategoryToString(announcement.category)} · '
                      '${announcement.publishedDate}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Published by ${announcement.author}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  announcement.content,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}