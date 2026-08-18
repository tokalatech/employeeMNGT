import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
    required this.onOpen,
  });

  final ValueChanged<String> onOpen;

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService =
  NotificationService();

  NotificationCategory? _category;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppNotification>>(
      stream: _notificationService.watchMyNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return _errorState(snapshot.error.toString());
        }

        final notifications = snapshot.data ?? [];

        final filteredNotifications = notifications.where((notification) {
          if (_category == null) {
            return true;
          }

          return notification.category == _category;
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _header(notifications),
            const SizedBox(height: 8),
            _categoryFilter(),
            const SizedBox(height: 12),

            if (filteredNotifications.isEmpty)
              _emptyState()
            else
              ...filteredNotifications.map(_notificationItem),
          ],
        );
      },
    );
  }

  Widget _header(List<AppNotification> notifications) {
    final hasUnread = notifications.any(
          (notification) => !notification.isRead,
    );

    return Row(
      children: [
        const Expanded(
          child: Text(
            'NOTIFICATIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        if (hasUnread)
          TextButton(
            onPressed: () async {
              try {
                await _notificationService.markAllAsRead();
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Unable to mark notifications as read: $e',
                    ),
                  ),
                );
              }
            },
            child: const Text('Mark all read'),
          ),
      ],
    );
  }

  Widget _categoryFilter() {
    final categories = <NotificationCategory?>[
      null,
      NotificationCategory.leave,
      NotificationCategory.attendance,
      NotificationCategory.payroll,
      NotificationCategory.performance,
      NotificationCategory.announcements,
      NotificationCategory.helpdesk,
      NotificationCategory.requests,
    ];

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: categories.map((category) {
        final selected = _category == category;

        return ChoiceChip(
          label: Text(
            category == null
                ? 'All'
                : notificationCategoryToString(category),
            style: const TextStyle(fontSize: 11),
          ),
          selected: selected,
          onSelected: (_) {
            setState(() {
              _category = category;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _notificationItem(AppNotification notification) {
    return Dismissible(
      key: ValueKey(notification.id),

      background: Container(
        margin: const EdgeInsets.only(bottom: 9),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),

      direction: DismissDirection.endToStart,

      confirmDismiss: (_) async {
        return await _confirmDelete(notification);
      },

      onDismissed: (_) async {
        try {
          await _notificationService.deleteNotification(
            notification.id,
          );
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Unable to delete notification: $e',
              ),
            ),
          );
        }
      },

      child: Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: PulseCard(
          onTap: () async {
            if (!notification.isRead) {
              await _notificationService.markAsRead(
                notification.id,
              );
            }

            final target = notification.targetScreen;

            if (target != null) {
              widget.onOpen(
                screenIdToString(target),
              );
            }
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,

            leading: CircleAvatar(
              backgroundColor:
              AppColors.primary.withValues(alpha: .13),
              child: Icon(
                _iconForCategory(notification.category),
                color: AppColors.primary,
              ),
            ),

            title: Text(
              notification.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: notification.isRead
                    ? FontWeight.w600
                    : FontWeight.w900,
              ),
            ),

            subtitle: Text(
              notification.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
              ),
            ),

            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  notification.timestamp,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF64748B),
                  ),
                ),

                if (!notification.isRead)
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(
      AppNotification notification,
      ) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete notification'),
          content: const Text(
            'Are you sure you want to delete this notification?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'No notifications',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You are all caught up.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load notifications',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.leave:
        return Icons.event_busy;

      case NotificationCategory.attendance:
        return Icons.access_time;

      case NotificationCategory.payroll:
        return Icons.payments_outlined;

      case NotificationCategory.performance:
        return Icons.trending_up;

      case NotificationCategory.announcements:
        return Icons.campaign_outlined;

      case NotificationCategory.helpdesk:
        return Icons.support_agent;

      case NotificationCategory.requests:
        return Icons.assignment_outlined;
    }
  }
}