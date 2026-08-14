import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import 'payslip_details_screen.dart';

class PayslipsScreen extends StatelessWidget {
  const PayslipsScreen({super.key});

  @override
  Widget build(BuildContext c) {
    final data = const [
      ['July', '2026', '7,420', 'Paid'],
      ['June', '2026', '7,420', 'Paid'],
      ['May', '2026', '7,420', 'Paid'],
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PulseCard(
          color: AppColors.navy,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LATEST PAYSLIP',
                style: TextStyle(
                  color: Color(0xFFC7D2FE),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 7),
              Text(
                '\$7,420.00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'July 2026 · Net salary',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        const Text(
          'PAYSLIP HISTORY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 9),
        ...data.map(
          (x) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: PulseCard(
              onTap: () => _detail(c, x),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE6F4EA),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppColors.success,
                  ),
                ),
                title: Text(
                  '${x[0]} ${x[1]}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  'Net salary: \$${x[2]}.00',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: const Icon(Icons.download_outlined),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _detail(BuildContext c, List<String> x) => showModalBottomSheet(
    context: c,
    showDragHandle: true,
    builder: (c) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${x[0]} ${x[1]} Payslip',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
          const SizedBox(height: 12),
          const Text('Gross earnings  \$8,800.00'),
          const Text('Deductions  \$1,380.00'),
          const Divider(),
          Text(
            'Net salary  \$${x[2]}.00',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Download Payslip',
            icon: Icons.download,
            onPressed: () { Navigator.pop(c); Navigator.of(c).push(MaterialPageRoute(builder: (_) => const PayslipDetailsScreen())); },
          ),
        ],
      ),
    ),
  );
}
