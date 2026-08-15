import 'flow_detail_screen.dart';
import '../models/payslip_model.dart';

class PayslipDetailsScreen extends FlowDetailScreen {
  PayslipDetailsScreen({super.key,required Payslip payslip,}) : super(title: 'Payslip Details',
      subtitle: '${payslip.month} ${payslip.year} salary statement',
      action: 'Download PDF',
      sections: [
        (
        'Earnings',
        'Basic ${payslip.earnings.basic.toStringAsFixed(2)} · '
            'HRA ${payslip.earnings.hra.toStringAsFixed(2)} · '
            'Transport ${payslip.earnings.transport.toStringAsFixed(2)} · '
            'Special Allowance ${payslip.earnings.specialAllowance.toStringAsFixed(2)}',
        ),
        (
        'Deductions',
        'PF ${payslip.deductions.pf.toStringAsFixed(2)} · '
            'Tax ${payslip.deductions.tax.toStringAsFixed(2)} · '
            'Insurance ${payslip.deductions.insurance.toStringAsFixed(2)}',
        ),
        (
        'Net salary',
        payslip.netSalary.toStringAsFixed(2),
        ),
      ],);
}
