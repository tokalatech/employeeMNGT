import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';

class LeaveItem {
  const LeaveItem({
    required this.type,
    required this.dates,
    required this.days,
    required this.status,
    required this.reason,
    this.attachment,
  });

  final String type, dates, status, reason;
  final int days;
  final String? attachment;
}

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({
    super.key,
    required this.leaves,
    required this.onSubmit,
    this.manager = false,
  });

  final List<LeaveItem> leaves;
  final ValueChanged<LeaveItem> onSubmit;
  final bool manager;

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  String _tab = 'Balances';
  final _approvals = <LeaveItem>[
    const LeaveItem(
      type: 'Casual Leave',
      dates: 'Aug 18 – Aug 19, 2026',
      days: 2,
      status: 'Pending',
      reason: 'Family event',
    ),
    const LeaveItem(
      type: 'Sick Leave',
      dates: 'Aug 14, 2026',
      days: 1,
      status: 'Pending',
      reason: 'Medical rest',
    ),
  ];

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
        ...widget.leaves.map(_leave),
      ] else if (_tab == 'History')
        ...widget.leaves.map(_leave)
      else
        ..._approvals.map(_approval),
    ],
  );

  Widget _tabs() => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children:
          (widget.manager
                  ? ['Balances', 'History', 'Approvals']
                  : ['Balances', 'History'])
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

  Widget _balances() => PulseCard(
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
        Row(
          children: [
            _balance('Paid Leave', 12, 18, AppColors.primary),
            _balance('Casual Leave', 5, 8, AppColors.warning),
            _balance('Sick Leave', 7, 10, AppColors.success),
          ],
        ),
      ],
    ),
  );

  Widget _balance(String t, int left, int total, Color color) => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          Text('$left days left', style: const TextStyle(fontSize: 10)),
          const SizedBox(height: 7),
          LinearProgressIndicator(
            value: left / total,
            color: color,
            minHeight: 6,
          ),
        ],
      ),
    ),
  );

  Widget _leave(LeaveItem item) => Padding(
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
          item.type,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${item.dates} · ${item.days} days',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: Text(
          item.status,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: item.status == 'Approved'
                ? AppColors.success
                : item.status == 'Rejected'
                ? AppColors.danger
                : AppColors.warning,
          ),
        ),
      ),
    ),
  );

  Widget _approval(LeaveItem item) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: PulseCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Text('TM')),
            title: Text(
              item.type,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              '${item.dates}\n${item.reason}',
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

  void _review(LeaveItem item, bool approved) {
    setState(() => _approvals.remove(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Leave request ${approved ? 'approved' : 'rejected'}'),
      ),
    );
  }

  void _details(LeaveItem item) => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.type,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Text(item.dates),
          Text('${item.days} days · ${item.status}'),
          const SizedBox(height: 8),
          Text(item.reason),
          if (item.attachment != null)
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.attachment),
              label: Text(item.attachment!),
            ),
          if (item.status == 'Pending')
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
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
                    : () {
                        final r = range!;
                        widget.onSubmit(
                          LeaveItem(
                            type: type,
                            dates:
                                '${r.start.day}/${r.start.month}/${r.start.year} – ${r.end.day}/${r.end.month}/${r.end.year}',
                            days: r.duration.inDays + 1,
                            status: 'Pending',
                            reason: reason.text.trim(),
                            attachment: attachment
                                ? 'supporting_document.pdf'
                                : null,
                          ),
                        );
                        Navigator.pop(sheet);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
