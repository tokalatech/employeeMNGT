import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import '../models/leave_model.dart';
import '../services/leave_service.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key, this.manager = false});

  final bool manager;

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final _leaveService = LeaveService();
  final _userService = UserService();
  late String _tab;
  late final Stream<List<LeaveBalance>> _balancesStream;
  late final Stream<List<LeaveRequest>> _leavesStream;
  late final Stream<List<LeaveRequest>> _approvalsStream;

  @override
  void initState() {
    super.initState();
    _tab = 'Balances';
    _balancesStream = _leaveService.watchMyLeaveBalances();
    _leavesStream = _leaveService.watchMyLeaves();
    _approvalsStream = _leaveService.watchPendingApprovals();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              'LEAVE MANAGEMENT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _apply,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Apply Leave'),
          ),
        ],
      ),
      const SizedBox(height: 8),
      _tabs(),
      const SizedBox(height: 14),
      if (_tab == 'Balances') ...[
        _balances(),
        const SizedBox(height: 15),
        _history(),
      ] else if (_tab == 'History')
        _history()
      else
        _approvals(),
    ],
  );

  Widget _tabs() => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: ['Balances', 'History', if (widget.manager) 'Approvals']
          .map(
            (x) => Expanded(
              child: TextButton(
                onPressed: () => setState(() => _tab = x),
                style: TextButton.styleFrom(
                  backgroundColor: _tab == x
                      ? Theme.of(context).colorScheme.surface
                      : null,
                ),
                child: Text(
                  x,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _tab == x ? AppColors.primary : null,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _balances() => StreamBuilder<List<LeaveBalance>>(
    key: const ValueKey('balances_stream'),
    stream: _balancesStream,
    builder: (context, snap) {
      if (snap.hasError) {
        return _loadError('leave balances', snap.error);
      }
      if (snap.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      final balances = snap.data ?? const [];
      if (balances.isEmpty) {
        return const PulseCard(child: Text('No leave balances found.'));
      }
      return PulseCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YOUR LEAVE BALANCE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 13),
            Row(children: balances.map(_balance).toList()),
          ],
        ),
      );
    },
  );

  Widget _balance(LeaveBalance b) => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            leaveTypeToString(b.type),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          Text(
            '${b.remaining} days left',
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(height: 7),
          LinearProgressIndicator(
            value: b.total == 0 ? 0 : b.remaining / b.total,
            color: _balanceColor(b.color),
            minHeight: 6,
          ),
        ],
      ),
    ),
  );

  // Parses a "#RRGGBB" hex string from Firestore into a Color.
  // Falls back to a default so a malformed value never crashes the UI.
  Color _balanceColor(String hex) {
    try {
      final clean = hex.replaceFirst('#', '').padLeft(6, '0');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  Widget _history() => StreamBuilder<List<LeaveRequest>>(
    key: const ValueKey('history_stream'),
    stream: _leavesStream,
    builder: (context, snap) {
      if (snap.hasError) {
        return _loadError('leave history', snap.error);
      }
      if (snap.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      final leaves = snap.data ?? const [];
      if (leaves.isEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(child: Text('No leave requests yet.')),
        );
      }
      return Column(children: leaves.map(_leave).toList());
    },
  );

  Widget _leave(LeaveRequest item) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: PulseCard(
      onTap: () => _details(item),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE0E7FF),
          child: Icon(Icons.event_note, color: AppColors.primary),
        ),
        title: Text(
          leaveTypeToString(item.leaveType),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${item.startDate} – ${item.endDate} · ${item.totalDays} days',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: Text(
          leaveRequestStatusToString(item.status),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: item.status == LeaveRequestStatus.approved
                ? AppColors.success
                : item.status == LeaveRequestStatus.rejected
                ? AppColors.danger
                : AppColors.warning,
          ),
        ),
      ),
    ),
  );

  Widget _approvals() => StreamBuilder<List<LeaveRequest>>(
    key: const ValueKey('approvals_stream'),
    stream: _approvalsStream,
    builder: (context, snap) {
      if (snap.hasError) {
        return _loadError('leave approvals', snap.error);
      }
      if (snap.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      final pending = snap.data ?? const [];
      if (pending.isEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(child: Text('No pending approvals.')),
        );
      }
      return Column(children: pending.map(_approval).toList());
    },
  );

  Widget _loadError(String section, Object? error) => PulseCard(
    child: Text(
      'Unable to load $section. ${error ?? 'Please try again.'}',
      style: const TextStyle(fontSize: 12),
    ),
  );

  Widget _approval(LeaveRequest item) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: PulseCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Text(_initials(item.employeeName))),
            title: Text(
              leaveTypeToString(item.leaveType),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              '${item.startDate} – ${item.endDate}\n${item.reason}',
              style: const TextStyle(fontSize: 11),
              maxLines: 2,
            ),
            isThreeLine: true,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _review(item, false),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () => _review(item, true),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  void _review(LeaveRequest r, bool approved) async {
    try {
      if (approved) {
        await _leaveService.approveLeave(r.id);
      } else {
        await _leaveService.rejectLeave(r.id, reason: 'Rejected by manager');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Leave request ${approved ? 'approved' : 'rejected'}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to review request: $e')));
    }
  }

  void _details(LeaveRequest item) => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            leaveTypeToString(item.leaveType),
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Text('${item.startDate} – ${item.endDate}'),
          Text(
            '${item.totalDays} days · ${leaveRequestStatusToString(item.status)}',
          ),
          const SizedBox(height: 8),
          Text(item.reason),
          if (item.attachmentName != null)
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.attachment),
              label: Text(item.attachmentName!),
            ),
          if (item.status == LeaveRequestStatus.pending)
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(sheetContext);
                try {
                  await _leaveService.cancelLeave(item.id);
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to cancel request: $e')),
                  );
                }
              },
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Cancel Request'),
            ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );

  void _apply() {
    String type = 'Paid Leave';
    DateTimeRange? range;
    bool attachment = false;
    final reason = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20 + MediaQuery.of(sheet).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (sheet, setSheet) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Apply for Leave',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: type,
                items:
                    const [
                          'Paid Leave',
                          'Casual Leave',
                          'Sick Leave',
                          'Maternity/Paternity',
                        ]
                        .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                        .toList(),
                onChanged: (x) => setSheet(() => type = x!),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  final selected = await showDateRangePicker(
                    context: sheet,
                    firstDate: DateTime(2026),
                    lastDate: DateTime(2027),
                  );
                  if (selected != null) setSheet(() => range = selected);
                },
                icon: const Icon(Icons.date_range),
                label: Text(
                  range == null
                      ? 'Select leave dates'
                      : '${range!.start.day}/${range!.start.month} – ${range!.end.day}/${range!.end.month}',
                ),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: attachment,
                onChanged: (x) => setSheet(() => attachment = x ?? false),
                title: const Text(
                  'Attach supporting document',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              TextField(
                controller: reason,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: 'Submit Leave Request',
                icon: Icons.send,
                onPressed: range == null || reason.text.trim().isEmpty
                    ? null
                    : () async {
                        final r = range!;
                        try {
                          final UserModel? profile = await _userService
                              .getCurrentUser();
                          if (profile == null) {
                            if (!sheet.mounted) return;
                            ScaffoldMessenger.of(sheet).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Could not load your profile. Please try again.',
                                ),
                              ),
                            );
                            return;
                          }
                          await _leaveService.applyLeave(
                            LeaveRequest(
                              id: '',
                              employeeId:
                                  '', // filled server-side by LeaveService from _uid
                              employeeName: profile.name,
                              employeeAvatar: profile.avatar,
                              department: profile.department,
                              leaveType: leaveTypeFromString(type),
                              startDate: r.start.toIso8601String(),
                              endDate: r.end.toIso8601String(),
                              totalDays: r.duration.inDays + 1,
                              reason: reason.text.trim(),
                              attachmentName: attachment
                                  ? 'supporting_document.pdf'
                                  : null,
                              status: LeaveRequestStatus.pending,
                              appliedDate: '',
                            ),
                          );
                          if (sheet.mounted) Navigator.pop(sheet);
                        } catch (e) {
                          print('applyLeave failed: $e');
                          if (!sheet.mounted) return;
                          ScaffoldMessenger.of(sheet).showSnackBar(
                            SnackBar(
                              content: Text('Failed to submit request: $e'),
                            ),
                          );
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
