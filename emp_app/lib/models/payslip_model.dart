enum PayslipStatus {
  paid,
  processing,
}

class Payslip {
  final String id;
  final String month;
  final int year;
  final double netSalary;
  final double grossSalary;
  final double totalDeductions;
  final PayslipStatus status;
  final String issueDate;
  final PayslipEarnings earnings;
  final PayslipDeductions deductions;

  Payslip({
    required this.id,
    required this.month,
    required this.year,
    required this.netSalary,
    required this.grossSalary,
    required this.totalDeductions,
    required this.status,
    required this.issueDate,
    required this.earnings,
    required this.deductions,
  });

  factory Payslip.fromMap(Map<String, dynamic> map) {
    return Payslip(
      id: map['id'] ?? '',
      month: map['month'] ?? '',
      year: map['year'] ?? 0,
      netSalary: (map['netSalary'] ?? 0).toDouble(),
      grossSalary: (map['grossSalary'] ?? 0).toDouble(),
      totalDeductions: (map['totalDeductions'] ?? 0).toDouble(),
      status: map['status'] == 'Paid'
          ? PayslipStatus.paid
          : PayslipStatus.processing,
      issueDate: map['issueDate'] ?? '',
      earnings: PayslipEarnings.fromMap(
        Map<String, dynamic>.from(map['earnings'] ?? {}),
      ),
      deductions: PayslipDeductions.fromMap(
        Map<String, dynamic>.from(map['deductions'] ?? {}),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'year': year,
      'netSalary': netSalary,
      'grossSalary': grossSalary,
      'totalDeductions': totalDeductions,
      'status': status == PayslipStatus.paid ? 'Paid' : 'Processing',
      'issueDate': issueDate,
      'earnings': earnings.toMap(),
      'deductions': deductions.toMap(),
    };
  }
}

class PayslipEarnings {
  final double basic;
  final double hra;
  final double transport;
  final double specialAllowance;

  PayslipEarnings({
    required this.basic,
    required this.hra,
    required this.transport,
    required this.specialAllowance,
  });

  factory PayslipEarnings.fromMap(Map<String, dynamic> map) {
    return PayslipEarnings(
      basic: (map['basic'] ?? 0).toDouble(),
      hra: (map['hra'] ?? 0).toDouble(),
      transport: (map['transport'] ?? 0).toDouble(),
      specialAllowance: (map['specialAllowance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'basic': basic,
      'hra': hra,
      'transport': transport,
      'specialAllowance': specialAllowance,
    };
  }
}

class PayslipDeductions {
  final double pf;
  final double tax;
  final double insurance;

  PayslipDeductions({
    required this.pf,
    required this.tax,
    required this.insurance,
  });

  factory PayslipDeductions.fromMap(Map<String, dynamic> map) {
    return PayslipDeductions(
      pf: (map['pf'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
      insurance: (map['insurance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pf': pf,
      'tax': tax,
      'insurance': insurance,
    };
  }
}