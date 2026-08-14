import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class HelpdeskScreen extends StatefulWidget {
  const HelpdeskScreen({super.key});

  @override
  State<HelpdeskScreen> createState() => _HelpdeskScreenState();
}

class _HelpdeskScreenState extends State<HelpdeskScreen> {
  final _tickets = <List<String>>[
    ['TKT-8902', 'Request for secondary monitor', 'IT Support', 'In Progress'],
    ['TKT-8840', 'Question regarding W-2 Tax form', 'Payroll', 'Resolved'],
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              'SUPPORT TICKETS',
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
            label: const Text('New Ticket'),
          ),
        ],
      ),
      const SizedBox(height: 12),
      ..._tickets.map(
        (ticket) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PulseCard(
            onTap: () => _ticket(ticket),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFE4E6),
                child: Icon(Icons.support_agent, color: AppColors.danger),
              ),
              title: Text(
                ticket[1],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              subtitle: Text(
                '${ticket[0]} · ${ticket[2]}',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: Text(
                ticket[3],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: ticket[3] == 'Resolved'
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  void _ticket(List<String> ticket) {
    final reply = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ticket[1],
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(
                  'Hi Alex, we are reviewing your request.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            TextField(
              controller: reply,
              decoration: InputDecoration(
                hintText: 'Write a reply',
                suffixIcon: IconButton(
                  onPressed: () {
                    if (reply.text.trim().isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reply added to the ticket.'),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _create() {
    final subject = TextEditingController();
    final description = TextEditingController();
    String category = 'IT Support';
    String priority = 'Medium';
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
        child: StatefulBuilder(
          builder: (sheet, setSheet) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Raise Support Ticket',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subject,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items:
                    const ['IT Support', 'Payroll', 'Human Resources', 'Other']
                        .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                        .toList(),
                onChanged: (x) => setSheet(() => category = x!),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: const ['Low', 'Medium', 'High']
                    .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                    .toList(),
                onChanged: (x) => setSheet(() => priority = x!),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: description,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Describe your issue',
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Submit Ticket',
                icon: Icons.send,
                onPressed: () {
                  if (subject.text.isNotEmpty) {
                    setState(
                      () => _tickets.insert(0, [
                        'TKT-NEW',
                        subject.text,
                        '$category · $priority',
                        'Open',
                      ]),
                    );
                  }
                  Navigator.pop(sheet);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
