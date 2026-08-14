import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button, BottomSheet } from '../common/UIComponents';
import {
  FileText,
  Download,
  Eye,
  Share2,
  DollarSign,
  TrendingUp,
  ShieldCheck,
  Building,
} from 'lucide-react';
import { MOCK_PAYSLIPS } from '../../mockData';
import { Payslip } from '../../types';

export const PayslipsScreen: React.FC = () => {
  const { user } = useApp();
  const [selectedPayslip, setSelectedPayslip] = useState<Payslip | null>(null);
  const [showPdfModal, setShowPdfModal] = useState(false);

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Top Banner */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
            <FileText className="w-5 h-5 text-emerald-600" /> My Payslips
          </h2>
          <p className="text-xs text-slate-500">Confidential payroll & tax statements</p>
        </div>
      </div>

      {/* Latest Salary Card Summary */}
      <Card className="bg-gradient-to-br from-emerald-900 via-teal-900 to-slate-900 text-white p-5 border-0 shadow-xl">
        <div className="flex justify-between items-center mb-2">
          <span className="text-[10px] font-bold uppercase tracking-widest text-emerald-300">
            Latest Disbursed Salary
          </span>
          <StatusBadge status="Paid" size="sm" />
        </div>
        <p className="text-xs text-emerald-100">July 2026 Payroll Statement</p>
        <h1 className="text-3xl font-black text-white mt-1 mb-3">$7,420.00</h1>

        <div className="grid grid-cols-2 gap-2 text-xs pt-3 border-t border-emerald-800/80">
          <div>
            <span className="text-emerald-300 text-[10px] block">Gross Earnings</span>
            <span className="font-bold text-white">$8,800.00</span>
          </div>
          <div>
            <span className="text-emerald-300 text-[10px] block">Total Deductions</span>
            <span className="font-bold text-rose-300">-$1,380.00</span>
          </div>
        </div>
      </Card>

      {/* Payslips List */}
      <div className="space-y-2">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500">
          Payroll History
        </h3>

        {MOCK_PAYSLIPS.map((ps) => (
          <Card
            key={ps.id}
            onClick={() => setSelectedPayslip(ps)}
            className="p-4 flex items-center justify-between"
          >
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-2xl bg-emerald-50 dark:bg-emerald-950/60 flex items-center justify-center text-emerald-600 font-bold text-xs">
                {ps.month.substring(0, 3)}
              </div>
              <div>
                <h4 className="font-bold text-sm text-slate-900 dark:text-white">
                  {ps.month} {ps.year}
                </h4>
                <p className="text-[11px] text-slate-400">Issued on {ps.issueDate}</p>
              </div>
            </div>

            <div className="text-right">
              <span className="font-black text-sm text-slate-900 dark:text-white block">
                ${ps.netSalary.toLocaleString()}
              </span>
              <StatusBadge status={ps.status} size="sm" />
            </div>
          </Card>
        ))}
      </div>

      {/* PAYSLIP DETAIL SHEET */}
      <BottomSheet
        isOpen={!!selectedPayslip}
        onClose={() => setSelectedPayslip(null)}
        title={selectedPayslip ? `${selectedPayslip.month} ${selectedPayslip.year} Payslip` : ''}
      >
        {selectedPayslip && (
          <div className="space-y-4 text-xs">
            {/* Hero Net Amount */}
            <div className="p-4 rounded-2xl bg-gradient-to-r from-[#0F172B] to-[#1E293B] text-white text-center">
              <span className="text-[10px] font-bold uppercase tracking-wider text-emerald-400">
                Net Disbursed Amount
              </span>
              <h2 className="text-3xl font-black text-white my-1">
                ${selectedPayslip.netSalary.toLocaleString()}.00
              </h2>
              <p className="text-[11px] text-slate-300">Direct Deposited • Chase Bank (**** 4892)</p>
            </div>

            {/* Earnings Section */}
            <div className="p-3.5 bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 space-y-2">
              <h4 className="font-bold text-xs text-emerald-700 dark:text-emerald-400 uppercase tracking-wider">
                1. Earnings Breakdown
              </h4>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-800">
                <span className="text-slate-600 dark:text-slate-400">Basic Salary</span>
                <span className="font-bold text-slate-900 dark:text-white">${selectedPayslip.earnings.basic}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-800">
                <span className="text-slate-600 dark:text-slate-400">House Rent Allowance (HRA)</span>
                <span className="font-bold text-slate-900 dark:text-white">${selectedPayslip.earnings.hra}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-800">
                <span className="text-slate-600 dark:text-slate-400">Transport Allowance</span>
                <span className="font-bold text-slate-900 dark:text-white">${selectedPayslip.earnings.transport}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-800">
                <span className="text-slate-600 dark:text-slate-400">Special Allowance</span>
                <span className="font-bold text-slate-900 dark:text-white">${selectedPayslip.earnings.specialAllowance}</span>
              </div>
              <div className="flex justify-between pt-1 font-extrabold text-slate-900 dark:text-white text-sm">
                <span>Gross Salary</span>
                <span className="text-emerald-600">${selectedPayslip.grossSalary}</span>
              </div>
            </div>

            {/* Deductions Section */}
            <div className="p-3.5 bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 space-y-2">
              <h4 className="font-bold text-xs text-rose-600 uppercase tracking-wider">
                2. Deductions
              </h4>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-800">
                <span className="text-slate-600 dark:text-slate-400">Provident Fund (PF)</span>
                <span className="font-bold text-slate-900 dark:text-white">-${selectedPayslip.deductions.pf}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-800">
                <span className="text-slate-600 dark:text-slate-400">Income Tax (TDS)</span>
                <span className="font-bold text-slate-900 dark:text-white">-${selectedPayslip.deductions.tax}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-800">
                <span className="text-slate-600 dark:text-slate-400">Health Insurance Premium</span>
                <span className="font-bold text-slate-900 dark:text-white">-${selectedPayslip.deductions.insurance}</span>
              </div>
              <div className="flex justify-between pt-1 font-extrabold text-rose-600 text-sm">
                <span>Total Deductions</span>
                <span>-${selectedPayslip.totalDeductions}</span>
              </div>
            </div>

            {/* Actions */}
            <div className="grid grid-cols-2 gap-2 pt-2">
              <Button
                variant="outline"
                onClick={() => setShowPdfModal(true)}
              >
                <Eye className="w-4 h-4" /> View PDF
              </Button>
              <Button
                onClick={() => alert(`Downloading Payslip_${selectedPayslip.month}_${selectedPayslip.year}.pdf`)}
              >
                <Download className="w-4 h-4" /> Download PDF
              </Button>
            </div>
          </div>
        )}
      </BottomSheet>

      {/* PDF VIEWER MODAL PREVIEW */}
      {showPdfModal && selectedPayslip && (
        <div className="fixed inset-0 bg-black/80 backdrop-blur-md z-50 flex flex-col p-4">
          <div className="flex justify-between items-center text-white pb-3 border-b border-slate-800">
            <div>
              <h3 className="font-bold text-sm">Official Payslip Document</h3>
              <p className="text-[10px] text-slate-400">
                {selectedPayslip.month} {selectedPayslip.year} • {user.name} ({user.employeeId})
              </p>
            </div>
            <button
              onClick={() => setShowPdfModal(false)}
              className="p-2 rounded-xl bg-slate-800 text-white text-xs font-bold"
            >
              Close
            </button>
          </div>

          <div className="flex-1 bg-white text-slate-900 rounded-2xl my-3 p-6 overflow-y-auto space-y-4 shadow-2xl font-sans text-xs">
            <div className="flex justify-between items-start border-b pb-4">
              <div>
                <h2 className="text-base font-black text-[#4F39F6]">PULSE HRMS ENTERPRISE INC.</h2>
                <p className="text-[10px] text-slate-500">100 Pine Street, San Francisco, CA 94111</p>
              </div>
              <div className="text-right">
                <span className="font-bold text-sm block">PAYSLIP</span>
                <span className="text-[10px] text-slate-500">{selectedPayslip.month} {selectedPayslip.year}</span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4 bg-slate-50 p-3 rounded-xl">
              <div>
                <p className="text-[10px] text-slate-400 font-bold uppercase">Employee Name</p>
                <p className="font-bold text-slate-800">{user.name}</p>
                <p className="text-[10px] text-slate-500">{user.designation}</p>
              </div>
              <div>
                <p className="text-[10px] text-slate-400 font-bold uppercase">Employee ID</p>
                <p className="font-bold text-slate-800">{user.employeeId}</p>
                <p className="text-[10px] text-slate-500">{user.department}</p>
              </div>
            </div>

            <div className="border rounded-xl overflow-hidden">
              <table className="w-full text-left text-xs">
                <thead className="bg-slate-100 font-bold text-slate-700">
                  <tr>
                    <th className="p-2">Earnings</th>
                    <th className="p-2 text-right">Amount</th>
                    <th className="p-2">Deductions</th>
                    <th className="p-2 text-right">Amount</th>
                  </tr>
                </thead>
                <tbody className="divide-y">
                  <tr>
                    <td className="p-2">Basic Salary</td>
                    <td className="p-2 text-right">${selectedPayslip.earnings.basic}</td>
                    <td className="p-2">Provident Fund</td>
                    <td className="p-2 text-right">${selectedPayslip.deductions.pf}</td>
                  </tr>
                  <tr>
                    <td className="p-2">HRA</td>
                    <td className="p-2 text-right">${selectedPayslip.earnings.hra}</td>
                    <td className="p-2">Income Tax</td>
                    <td className="p-2 text-right">${selectedPayslip.deductions.tax}</td>
                  </tr>
                  <tr>
                    <td className="p-2">Transport</td>
                    <td className="p-2 text-right">${selectedPayslip.earnings.transport}</td>
                    <td className="p-2">Insurance</td>
                    <td className="p-2 text-right">${selectedPayslip.deductions.insurance}</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div className="bg-emerald-50 p-3 rounded-xl flex justify-between items-center font-bold text-emerald-900 border border-emerald-200">
              <span>NET SALARY PAYABLE</span>
              <span className="text-base">${selectedPayslip.netSalary.toLocaleString()}.00</span>
            </div>
          </div>

          <Button
            fullWidth
            onClick={() => alert(`Downloading official PDF copy to phone storage`)}
          >
            <Download className="w-4 h-4 mr-1" /> Save PDF to Phone
          </Button>
        </div>
      )}
    </div>
  );
};
