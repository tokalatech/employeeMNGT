import 'package:flutter/material.dart';

import '../models/request_model.dart';
import '../services/request_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({
    super.key,
    required this.requestId,
  });

  final String requestId;

  @override
  State<RequestDetailsScreen> createState() =>
      _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  final RequestService _requestService = RequestService();

  late Future<SelfServiceRequest?> _requestFuture;

  @override
  void initState() {
    super.initState();
    _requestFuture = _requestService.getRequestById(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: FutureBuilder<SelfServiceRequest?>(
        future: _requestFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _ErrorView(
              message: 'Unable to load request details.',
              onRetry: _reload,
            );
          }

          final request = snapshot.data;

          if (request == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'This request could not be found.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }

          return _buildDetails(request);
        },
      ),
    );
  }

  Widget _buildDetails(SelfServiceRequest request) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PulseCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFEDE9FE),
                  child: Icon(
                    _requestIcon(request.requestType),
                    color: AppColors.primary,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requestTypeToString(request.requestType),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Applied ${_formatDate(request.appliedDate)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        PulseCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STATUS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(request.status)
                            .withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        requestStatusToString(request.status),
                        style: TextStyle(
                          color: _statusColor(request.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        PulseCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request.description.isEmpty
                      ? 'No description provided.'
                      : request.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (request.comments != null &&
            request.comments!.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          PulseCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'COMMENTS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    request.comments!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        if (request.attachmentName != null &&
            request.attachmentName!.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          PulseCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_file,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ATTACHMENT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          request.attachmentName!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _reload() {
    setState(() {
      _requestFuture =
          _requestService.getRequestById(widget.requestId);
    });
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}