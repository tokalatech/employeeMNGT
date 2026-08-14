import 'flow_detail_screen.dart';

class PayslipDetailsScreen extends FlowDetailScreen {
  const PayslipDetailsScreen({super.key}) : super(title: 'Payslip Details',
      subtitle: 'July 2026 salary statement',
      action: 'Download PDF',
      sections: const [
        ('Earnings', 'Basic 5,200 · HRA 1,600 · Allowances 2,000'),
        ('Deductions', 'PF 480 · Tax 700 · Insurance 200'),
        ('Net salary', '7,420.00')
      ]);
}
