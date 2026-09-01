import 'package:flutter/material.dart';

class SelfServicePage extends StatefulWidget {
  const SelfServicePage({super.key});

  @override
  State<SelfServicePage> createState() => _SelfServicePageState();
}

class _SelfServicePageState extends State<SelfServicePage> {
  final List<SelfServiceRequest> requests = [
    SelfServiceRequest(
      type: 'SALARY CERTIFICATE',
      title: 'Salary Certificate for Bank Loan',
      description:
      'Requesting official stamped salary certificate for home mortgage application.',
      status: 'COMPLETED',
      requestedDate: '2026-08-01',
      requestedBy: 'Alex Rivera',
      resolution:
      'HR Resolution: Certificate generated and attached to your Documents portal.',
    ),
    SelfServiceRequest(
      type: 'ATTENDANCE CORRECTION',
      title: 'Attendance Punch Correction - Aug 03',
      description:
      'Forgot to clock out due to late client meeting. Check-out time was 07:15 PM.',
      status: 'PENDING',
      requestedDate: '2026-08-03',
      requestedBy: 'Alex Rivera',
      resolution: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final bool mobile = width < 700;
            final bool desktop = width >= 1100;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                mobile ? 16 : 24,
                mobile ? 16 : 24,
                mobile ? 16 : 24,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============================================================
                  // HEADER
                  // ============================================================

                  _buildHeader(mobile),

                  const SizedBox(height: 28),

                  // ============================================================
                  // REQUEST CARDS
                  // ============================================================

                  if (mobile)
                    _buildMobileRequests()
                  else if (desktop)
                    _buildDesktopRequests()
                  else
                    _buildTabletRequests(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE REQUESTS
  // ============================================================

  Widget _buildMobileRequests() {
    return Column(
      children: [
        for (int i = 0; i < requests.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == requests.length - 1 ? 0 : 20,
            ),
            child: _buildRequestCard(
              requests[i],
              mobile: true,
            ),
          ),
      ],
    );
  }

  // ============================================================
  // TABLET REQUESTS
  // ============================================================

  Widget _buildTabletRequests() {
    return Column(
      children: [
        for (int i = 0; i < requests.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == requests.length - 1 ? 0 : 24,
            ),
            child: _buildRequestCard(
              requests[i],
              mobile: false,
            ),
          ),
      ],
    );
  }

  // ============================================================
  // DESKTOP REQUESTS - SIDE BY SIDE
  // ============================================================

  Widget _buildDesktopRequests() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildRequestCard(
            requests[0],
            mobile: false,
          ),
        ),

        const SizedBox(width: 28),

