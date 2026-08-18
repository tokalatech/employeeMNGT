import 'package:flutter/material.dart';
import '../models/document_model.dart';
import '../services/document_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import 'document_viewer_screen.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final DocumentService _documentService = DocumentService();
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EmployeeDocument>>(
      stream: _documentService.watchMyDocuments(),
      builder: (context, snapshot) {
        final docs = snapshot.data ?? [];
        final visible = docs.where((d) => _category == 'All' || documentCategoryToString(d.category) == _category).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 6,
              children: [
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
            if (visible.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'No documents found in this category.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              )
            else
              ...visible.map(_doc),
          ],
        );
      },
    );
  }

  Widget _doc(EmployeeDocument d) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: PulseCard(
      onTap: () => showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(d.name),
          content: Text('${documentFileTypeToString(d.fileType)} document · ${d.fileSize}\nAdded ${d.dateAdded}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(c);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DocumentViewerScreen()));
              },
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
          d.name,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${documentCategoryToString(d.category)} · ${d.dateAdded}',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    ),
  );
}
