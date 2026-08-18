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
      'Certificate generated and attached to your Documents portal.',
    ),
    SelfServiceRequest(
      type: 'ATTENDANCE CORRECTION',
      title: 'Attendance Punch Correction - Aug 03',
      description:
      'Forgot to clock out due to late client meeting. Check-out time was 07:15 PM.',
      status: 'PENDING',
      requestedDate: '2026-08-04',
      requestedBy: 'Alex Rivera',
    ),
  ];

  void _showNewRequestDialog() {
    String selectedType = 'Salary Certificate';
    final descriptionController = TextEditingController();

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
                'New Self-Service Request',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101A38),
                ),
              ),
              content: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF33466B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F7FB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Salary Certificate',
                          child: Text('Salary Certificate'),
                        ),
                        DropdownMenuItem(
                          value: 'Experience Letter',
                          child: Text('Experience Letter'),
                        ),
                        DropdownMenuItem(
                          value: 'Attendance Correction',
                          child: Text('Attendance Correction'),
                        ),
                        DropdownMenuItem(
                          value: 'Expense Reimbursement',
                          child: Text('Expense Reimbursement'),
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
                    const SizedBox(height: 18),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF33466B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter request details...',
                        filled: true,
                        fillColor: const Color(0xFFF5F7FB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (descriptionController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter request details.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      requests.add(
                        SelfServiceRequest(
                          type: selectedType.toUpperCase(),
                          title: selectedType,
                          description: descriptionController.text.trim(),
                          status: 'PENDING',
                          requestedDate: '2026-08-17',
                          requestedBy: 'Alex Rivera',
                        ),
                      );
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Self-service request submitted successfully.',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2685F5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
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

  void _approveRequest(int index) {
    setState(() {
      requests[index] = SelfServiceRequest(
        type: requests[index].type,
        title: requests[index].title,
        description: requests[index].description,
        status: 'COMPLETED',
        requestedDate: requests[index].requestedDate,
        requestedBy: requests[index].requestedBy,
        resolution: 'Request approved and fulfilled successfully.',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request approved and fulfilled successfully.'),
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
            final bool isMobile = constraints.maxWidth < 700;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 18 : 62,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 32),
                  _buildRequestCards(isMobile),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF284AA2),
            Color(0xFF181C43),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderContent(),
          const SizedBox(height: 24),
          _buildNewRequestButton(),
        ],
      )
          : Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _buildHeaderContent(),
          ),
          const SizedBox(width: 30),
          _buildNewRequestButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF5C9EFF).withOpacity(0.45),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                color: Color(0xFF73B1FF),
                size: 17,
              ),
              SizedBox(width: 8),
              Text(
                'Employee Self-Service Desk',
                style: TextStyle(
                  color: Color(0xFF7DB5FF),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Service Requests & Certificates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Request official salary certificates, experience letters, attendance punch corrections, and expense reimbursements.',
          style: TextStyle(
            color: Color(0xFFE3E8F7),
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildNewRequestButton() {
    return ElevatedButton.icon(
      onPressed: _showNewRequestDialog,
      icon: const Icon(
        Icons.add,
        size: 22,
      ),
      label: const Text(
        'New Self-Service Request',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2685F5),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: const Color(0xFF2685F5).withOpacity(0.35),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildRequestCards(bool isMobile) {
    if (isMobile) {
      return Column(
        children: List.generate(
          requests.length,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _RequestCard(
              request: requests[index],
              onApprove: requests[index].status == 'PENDING'
                  ? () => _approveRequest(index)
                  : null,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 22,
        mainAxisSpacing: 22,
        childAspectRatio: 1.48,
      ),
      itemBuilder: (context, index) {
        return _RequestCard(
          request: requests[index],
          onApprove: requests[index].status == 'PENDING'
              ? () => _approveRequest(index)
              : null,
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  final SelfServiceRequest request;
  final VoidCallback? onApprove;

  const _RequestCard({
    required this.request,
    this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    final bool completed = request.status == 'COMPLETED';

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFDCE3EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF5FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  request.type,
                  style: const TextStyle(
                    color: Color(0xFF1452C8),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Spacer(),
              _StatusBadge(
                status: request.status,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            request.title,
            style: const TextStyle(
              color: Color(0xFF0B1834),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            request.description,
            style: const TextStyle(
              color: Color(0xFF6B819F),
              fontSize: 15,
              height: 1.45,
            ),
          ),
          if (completed && request.resolution != null) ...[
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFB8F2D7),
                ),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF155E4A),
                    fontSize: 14,
                  ),
                  children: [
                    const TextSpan(
                      text: 'HR Resolution: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: request.resolution!,
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (!completed && onApprove != null) ...[
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onApprove,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF08A36D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Approve & Fulfill Request',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
          const Spacer(),
          const SizedBox(height: 18),
          Container(
            height: 1,
            color: const Color(0xFFE7EBF1),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Requested: ${request.requestedDate}',
                style: const TextStyle(
                  color: Color(0xFF8CA0BD),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                'By: ${request.requestedBy}',
                style: const TextStyle(
                  color: Color(0xFF8CA0BD),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool completed = status == 'COMPLETED';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: completed
            ? const Color(0xFFD7F8E9)
            : const Color(0xFFFFF0C9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: completed
              ? const Color(0xFF08744F)
              : const Color(0xFFA45A00),
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class SelfServiceRequest {
  final String type;
  final String title;
  final String description;
  final String status;
  final String requestedDate;
  final String requestedBy;
  final String? resolution;

  SelfServiceRequest({
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    required this.requestedDate,
    required this.requestedBy,
    this.resolution,
  });
}