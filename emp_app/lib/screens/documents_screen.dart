import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import 'document_viewer_screen.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _category = 'All';
  final _docs = const [
    [
      'Offer Letter & Employment Agreement',
      'My Documents',
      '15 Jan 2023',
      '1.4 MB',
    ],
    [
      'W-4 Tax Withholding Allowance Form 2026',
      'Certificates',
      '02 Jan 2026',
      '420 KB',
    ],
    [
      'Employee Handbook & Code of Conduct v4',
      'Company Policies',
      '10 Mar 2026',
      '3.8 MB',
    ],
    ['Payslip - July 2026', 'Payslips', '31 Jul 2026', '180 KB'],
    [
      'Verified Employment Certificate',
      'My Documents',
      '09 Aug 2026',
      '310 KB',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _docs.where((d) => _category == 'All' || d[1] == _category);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 6,
          children:
              [
                    'All',
                    'My Documents',
                    'Company Policies',
                    'Payslips',
                    'Certificates',
                  ]
                  .map(
                    (c) => ChoiceChip(
                      label: Text(c, style: const TextStyle(fontSize: 11)),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 15),
        ...visible.map(_doc),
      ],
    );
  }

  Widget _doc(List<String> d) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: PulseCard(
      onTap: () => showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(d[0]),
          content: Text('PDF document · ${d[3]}\nAdded ${d[2]}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () { Navigator.pop(c); Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DocumentViewerScreen())); },
              child: const Text('View Document'),
            ),
          ],
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFFFE4E6),
          child: Icon(Icons.picture_as_pdf, color: AppColors.danger),
        ),
        title: Text(
          d[0],
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${d[1]} · ${d[2]}',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    ),
  );
}
