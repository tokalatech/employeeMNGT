import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button, BottomSheet, DialogModal } from '../common/UIComponents';
import {
  CheckSquare,
  CheckCircle2,
  XCircle,
  Calendar,
  User,
  Check,
  X,
  FileText,
  Clock,
  ShieldCheck,
} from 'lucide-react';
import { LeaveRequest } from '../../types';

export const ManagerLeaveApprovalsScreen: React.FC = () => {
  const { leaveRequests, approveLeave, rejectLeave } = useApp();

  const [activeTab, setActiveTab] = useState<'pending' | 'reviewed'>('pending');
  const [selectedRequest, setSelectedRequest] = useState<LeaveRequest | null>(null);

  // Rejection modal
  const [showRejectModal, setShowRejectModal] = useState(false);
  const [rejectReason, setRejectReason] = useState('');
  const [targetRejectId, setTargetRejectId] = useState<string | null>(null);

  const pendingRequests = leaveRequests.filter((r) => r.status === 'Pending');
  const reviewedRequests = leaveRequests.filter((r) => r.status !== 'Pending');

  const handleConfirmReject = () => {
    if (targetRejectId && rejectReason) {
      rejectLeave(targetRejectId, rejectReason);
      setShowRejectModal(false);
      setRejectReason('');
      setTargetRejectId(null);
      setSelectedRequest(null);
    }
  };

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Header Banner */}
      <div className="bg-gradient-to-r from-[#0F172B] to-[#1E293B] text-white p-4 rounded-2xl shadow-md flex items-center justify-between">
        <div>
          <span className="text-[10px] font-bold uppercase tracking-wider text-indigo-300">
            Manager Action Center
          </span>
          <h2 className="text-lg font-black text-white flex items-center gap-1.5">
            <ShieldCheck className="w-5 h-5 text-emerald-400" /> Team Leave Approvals
          </h2>
        </div>
        <div className="bg-rose-500/20 border border-rose-400/40 px-3 py-1 rounded-xl text-center">
          <p className="text-[10px] font-bold text-rose-300 uppercase">Pending</p>
          <p className="text-lg font-black text-white">{pendingRequests.length}</p>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex bg-slate-100 dark:bg-slate-900 p-1 rounded-2xl border border-slate-200 dark:border-slate-800">
        <button
          onClick={() => setActiveTab('pending')}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            activeTab === 'pending'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500'
          }`}
        >
          Pending Requests ({pendingRequests.length})
        </button>
        <button
          onClick={() => setActiveTab('reviewed')}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            activeTab === 'reviewed'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500'
          }`}
        >
          Approval History ({reviewedRequests.length})
        </button>
      </div>

      {/* PENDING TAB */}
      {activeTab === 'pending' && (
        <div className="space-y-3">
          {pendingRequests.length === 0 ? (
            <div className="p-8 text-center bg-white dark:bg-[#131C2E] rounded-2xl border border-slate-200 dark:border-slate-800">
              <CheckCircle2 className="w-10 h-10 text-emerald-500 mx-auto mb-2" />
              <h4 className="font-bold text-base text-slate-900 dark:text-white">All Clear!</h4>
              <p className="text-xs text-slate-500 mt-1">No pending leave requests require your approval.</p>
            </div>
          ) : (
            pendingRequests.map((req) => (
              <Card key={req.id} className="p-4 space-y-3 border-l-4 border-l-amber-500">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2.5">
                    <img
                      src={req.employeeAvatar}
                      alt={req.employeeName}
                      className="w-10 h-10 rounded-full object-cover border border-slate-200"
                    />
                    <div>
                      <h4 className="font-bold text-sm text-slate-900 dark:text-slate-100">{req.employeeName}</h4>
                      <p className="text-[11px] text-slate-500">{req.department}</p>
                    </div>
                  </div>
                  <span className="text-[10px] font-bold text-indigo-600 bg-indigo-50 dark:bg-indigo-950 px-2 py-1 rounded-md">
                    {req.leaveType}
                  </span>
                </div>

                <div className="bg-slate-50 dark:bg-slate-900 p-2.5 rounded-xl border border-slate-100 dark:border-slate-800 text-xs">
                  <div className="flex items-center justify-between font-semibold text-slate-800 dark:text-slate-200 mb-1">
                    <span>📅 {req.startDate} → {req.endDate}</span>
                    <span className="font-black text-[#4F39F6]">{req.totalDays} Days</span>
                  </div>
                  <p className="text-slate-600 dark:text-slate-400 italic line-clamp-2">"{req.reason}"</p>
                </div>

                {req.attachmentName && (
                  <div className="flex items-center gap-1.5 text-xs text-emerald-600 font-semibold">
                    <FileText className="w-3.5 h-3.5" /> Attached: {req.attachmentName}
                  </div>
                )}

                <div className="flex gap-2 pt-1">
                  <Button
                    variant="danger"
                    size="sm"
                    fullWidth
                    onClick={() => {
                      setTargetRejectId(req.id);
                      setShowRejectModal(true);
                    }}
                  >
                    <X className="w-3.5 h-3.5" /> Reject
                  </Button>
                  <Button
                    size="sm"
                    fullWidth
                    onClick={() => approveLeave(req.id)}
                    className="bg-emerald-600 hover:bg-emerald-700 text-white"
                  >
                    <Check className="w-3.5 h-3.5" /> Approve
                  </Button>
                </div>
              </Card>
            ))
          )}
        </div>
      )}

      {/* REVIEWED HISTORY TAB */}
      {activeTab === 'reviewed' && (
        <div className="space-y-3">
          {reviewedRequests.map((req) => (
            <Card key={req.id} onClick={() => setSelectedRequest(req)} className="p-3.5 space-y-2">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <img
                    src={req.employeeAvatar}
                    alt={req.employeeName}
                    className="w-8 h-8 rounded-full object-cover"
                  />
                  <div>
                    <h5 className="font-bold text-xs text-slate-900 dark:text-white">{req.employeeName}</h5>
                    <p className="text-[10px] text-slate-400">{req.leaveType}</p>
                  </div>
                </div>
                <StatusBadge status={req.status} />
              </div>

              <div className="flex items-center justify-between text-xs text-slate-600 dark:text-slate-300 pt-1 border-t border-slate-100 dark:border-slate-800">
                <span>{req.startDate} to {req.endDate} ({req.totalDays} days)</span>
                <span className="text-[10px] text-slate-400">Reviewed {req.reviewedAt}</span>
              </div>
            </Card>
          ))}
        </div>
      )}

      {/* REJECTION REASON MODAL */}
      {showRejectModal && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-xs z-50 flex items-center justify-center p-4">
          <div className="bg-white dark:bg-[#131C2E] rounded-2xl p-5 w-full max-w-sm space-y-4 border border-slate-200 dark:border-slate-800 shadow-2xl">
            <h3 className="font-bold text-base text-slate-900 dark:text-white">Provide Rejection Reason</h3>
            <p className="text-xs text-slate-500">
              Please enter a brief note explaining why this leave request is rejected so the employee is informed.
            </p>
            <textarea
              value={rejectReason}
              onChange={(e) => setRejectReason(e.target.value)}
              placeholder="e.g. High project deliverable workload on requested dates"
              className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-3 text-sm"
              rows={3}
            />
            <div className="flex justify-end gap-2">
              <Button variant="ghost" onClick={() => setShowRejectModal(false)}>
                Cancel
              </Button>
              <Button variant="danger" onClick={handleConfirmReject} disabled={!rejectReason}>
                Confirm Reject
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
