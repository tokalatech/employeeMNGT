import 'package:flutter/material.dart';

import '../models/payslip_model.dart';
import '../services/payslip_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_card.dart';
import 'payslip_details_screen.dart';

class PayslipsScreen extends StatelessWidget {
  const PayslipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payslipService = PayslipService();

    return StreamBuilder<List<Payslip>>(
      stream: payslipService.watchMyPayslips(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load payslips',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        final payslips = snapshot.data ?? [];

        if (payslips.isEmpty) {
          return const Center(
            child: Text(
              'No payslips available',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        final latestPayslip = payslips.first;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _LatestPayslipCard(
              payslip: latestPayslip,
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

            ...payslips.map(
                  (payslip) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _PayslipHistoryCard(
                  payslip: payslip,
                  onTap: () => _detail(context, payslip),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _detail(BuildContext context, Payslip payslip) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${payslip.month} ${payslip.year} Payslip',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Gross earnings  ${_formatAmount(payslip.grossSalary)}',
              ),

              Text(
                'Deductions  ${_formatAmount(payslip.totalDeductions)}',
              ),

              const Divider(),

              Text(
                'Net salary  ${_formatAmount(payslip.netSalary)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 12),

              PrimaryButton(
                label: 'Download Payslip',
                icon: Icons.download,
                onPressed: () {
                  Navigator.pop(bottomSheetContext);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PayslipDetailsScreen(
                        payslip: payslip,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatAmount(double amount) {
    return '\${amount.toStringAsFixed(2)}';
  }
}

class _LatestPayslipCard extends StatelessWidget {
  const _LatestPayslipCard({
    required this.payslip,
  });

  final Payslip payslip;

  @override
  Widget build(BuildContext context) {
    return PulseCard(
      color: AppColors.navy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LATEST PAYSLIP',
            style: TextStyle(
              color: Color(0xFFC7D2FE),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            '₹${payslip.netSalary.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.w900,
            ),
          ),

          Text(
            '${payslip.month} ${payslip.year} · Net salary',
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayslipHistoryCard extends StatelessWidget {
  const _PayslipHistoryCard({
    required this.payslip,
    required this.onTap,
  });

  final Payslip payslip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PulseCard(
      onTap: onTap,
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
          '${payslip.month} ${payslip.year}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),

        subtitle: Text(
          'Net salary: \${payslip.netSalary.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 11,
          ),
        ),

        trailing: const Icon(
          Icons.download_outlined,
        ),
      ),
    );
  }
}