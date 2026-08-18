import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/payslip_model.dart';

class PayslipDetailsScreen extends StatelessWidget {
  const PayslipDetailsScreen({
    super.key,
    required this.payslip,
  });

  final Payslip payslip;

  Future<void> _downloadPayslip(BuildContext context) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'PAYSLIP',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 8),

                pw.Text(
                  '${payslip.month} ${payslip.year}',
                  style: const pw.TextStyle(
                    fontSize: 16,
                  ),
                ),

                pw.SizedBox(height: 30),

                pw.Divider(),

                pw.SizedBox(height: 15),

                pw.Text(
                  'EARNINGS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                _pdfRow(
                  'Basic Salary',
                  payslip.earnings.basic,
                ),

                _pdfRow(
                  'HRA',
                  payslip.earnings.hra,
                ),

                _pdfRow(
                  'Transport',
                  payslip.earnings.transport,
                ),

                _pdfRow(
                  'Special Allowance',
                  payslip.earnings.specialAllowance,
                ),

                pw.SizedBox(height: 15),

                pw.Divider(),

                pw.SizedBox(height: 15),

                pw.Text(
                  'DEDUCTIONS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                _pdfRow(
                  'PF',
                  payslip.deductions.pf,
                ),

                _pdfRow(
                  'Tax',
                  payslip.deductions.tax,
                ),

                _pdfRow(
                  'Insurance',
                  payslip.deductions.insurance,
                ),

                pw.SizedBox(height: 15),

                pw.Divider(),

                pw.SizedBox(height: 15),

                _pdfTotalRow(
                  'Gross Salary',
                  payslip.grossSalary,
                ),

                _pdfTotalRow(
                  'Total Deductions',
                  payslip.totalDeductions,
                ),

                pw.SizedBox(height: 10),

                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.grey,
                    ),
                  ),
                  child: _pdfTotalRow(
                    'NET SALARY',
                    payslip.netSalary,
                  ),
                ),

                pw.Spacer(),

                pw.Divider(),

                pw.SizedBox(height: 8),

                pw.Text(
                  'This is a system generated payslip.',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();

      await Printing.sharePdf(
        bytes: bytes,
        filename:
        'Payslip_${payslip.month}_${payslip.year}.pdf',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payslip PDF generated successfully'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to generate payslip PDF: $e',
            ),
          ),
        );
      }
    }
  }

  pw.Widget _pdfRow(
      String label,
      double amount,
      ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text(
            '₹${amount.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfTotalRow(
      String label,
      double amount,
      ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          '₹${amount.toStringAsFixed(2)}',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payslip Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payslip Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${payslip.month} ${payslip.year} salary statement',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _detailRow(
                    'Basic Salary',
                    payslip.earnings.basic,
                  ),

                  _detailRow(
                    'HRA',
                    payslip.earnings.hra,
                  ),

                  _detailRow(
                    'Transport',
                    payslip.earnings.transport,
                  ),

                  _detailRow(
                    'Special Allowance',
                    payslip.earnings.specialAllowance,
                  ),

                  const Divider(height: 30),

                  const Text(
                    'Deductions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _detailRow(
                    'PF',
                    payslip.deductions.pf,
                  ),

                  _detailRow(
                    'Tax',
                    payslip.deductions.tax,
                  ),

                  _detailRow(
                    'Insurance',
                    payslip.deductions.insurance,
                  ),

                  const Divider(height: 30),

                  _detailRow(
                    'Gross Salary',
                    payslip.grossSalary,
                  ),

                  _detailRow(
                    'Total Deductions',
                    payslip.totalDeductions,
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Net Salary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '₹${payslip.netSalary.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _downloadPayslip(context),
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
      String label,
      double amount,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}