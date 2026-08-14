import 'flow_detail_screen.dart';

class DocumentViewerScreen extends FlowDetailScreen {
  const DocumentViewerScreen({super.key})
    : super(
        title: 'Document Preview',
        subtitle: 'Official HR document',
        action: 'Download document',
        sections: const [
          ('Document', 'Employment Agreement · PDF'),
          ('Verification', 'Digital document verified'),
          ('Sharing', 'Share link is available locally'),
        ],
      );
}
