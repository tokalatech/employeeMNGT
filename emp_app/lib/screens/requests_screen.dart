import 'package:flutter/material.dart';

import '../models/request_model.dart';
import '../services/request_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import 'request_details_screen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final RequestService _requestService = RequestService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SelfServiceRequest>>(
      stream: _requestService.watchMyRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 42,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unable to load requests',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final requests = snapshot.data ?? [];

        return ListView(
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

            if (requests.isEmpty)
              PulseCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 36,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 42,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No requests yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Create a new self-service request to get started.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ...requests.map(
                  (request) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: PulseCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFEDE9FE),
                      child: Icon(
                        _requestIcon(request.requestType),
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      requestTypeToString(request.requestType),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      'Applied ${_formatDate(request.appliedDate)}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: Text(
                      requestStatusToString(request.status),
                      style: TextStyle(
                        color: _statusColor(request.status),
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RequestDetailsScreen(
                            requestId: request.id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _create() {
    final details = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) {
        SelfServiceRequestType selectedType =
            SelfServiceRequestType.employmentCertificate;

        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
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
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<SelfServiceRequestType>(
                    initialValue: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Request type',
                    ),
                    items: SelfServiceRequestType.values.map((type) {
                      return DropdownMenuItem<SelfServiceRequestType>(
                        value: type,
                        child: Text(
                          requestTypeToString(type),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setSheetState(() {
                        selectedType = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: details,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Request details',
                    ),
                  ),

                  const SizedBox(height: 14),

                  PrimaryButton(
                    label: isSubmitting
                        ? 'Submitting...'
                        : 'Submit Request',
                    icon: Icons.send,
                    onPressed: isSubmitting
                        ? null
                        : () async {
                      if (details.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter request details.',
                            ),
                          ),
                        );
                        return;
                      }

                      setSheetState(() {
                        isSubmitting = true;
                      });

                      try {
                        final request = SelfServiceRequest(
                          id: '',
                          requestType: selectedType,
                          appliedDate:
                          DateTime.now().toIso8601String(),
                          description: details.text.trim(),
                          status:
                          SelfServiceRequestStatus.pending,
                        );

                        await _requestService.createRequest(request);

                        if (!context.mounted) return;

                        Navigator.pop(sheet);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Request submitted successfully.',
                            ),
                          ),
                        );
                      } catch (e) {
                        setSheetState(() {
                          isSubmitting = false;
                        });

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to submit request: $e',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(details.dispose);
  }

  IconData _requestIcon(SelfServiceRequestType type) {
    switch (type) {
      case SelfServiceRequestType.attendanceCorrection:
        return Icons.access_time_outlined;

      case SelfServiceRequestType.employmentCertificate:
        return Icons.badge_outlined;

      case SelfServiceRequestType.documentRequest:
        return Icons.description_outlined;

      case SelfServiceRequestType.profileUpdate:
        return Icons.person_outline;

      case SelfServiceRequestType.bankDetailChange:
        return Icons.account_balance_outlined;
    }
  }

  Color _statusColor(SelfServiceRequestStatus status) {
    switch (status) {
      case SelfServiceRequestStatus.pending:
        return AppColors.warning;

      case SelfServiceRequestStatus.approved:
        return AppColors.success;

      case SelfServiceRequestStatus.completed:
        return AppColors.success;

      case SelfServiceRequestStatus.rejected:
        return Colors.red;
    }
  }

  String _formatDate(String value) {
    if (value.isEmpty) {
      return '-';
    }

    try {
      final date = DateTime.parse(value);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      return '${date.day.toString().padLeft(2, '0')} '
          '${months[date.month - 1]} '
          '${date.year}';
    } catch (_) {
      return value;
    }
  }
}