        Expanded(
          child: _buildRequestCard(
            requests[1],
            mobile: false,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(bool mobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(mobile ? 22 : 40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF334F91),
            Color(0xFF171B43),
          ],
        ),
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: mobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderText(),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: _newRequestButton(),
          ),
        ],
      )
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildHeaderText(),
          ),

          const SizedBox(width: 30),

          _newRequestButton(),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER TEXT
  // ============================================================

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Requests & Certificates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          'Request official salary certificates, experience letters, attendance punch corrections, and expense reimbursements.',
          style: TextStyle(
            color: Color(0xFFD3DAEA),
            fontSize: 15,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // NEW REQUEST BUTTON
  // ============================================================

  Widget _newRequestButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _showNewRequestDialog,
        icon: const Icon(
          Icons.add,
          size: 25,
        ),
        label: const Text(
          'New Self-Service Request',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF347DD4),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // REQUEST CARD
  // ============================================================

  Widget _buildRequestCard(
      SelfServiceRequest request, {
        required bool mobile,
      }) {
    final bool isCompleted = request.status == 'COMPLETED';
    final bool isPending = request.status == 'PENDING';

    return Container(
      width: double.infinity,

      // IMPORTANT:
      // No fixed height.
      // Card grows automatically according to its content.
      padding: EdgeInsets.all(mobile ? 20 : 30),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFD7DEE8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // TYPE + STATUS
          // ==========================================================

          mobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _typeBadge(request.type),

              const SizedBox(height: 14),

              _statusBadge(request.status),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: _typeBadge(request.type),
              ),

              const SizedBox(width: 12),

              _statusBadge(request.status),
            ],
          ),

          const SizedBox(height: 28),

          // ==========================================================
          // TITLE
          // ==========================================================

          Text(
            request.title,
            softWrap: true,
            style: TextStyle(
              color: const Color(0xFF1D2A3E),
              fontSize: mobile ? 20 : 24,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 14),

          // ==========================================================
          // DESCRIPTION
          // ==========================================================

          Text(
            request.description,
            softWrap: true,
            style: TextStyle(
              color: const Color(0xFF62738D),
              fontSize: mobile ? 14 : 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 26),

          // ==========================================================
          // COMPLETED REQUEST
          // ==========================================================

          if (isCompleted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FBF7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFB7E5D6),
                ),
              ),
              child: Text(
                request.resolution,
                softWrap: true,
                style: const TextStyle(
                  color: Color(0xFF365B55),
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ),

          // ==========================================================
          // PENDING REQUEST
          // ==========================================================

          if (isPending)
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () => _approveRequest(request),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF12936F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Approve & Fulfill Request',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 22),

          // ==========================================================
          // DIVIDER
          // ==========================================================

          const Divider(
            height: 1,
            color: Color(0xFFE2E7EE),
          ),

          const SizedBox(height: 16),

          // ==========================================================
          // FOOTER
          // ==========================================================

          mobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _footerText(
                'Requested: ${request.requestedDate}',
              ),

              const SizedBox(height: 8),

              _footerText(
                'By: ${request.requestedBy}',
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _footerText(
                  'Requested: ${request.requestedDate}',
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _footerText(
                    'By: ${request.requestedBy}',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TYPE BADGE
  // ============================================================

  Widget _typeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FA),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        type,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xFF34568A),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'COMPLETED':
        backgroundColor = const Color(0xFFD9F2E8);
        textColor = const Color(0xFF286D59);
        break;

      case 'PENDING':
        backgroundColor = const Color(0xFFFFF1D2);
        textColor = const Color(0xFF94631C);
        break;

      case 'REJECTED':
        backgroundColor = const Color(0xFFFFE1E1);
        textColor = const Color(0xFFC83A3A);
        break;

      default:
        backgroundColor = const Color(0xFFE9EDF3);
        textColor = const Color(0xFF667085);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ============================================================
  // FOOTER TEXT
  // ============================================================

  Widget _footerText(String text) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF71819B),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ============================================================
  // APPROVE REQUEST
  // ============================================================

  void _approveRequest(SelfServiceRequest request) {
    setState(() {
      request.status = 'COMPLETED';

      request.resolution =
      'HR Resolution: Request approved and successfully fulfilled.';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Request approved successfully.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // NEW REQUEST DIALOG
  // ============================================================

  void _showNewRequestDialog() {
    String selectedType = 'SALARY CERTIFICATE';

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'New Self-Service Request',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),

              content: SizedBox(
                width: 450,

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ==================================================
                      // REQUEST TYPE
                      // ==================================================

                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: InputDecoration(
                          labelText: 'Request Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'SALARY CERTIFICATE',
                            child: Text(
                              'Salary Certificate',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'ATTENDANCE CORRECTION',
                            child: Text(
                              'Attendance Correction',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'EXPERIENCE LETTER',
                            child: Text(
                              'Experience Letter',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'EXPENSE REIMBURSEMENT',
                            child: Text(
                              'Expense Reimbursement',
                            ),
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

                      const SizedBox(height: 16),

                      // ==================================================
                      // TITLE
                      // ==================================================

                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Request Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ==================================================
                      // DESCRIPTION
                      // ==================================================

                      TextField(
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==========================================================
              // ACTIONS
              // ==========================================================

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      requests.add(
                        SelfServiceRequest(
                          type: selectedType,
                          title: titleController.text.trim(),
                          description:
                          descriptionController.text.trim(),
                          status: 'PENDING',
                          requestedDate: DateTime.now()
                              .toString()
                              .split(' ')
                              .first,
                          requestedBy: 'Current User',
                          resolution: '',
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'New request created successfully.',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF347DD4),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Create Request',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ============================================================
// MODEL
// ============================================================

class SelfServiceRequest {
  String type;
  String title;
  String description;
  String status;
  String requestedDate;
  String requestedBy;
  String resolution;

  SelfServiceRequest({
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    required this.requestedDate,
    required this.requestedBy,
    required this.resolution,
  });
}