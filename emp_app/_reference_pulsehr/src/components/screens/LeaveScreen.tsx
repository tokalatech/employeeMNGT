import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button, BottomSheet, Input, DialogModal } from '../common/UIComponents';
import {
  CalendarDays,
  Plus,
  Send,
  FileText,
  Clock,
  CheckCircle2,
  XCircle,
  Paperclip,
  Trash2,
  AlertCircle,
} from 'lucide-react';
import { LeaveRequest, LeaveType } from '../../types';

export const LeaveScreen: React.FC = () => {
  const { leaveBalances, leaveRequests, applyLeave, cancelLeave } = useApp();

  const [activeTab, setActiveTab] = useState<'balances' | 'history'>('balances');
  const [showApplySheet, setShowApplySheet] = useState(false);
  const [selectedLeave, setSelectedLeave] = useState<LeaveRequest | null>(null);
  const [cancelTargetId, setCancelTargetId] = useState<string | null>(null);

  // Apply Leave Form state
  const [leaveType, setLeaveType] = useState<LeaveType>('Paid Leave');
  const [startDate, setStartDate] = useState('2026-08-25');
  const [endDate, setEndDate] = useState('2026-08-28');
  const [reason, setReason] = useState('');
  const [attachment, setAttachment] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Calculate total days automatically
  const calcDays = () => {
    const s = new Date(startDate);
    const e = new Date(endDate);
    const diffTime = Math.abs(e.getTime() - s.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
    return isNaN(diffDays) ? 1 : diffDays;
  };

  const handleApplySubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!reason) return;
    setIsSubmitting(true);

    setTimeout(() => {
      applyLeave({
        leaveType,
        startDate,
        endDate,
        totalDays: calcDays(),
        reason,
        attachmentName: attachment || undefined,
      });
      setIsSubmitting(false);
      setShowApplySheet(false);
      setReason('');
      setAttachment(null);
    }, 600);
  };

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Top Floating Apply Action Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
          <CalendarDays className="w-5 h-5 text-[#4F39F6]" /> Leave Management
        </h2>
        <Button size="sm" onClick={() => setShowApplySheet(true)}>
          <Plus className="w-4 h-4" /> Apply Leave
        </Button>
      </div>

      {/* Tabs */}
      <div className="flex bg-slate-100 dark:bg-slate-900 p-1 rounded-2xl border border-slate-200 dark:border-slate-800">
        <button
          onClick={() => setActiveTab('balances')}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            activeTab === 'balances'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500'
          }`}
        >
          Balances & Stats
        </button>
        <button
          onClick={() => setActiveTab('history')}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            activeTab === 'history'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500'
          }`}
        >
          My Applications ({leaveRequests.length})
        </button>
      </div>

      {/* BALANCES TAB */}
      {activeTab === 'balances' && (
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-3">
            {leaveBalances.map((bal) => (
              <Card key={bal.type} className="p-3.5 space-y-2">
                <div className="flex justify-between items-start">
                  <span className="text-xs font-bold text-slate-900 dark:text-slate-100">{bal.type}</span>
                  <span
                    className="w-3 h-3 rounded-full"
                    style={{ backgroundColor: bal.color }}
                  />
                </div>
                <div>
                  <h3 className="text-2xl font-black text-slate-900 dark:text-white">
                    {bal.remaining}{' '}
                    <span className="text-xs font-medium text-slate-400">Available</span>
                  </h3>
                  <p className="text-[11px] text-slate-500">
                    Used: {bal.used} / Total: {bal.total}
                  </p>
                </div>
                <div className="w-full bg-slate-100 dark:bg-slate-800 h-2 rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full"
                    style={{
                      width: `${(bal.remaining / bal.total) * 100}%`,
                      backgroundColor: bal.color,
                    }}
                  />
                </div>
              </Card>
            ))}
          </div>

          {/* Quick Recent Applications Preview */}
          <div className="space-y-2 pt-2">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500">
              Recent Leave Requests
            </h3>
            {leaveRequests.slice(0, 3).map((req) => (
              <Card
                key={req.id}
                onClick={() => setSelectedLeave(req)}
                className="p-3 flex items-center justify-between"
              >
                <div>
                  <div className="flex items-center gap-2">
                    <h4 className="text-xs font-bold text-slate-900 dark:text-slate-100">{req.leaveType}</h4>
                    <StatusBadge status={req.status} />
                  </div>
                  <p className="text-[11px] text-slate-500 mt-1">
                    {req.startDate} to {req.endDate} ({req.totalDays} day{req.totalDays > 1 ? 's' : ''})
                  </p>
                </div>
                <span className="text-xs font-semibold text-slate-400">{req.appliedDate}</span>
              </Card>
            ))}
          </div>
        </div>
      )}

      {/* HISTORY TAB */}
      {activeTab === 'history' && (
        <div className="space-y-3">
          {leaveRequests.length === 0 ? (
            <div className="p-8 text-center text-slate-400 bg-white dark:bg-[#131C2E] rounded-2xl border border-slate-200 dark:border-slate-800">
              <CalendarDays className="w-8 h-8 mx-auto mb-2 text-slate-300" />
              <p className="text-sm font-bold">No leave applications found</p>
              <p className="text-xs mt-0.5">Apply for leave using the top button</p>
            </div>
          ) : (
            leaveRequests.map((req) => (
              <Card key={req.id} onClick={() => setSelectedLeave(req)} className="p-3.5 space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-slate-900 dark:text-white">{req.leaveType}</span>
                  <StatusBadge status={req.status} />
                </div>

                <p className="text-xs font-semibold text-slate-700 dark:text-slate-300">
                  📅 {req.startDate} → {req.endDate} ({req.totalDays} days)
                </p>

                <p className="text-xs text-slate-500 dark:text-slate-400 line-clamp-2 italic">
                  "{req.reason}"
                </p>

                <div className="pt-2 border-t border-slate-100 dark:border-slate-800/80 flex items-center justify-between text-[11px] text-slate-400">
                  <span>Applied: {req.appliedDate}</span>
                  {req.status === 'Pending' && (
                    <button
                      type="button"
                      onClick={(e) => {
                        e.stopPropagation();
                        setCancelTargetId(req.id);
                      }}
                      className="text-rose-600 dark:text-rose-400 font-bold hover:underline flex items-center gap-1"
                    >
                      <Trash2 className="w-3 h-3" /> Cancel
                    </button>
                  )}
                </div>
              </Card>
            ))
          )}
        </div>
      )}

      {/* APPLY LEAVE SHEET */}
      <BottomSheet
        isOpen={showApplySheet}
        onClose={() => setShowApplySheet(false)}
        title="Apply For Leave"
      >
        <form onSubmit={handleApplySubmit} className="space-y-4">
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500">
              Leave Category
            </label>
            <select
              value={leaveType}
              onChange={(e) => setLeaveType(e.target.value as LeaveType)}
              className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-3 text-sm text-slate-900 dark:text-slate-100"
            >
              <option value="Paid Leave">Paid Leave (12 Available)</option>
              <option value="Casual Leave">Casual Leave (7 Available)</option>
              <option value="Sick Leave">Sick Leave (10 Available)</option>
              <option value="Maternity/Paternity">Maternity / Paternity Leave</option>
            </select>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <Input
              label="Start Date"
              type="date"
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
            />
            <Input
              label="End Date"
              type="date"
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
            />
          </div>

          <div className="p-3 bg-indigo-50 dark:bg-indigo-950/40 rounded-xl border border-indigo-200 dark:border-indigo-900 flex justify-between items-center text-xs">
            <span className="font-semibold text-slate-700 dark:text-slate-300">Total Duration:</span>
            <span className="font-black text-[#4F39F6] dark:text-indigo-300 text-sm">{calcDays()} Day(s)</span>
          </div>

          <div className="space-y-1.5">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500">
              Reason for Leave
            </label>
            <textarea
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              required
              rows={3}
              placeholder="State clear reason for manager review..."
              className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-3 text-sm text-slate-900 dark:text-slate-100"
            />
          </div>

          {/* Attachment */}
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500">
              Attachment (Medical / Supporting Document)
            </label>
            <div
              onClick={() => setAttachment('doctor_certificate_note.pdf')}
              className="p-3 border-2 border-dashed border-slate-200 dark:border-slate-800 rounded-xl text-center cursor-pointer hover:border-indigo-400 text-xs text-slate-500"
            >
              <Paperclip className="w-4 h-4 mx-auto mb-1 text-slate-400" />
              {attachment ? (
                <span className="font-bold text-emerald-600">✓ {attachment}</span>
              ) : (
                'Tap to attach doctor note or flight itinerary'
              )}
            </div>
          </div>

          <Button fullWidth size="lg" loading={isSubmitting}>
            <Send className="w-4 h-4 mr-1" /> Submit Leave Application
          </Button>
        </form>
      </BottomSheet>

      {/* LEAVE DETAILS SHEET */}
      <BottomSheet
        isOpen={!!selectedLeave}
        onClose={() => setSelectedLeave(null)}
        title="Leave Application Details"
      >
        {selectedLeave && (
          <div className="space-y-4 text-xs">
            <div className="flex justify-between items-center p-3 rounded-2xl bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
              <div>
                <span className="text-[10px] text-slate-400 font-bold uppercase">Leave Type</span>
                <h4 className="font-bold text-sm text-slate-900 dark:text-white">{selectedLeave.leaveType}</h4>
              </div>
              <StatusBadge status={selectedLeave.status} size="md" />
            </div>

            <div className="grid grid-cols-2 gap-3 text-center">
              <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
                <span className="text-[10px] text-slate-400 font-bold uppercase">Date Range</span>
                <p className="font-bold text-slate-900 dark:text-white mt-0.5">
                  {selectedLeave.startDate} → {selectedLeave.endDate}
                </p>
              </div>
              <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
                <span className="text-[10px] text-slate-400 font-bold uppercase">Total Days</span>
                <p className="font-bold text-slate-900 dark:text-white mt-0.5">{selectedLeave.totalDays} Days</p>
              </div>
            </div>

            <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
              <span className="text-[10px] text-slate-400 font-bold uppercase block mb-1">Reason</span>
              <p className="text-slate-800 dark:text-slate-200">{selectedLeave.reason}</p>
            </div>

            {selectedLeave.attachmentName && (
              <div className="p-3 bg-emerald-50 dark:bg-emerald-950/40 rounded-xl border border-emerald-200 dark:border-emerald-900 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <FileText className="w-4 h-4 text-emerald-600" />
                  <span className="font-semibold text-emerald-900 dark:text-emerald-200">{selectedLeave.attachmentName}</span>
                </div>
                <button
                  onClick={() => alert('Opening attachment viewer...')}
                  className="text-xs font-bold text-emerald-700 underline"
                >
                  View
                </button>
              </div>
            )}

            {selectedLeave.reviewedBy && (
              <div className="p-3 bg-indigo-50 dark:bg-indigo-950/40 rounded-xl border border-indigo-200 dark:border-indigo-900">
                <p className="font-bold text-[#4F39F6]">Reviewed By: {selectedLeave.reviewedBy}</p>
                <p className="text-slate-500 text-[10px]">Reviewed on {selectedLeave.reviewedAt}</p>
                {selectedLeave.rejectionReason && (
                  <p className="text-rose-600 mt-1 font-semibold">Rejection note: "{selectedLeave.rejectionReason}"</p>
                )}
              </div>
            )}

            {selectedLeave.status === 'Pending' && (
              <Button
                fullWidth
                variant="danger"
                onClick={() => {
                  setCancelTargetId(selectedLeave.id);
                  setSelectedLeave(null);
                }}
              >
                <Trash2 className="w-4 h-4 mr-1" /> Cancel Application
              </Button>
            )}
          </div>
        )}
      </BottomSheet>

      {/* CANCEL CONFIRMATION DIALOG */}
      <DialogModal
        isOpen={!!cancelTargetId}
        onClose={() => setCancelTargetId(null)}
        onConfirm={() => {
          if (cancelTargetId) cancelLeave(cancelTargetId);
        }}
        title="Cancel Leave Application?"
        description="Are you sure you want to withdraw this leave request? This action cannot be undone."
        confirmText="Withdraw Request"
        variant="danger"
      />
    </div>
  );
};
