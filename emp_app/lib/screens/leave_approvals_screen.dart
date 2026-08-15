import 'package:flutter/material.dart';
import '../widgets/pulse_card.dart';
import '../models/leave_model.dart';
import '../services/leave_service.dart';

class LeaveApprovalsScreen extends StatefulWidget {
  const LeaveApprovalsScreen({super.key, required this.leaveId});

  final String leaveId;

  @override
  State<LeaveApprovalsScreen> createState() => _LeaveApprovalsScreenState();
}

class _LeaveApprovalsScreenState extends State<LeaveApprovalsScreen> {
  final _leaveService = LeaveService();
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LeaveRequest>>(
      stream: _leaveService.watchPendingApprovals(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }

        final pending = snap.data ?? const [];
        LeaveRequest? request;
        for (final r in pending) {
          if (r.id == widget.leaveId) {
            request = r;
            break;
          }
        }

        if (request == null) {
          // Either already reviewed by someone else, or the id is wrong.
          return Scaffold(
            appBar: AppBar(title: const Text('Leave Approvals')),
            body: const Center(child: Text('This request is no longer pending.')),
          );
        }

        final match = request;

        return Scaffold(
          appBar: AppBar(title: const Text('Leave Approvals')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Manager review queue',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              _section('Pending request',
                  '${leaveTypeToString(match.leaveType)} · ${match.startDate} – ${match.endDate}'),
              _section('Employee', match.employeeName),
              _section('Employee note', match.reason),
              _section('Review', 'Approve or reject with a reason'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _submitting ? null : () => _review(match, false),
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _submitting ? null : () => _review(match, true),
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: PulseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    ),
  );

  Future<void> _review(LeaveRequest r, bool approved) async {
    setState(() => _submitting = true);
    try {
      if (approved) {
        await _leaveService.approveLeave(r.id);
      } else {
        await _leaveService.rejectLeave(r.id, reason: 'Rejected by manager');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leave request ${approved ? 'approved' : 'rejected'}')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to review request: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}