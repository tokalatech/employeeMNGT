import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button, BottomSheet, Input } from '../common/UIComponents';
import { Send, Plus, CheckCircle2, Clock, FileText, ChevronRight } from 'lucide-react';
import { SelfServiceRequest } from '../../types';

export const RequestsScreen: React.FC = () => {
  const { requests, createSelfServiceRequest } = useApp();

  const [showCreateSheet, setShowCreateSheet] = useState(false);
  const [selectedReq, setSelectedReq] = useState<SelfServiceRequest | null>(null);

  // Form state
  const [requestType, setRequestType] = useState<SelfServiceRequest['requestType']>('Employment Certificate');
  const [description, setDescription] = useState('');

  const handleCreateSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!description) return;
    createSelfServiceRequest(requestType, description);
    setShowCreateSheet(false);
    setDescription('');
  };

  return (
    <div className="p-4 space-y-4 pb-20">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
            <Send className="w-5 h-5 text-purple-600" /> Self-Service Requests
          </h2>
          <p className="text-xs text-slate-500">Employment letters, address & bank updates</p>
        </div>
        <Button size="sm" onClick={() => setShowCreateSheet(true)}>
          <Plus className="w-4 h-4" /> New Request
        </Button>
      </div>

      <div className="space-y-2">
        {requests.map((req) => (
          <Card
            key={req.id}
            onClick={() => setSelectedReq(req)}
            className="p-3.5 space-y-2"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-slate-900 dark:text-white">{req.requestType}</span>
              <StatusBadge status={req.status} />
            </div>

            <p className="text-xs text-slate-500 line-clamp-2">{req.description}</p>

            <div className="flex justify-between items-center text-[10px] text-slate-400 pt-2 border-t border-slate-100 dark:border-slate-800">
              <span>Submitted: {req.appliedDate}</span>
              <span className="text-[#4F39F6] font-bold">Details →</span>
            </div>
          </Card>
        ))}
      </div>

      <BottomSheet
        isOpen={showCreateSheet}
        onClose={() => setShowCreateSheet(false)}
        title="Submit Self-Service Request"
      >
        <form onSubmit={handleCreateSubmit} className="space-y-4">
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500">
              Request Type
            </label>
            <select
              value={requestType}
              onChange={(e) => setRequestType(e.target.value as any)}
              className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-3 text-sm text-slate-900 dark:text-slate-100"
            >
              <option value="Employment Certificate">Employment Confirmation Certificate</option>
              <option value="Attendance Correction">Attendance Punch Correction</option>
              <option value="Document Request">HR Document / Tax Request</option>
              <option value="Profile Update">Profile Address / Emergency Contact</option>
              <option value="Bank Detail Change">Bank Account & Direct Deposit</option>
            </select>
          </div>

          <div className="space-y-1.5">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500">
              Reason / Additional Details
            </label>
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              required
              rows={4}
              placeholder="State clear purpose for HR processing..."
              className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-3 text-sm text-slate-900 dark:text-slate-100"
            />
          </div>

          <Button fullWidth size="lg">
            <Send className="w-4 h-4 mr-1" /> Submit Request
          </Button>
        </form>
      </BottomSheet>

      <BottomSheet
        isOpen={!!selectedReq}
        onClose={() => setSelectedReq(null)}
        title={selectedReq ? selectedReq.requestType : ''}
      >
        {selectedReq && (
          <div className="space-y-4 text-xs">
            <div className="flex justify-between items-center p-3 rounded-xl bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
              <div>
                <span className="text-[10px] text-slate-400 font-bold uppercase">Status</span>
                <p className="font-bold text-slate-900 dark:text-white mt-0.5">{selectedReq.status}</p>
              </div>
              <StatusBadge status={selectedReq.status} size="md" />
            </div>

            <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 space-y-1">
              <span className="text-[10px] text-slate-400 font-bold uppercase">Description</span>
              <p className="text-slate-800 dark:text-slate-200">{selectedReq.description}</p>
            </div>

            {selectedReq.comments && (
              <div className="p-3 bg-emerald-50 dark:bg-emerald-950/40 rounded-xl border border-emerald-200 dark:border-emerald-900">
                <span className="font-bold text-emerald-700">HR Resolution Note:</span>
                <p className="text-slate-700 dark:text-slate-300 mt-0.5">{selectedReq.comments}</p>
              </div>
            )}
          </div>
        )}
      </BottomSheet>
    </div>
  );
};
