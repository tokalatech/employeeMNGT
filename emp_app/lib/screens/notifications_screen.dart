import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.onOpen});

  final ValueChanged<String> onOpen;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _category = 'All';
  final _items = <Map<String, dynamic>>[
    {
      'title': 'Leave Request Received',
      'body': 'Your leave request for Aug 25 - Aug 28 is under review.',
      'time': '10 Aug, 11:20 AM',
      'type': 'Leave',
      'read': false,
    },
    {
      'title': 'July Payslip Published',
      'body': 'Your net salary of \$7,420.00 has been direct deposited.',
      'time': '31 Jul, 09:00 AM',
      'type': 'Payroll',
      'read': true,
    },
    {
      'title': 'New Company Announcement',
      'body': 'Q3 All-Hands Meeting & Roadmap update released.',
      'time': '11 Aug, 08:30 AM',
      'type': 'Announcements',
      'read': false,
    },
    {
      'title': 'Helpdesk Ticket Update',
      'body': 'Jason replied to TKT-8902 regarding monitor delivery.',
      'time': '09 Aug, 02:30 PM',
      'type': 'Helpdesk',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Row(
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
          TextButton(
            onPressed: () => setState(() {
              for (final x in _items) {
                x['read'] = true;
              }
            }),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 6,
        children: ['All', 'Leave', 'Payroll', 'Announcements', 'Helpdesk']
            .map(
              (type) => ChoiceChip(
                label: Text(type, style: const TextStyle(fontSize: 11)),
                selected: _category == type,
                onSelected: (_) => setState(() => _category = type),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 12),
      ..._items
          .where((item) => _category == 'All' || item['type'] == _category)
          .map(_item),
    ],
  );

  Widget _item(Map<String, dynamic> item) => Dismissible(
    key: ValueKey(item['title']),
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: AppColors.danger,
      child: const Icon(Icons.delete_outline, color: Colors.white),
    ),
    onDismissed: (_) => setState(() => _items.remove(item)),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: PulseCard(
        onTap: () {
          setState(() => item['read'] = true);
          widget.onOpen(_target(item['type'] as String));
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: .13),
            child: const Icon(
              Icons.notifications_none,
              color: AppColors.primary,
            ),
          ),
          title: Text(
            item['title'],
            style: TextStyle(
              fontSize: 13,
              fontWeight: item['read'] ? FontWeight.w600 : FontWeight.w900,
            ),
          ),
          subtitle: Text(
            item['body'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item['time'],
                style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
              ),
              if (!item['read'])
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

  String _target(String type) => switch (type) {
    'Leave' => 'leave',
    'Payroll' => 'payslips',
    'Announcements' => 'announcements',
    'Helpdesk' => 'helpdesk',
    _ => 'notifications',
  };
}
