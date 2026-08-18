import 'package:flutter/material.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  String selectedFilter = 'ALL';

  final List<DocumentItem> documents = [
    DocumentItem(
      title: 'Employee Handbook 2026 v2.4.pdf',
      type: 'POLICY',
      size: '2.4 MB',
      uploadedDate: '2026-01-15',
      uploadedBy: 'Sarah Jenkins',
    ),
    DocumentItem(
      title: 'Health & Dental Insurance Summary 2026.pdf',
      type: 'POLICY',
      size: '1.8 MB',
      uploadedDate: '2026-02-01',
      uploadedBy: 'Priya Patel',
    ),
    DocumentItem(
      title: 'Leave & Attendance Policy Guidelines.pdf',
      type: 'POLICY',
      size: '850 KB',
      uploadedDate: '2026-03-10',
      uploadedBy: 'Sarah Jenkins',
    ),
    DocumentItem(
      title: 'Direct Deposit & W-4 Tax Allowance Form.pdf',
      type: 'FORM',
      size: '420 KB',
      uploadedDate: '2026-01-05',
      uploadedBy: 'Priya Patel',
    ),
    DocumentItem(
      title: 'Performance Review Evaluation Template.docx',
      type: 'TEMPLATE',
      size: '310 KB',
      uploadedDate: '2026-05-20',
      uploadedBy: 'David Vance',
    ),
  ];

  List<DocumentItem> get filteredDocuments {
    if (selectedFilter == 'ALL') {
      return documents;
    }

    return documents
        .where((document) => document.type == selectedFilter)
        .toList();
  }

  void _showUploadDialog() {
    final titleController = TextEditingController();

    String selectedType = 'POLICY';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                'Upload Document',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111A38),
                ),
              ),
              content: SizedBox(
                width: 460,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Document Name',
                        hintText: 'Enter document name',
                        prefixIcon: const Icon(
                          Icons.description_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Document Type',
                        prefixIcon: const Icon(
                          Icons.category_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'POLICY',
                          child: Text('Policy'),
                        ),
                        DropdownMenuItem(
                          value: 'FORM',
                          child: Text('Form'),
                        ),
                        DropdownMenuItem(
                          value: 'TEMPLATE',
                          child: Text('Template'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFDDE4F1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 42,
                            color: Colors.indigo.shade400,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Choose a document to upload',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF233154),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'PDF, DOC, DOCX',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8090AE),
                            ),
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'File picker can be connected here.',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.attach_file),
                            label: const Text('Choose File'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                20,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter a document name.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      documents.insert(
                        0,
                        DocumentItem(
                          title: titleController.text.trim(),
                          type: selectedType,
                          size: 'New File',
                          uploadedDate: '2026-08-17',
                          uploadedBy: 'Sarah Jenkins',
                        ),
                      );
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Document uploaded successfully.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5038F5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _downloadDocument(DocumentItem document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Downloading ${document.title}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                32,
                18,
                32,
                40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1600,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 30),

                      _buildFilters(),

                      const SizedBox(height: 30),

                      _buildDocumentsGrid(constraints.maxWidth),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        32,
        30,
        30,
        30,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF11162F),
            Color(0xFF181D48),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF252B68),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF4D5CFF),
                        ),
                      ),
                      child: const Text(
                        'Document Repository',
                        style: TextStyle(
                          color: Color(0xFF9AA7FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      '·  Compliance & Policies',
                      style: TextStyle(
                        color: Color(0xFF9BA9C9),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const Text(
                  'HR Document Center',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Access employee handbooks, health insurance forms, tax documentation, and company templates.',
                  style: TextStyle(
                    color: Color(0xFFD6DCED),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 30),

          ElevatedButton.icon(
            onPressed: _showUploadDialog,
            icon: const Icon(
              Icons.file_upload_outlined,
              size: 21,
            ),
            label: const Text(
              'Upload Document',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5038F5),
              foregroundColor: Colors.white,
              elevation: 5,
              shadowColor: const Color(0xFF5038F5),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _buildFilters() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDCE3EF),
          ),
        ),
      ),
      child: Row(
        children: [
          _filterButton(
            label: 'All Files',
            value: 'ALL',
          ),
          const SizedBox(width: 10),
          _filterButton(
            label: 'POLICY',
            value: 'POLICY',
          ),
          const SizedBox(width: 10),
          _filterButton(
            label: 'FORM',
            value: 'FORM',
          ),
          const SizedBox(width: 10),
          _filterButton(
            label: 'TEMPLATE',
            value: 'TEMPLATE',
          ),
        ],
      ),
    );
  }

  Widget _filterButton({
    required String label,
    required String value,
  }) {
    final bool selected = selectedFilter == value;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF5038F5)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: selected
              ? [
            BoxShadow(
              color: const Color(0xFF5038F5)
                  .withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : const Color(0xFF344563),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DOCUMENT GRID
  // ============================================================

  Widget _buildDocumentsGrid(double screenWidth) {
    int crossAxisCount;

    if (screenWidth >= 1250) {
      crossAxisCount = 3;
    } else if (screenWidth >= 800) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredDocuments.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 22,
        mainAxisSpacing: 22,
        childAspectRatio: screenWidth >= 1250
            ? 1.70
            : screenWidth >= 800
            ? 1.65
            : 1.55,
      ),
      itemBuilder: (context, index) {
        return _documentCard(
          filteredDocuments[index],
        );
      },
    );
  }

  // ============================================================
  // DOCUMENT CARD
  // ============================================================

  Widget _documentCard(DocumentItem document) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        26,
        25,
        26,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFDDE4EF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF5038F5),
                  size: 28,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3F7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  document.type,
                  style: const TextStyle(
                    color: Color(0xFF344563),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            document.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF101A35),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Size: ${document.size} · Uploaded ${document.uploadedDate}',
            style: const TextStyle(
              color: Color(0xFF8190AE),
              fontSize: 13,
            ),
          ),

          const Spacer(),

          Container(
            height: 1,
            color: const Color(0xFFE9EDF4),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Text(
                  'By ${document.uploadedBy}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF58708F),
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              TextButton.icon(
                onPressed: () {
                  _downloadDocument(document);
                },
                icon: const Icon(
                  Icons.download_outlined,
                  size: 19,
                ),
                label: const Text(
                  'Download',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFEFF2FF),
                  foregroundColor: const Color(0xFF5038F5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DOCUMENT MODEL
// ============================================================

class DocumentItem {
  final String title;
  final String type;
  final String size;
  final String uploadedDate;
  final String uploadedBy;

  DocumentItem({
    required this.title,
    required this.type,
    required this.size,
    required this.uploadedDate,
    required this.uploadedBy,
  });
}