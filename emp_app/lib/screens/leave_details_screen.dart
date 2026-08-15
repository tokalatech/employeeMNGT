import 'package:flutter/material.dart';
import 'flow_detail_screen.dart';
import '../models/leave_model.dart';
import '../services/leave_service.dart';

class LeaveDetailsScreen extends StatelessWidget {
  const LeaveDetailsScreen({super.key, required this.leaveId});

  final String leaveId;

  @override
  Widget build(BuildContext context) {
    final leaveService = LeaveService();
    return StreamBuilder<List<LeaveRequest>>(
      stream: leaveService.watchMyLeaves(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }
        final leaves = snap.data ?? const [];
        LeaveRequest? leave;
        for (final l in leaves) {
          if (l.id == leaveId) {
            leave = l;
            break;
          }
        }
        if (leave == null) {
          return const Scaffold(body: Center(child: Text('Leave request not found.')));
        }

        final match = leave; // promoted non-null local
        final isPending = match.status == LeaveRequestStatus.pending;

        return FlowDetailScreen(
          title: 'Leave Request Details',
          subtitle:
          '${leaveTypeToString(match.leaveType)} · ${leaveRequestStatusToString(match.status)}',
          action: isPending ? 'Cancel request' : leaveRequestStatusToString(match.status),
          actionEnabled: isPending,
          sections: [
            ('Dates', '${match.startDate} – ${match.endDate} · ${match.totalDays} days'),
            ('Reason', match.reason),
            ('Approval status', _approvalStatusText(match)),
          ],
          onAction: isPending
              ? () async {
            try {
              await leaveService.cancelLeave(match.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Leave request cancelled.')),
                );
                Navigator.pop(context);
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to cancel request: $e')),
                );
              }
            }
          }
              : null,
        );
      },
    );
  }

  String _approvalStatusText(LeaveRequest leave) {
    switch (leave.status) {
      case LeaveRequestStatus.pending:
        return 'Awaiting manager review';
      case LeaveRequestStatus.approved:
        return leave.reviewedBy != null
            ? 'Approved by ${leave.reviewedBy}'
            : 'Approved';
      case LeaveRequestStatus.rejected:
        return leave.rejectionReason != null
            ? 'Rejected: ${leave.rejectionReason}'
            : 'Rejected';
      case LeaveRequestStatus.cancelled:
        return 'Cancelled';
    }
  }
}