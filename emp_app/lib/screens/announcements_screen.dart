import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final _items = <Map<String, dynamic>>[
    {
      'title': 'Company All-Hands Meeting & Q3 Product Roadmap',
      'date': '11 Aug 2026',
      'category': 'Company',
      'body':
          'Join us this Thursday at 10 AM PST for strategic updates and product showcase.',
      'read': false,
    },
    {
      'title': 'Updated Parental Leave & Wellness Reimbursement Policy',
      'date': '05 Aug 2026',
      'category': 'Policy',
      'body':
          'New benefits effective September 1st, including annual wellness credit.',
      'read': true,
    },
    {
      'title': 'Office Security Patch & Mobile Keycard Update',
      'date': '01 Aug 2026',
      'category': 'HR Notice',
      'body':
          'Office doors will migrate to Bluetooth digital badges via the mobile app.',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) => ListView(
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
      ..._items.map(_card),
    ],
  );

  Widget _card(Map<String, dynamic> item) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: PulseCard(
      onTap: () {
        setState(() => item['read'] = true);
        _details(item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  item['category'],
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                item['date'],
                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
              ),
              if (!item['read'])
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
            item['title'],
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            item['body'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ),
    ),
  );

  void _details(Map<String, dynamic> item) => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['title'],
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Text(
            '${item['category']} · ${item['date']}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 12),
          Text(item['body'], style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
