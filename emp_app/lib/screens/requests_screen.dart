import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final _items = <List<String>>[
    ['Employment Certificate', '09 Aug 2026', 'Completed'],
    ['Attendance Correction', '10 Aug 2026', 'Pending'],
    ['Profile Update', '01 Jul 2026', 'Approved'],
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              'SELF-SERVICE REQUESTS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: _create,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('New Request'),
          ),
        ],
      ),
      const SizedBox(height: 13),
      ..._items.map(
        (item) => Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: PulseCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFEDE9FE),
                child: Icon(Icons.send_outlined, color: AppColors.primary),
              ),
              title: Text(
                item[0],
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                'Applied ${item[1]}',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: Text(
                item[2],
                style: TextStyle(
                  color: item[2] == 'Pending'
                      ? AppColors.warning
                      : AppColors.success,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  void _create() {
    final details = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.of(sheet).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create Request',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Request type',
                hintText: 'Employment Certificate',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: details,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Request details'),
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'Submit Request',
              icon: Icons.send,
              onPressed: () {
                if (details.text.isNotEmpty) {
                  setState(
                    () => _items.insert(0, [
                      'Employment Certificate',
                      '13 Aug 2026',
                      'Pending',
                    ]),
                  );
                }
                Navigator.pop(sheet);
              },
            ),
          ],
        ),
      ),
    );
  }
}
