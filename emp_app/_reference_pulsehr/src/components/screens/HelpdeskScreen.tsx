import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button, BottomSheet, Input } from '../common/UIComponents';
import {
  LifeBuoy,
  Plus,
  Send,
  MessageSquare,
  Clock,
  CheckCircle2,
  Paperclip,
  User,
  Shield,
} from 'lucide-react';
import { HelpdeskTicket } from '../../types';

export const HelpdeskScreen: React.FC = () => {
  const { tickets, createTicket, replyToTicket, user } = useApp();

  const [activeTicket, setActiveTicket] = useState<HelpdeskTicket | null>(null);
  const [showCreateSheet, setShowCreateSheet] = useState(false);

  // New ticket state
  const [subject, setSubject] = useState('');
  const [category, setCategory] = useState<HelpdeskTicket['category']>('IT Support');
  const [priority, setPriority] = useState<HelpdeskTicket['priority']>('Medium');
  const [description, setDescription] = useState('');

  // Reply state
  const [replyText, setReplyText] = useState('');

  const handleCreateSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!subject || !description) return;
    createTicket(subject, category, priority, description);
    setShowCreateSheet(false);
    setSubject('');
    setDescription('');
  };

  const handleSendReply = (e: React.FormEvent) => {
    e.preventDefault();
    if (!replyText || !activeTicket) return;
    replyToTicket(activeTicket.id, replyText);
    setReplyText('');

    // Local refresh
    const updated = tickets.find((t) => t.id === activeTicket.id);
    if (updated) setActiveTicket(updated);
  };

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
            <LifeBuoy className="w-5 h-5 text-rose-500" /> Helpdesk & Support
          </h2>
          <p className="text-xs text-slate-500">Raise IT, HR, or Payroll tickets</p>
        </div>
        <Button size="sm" onClick={() => setShowCreateSheet(true)}>
          <Plus className="w-4 h-4" /> New Ticket
        </Button>
      </div>

      {/* Ticket List */}
      <div className="space-y-2">
        {tickets.map((tk) => (
          <Card
            key={tk.id}
            onClick={() => setActiveTicket(tk)}
            className="p-4 space-y-2"
          >
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="text-[10px] font-mono font-bold bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded-md text-slate-700 dark:text-slate-300">
                  {tk.ticketNumber}
                </span>
                <StatusBadge status={tk.status} />
              </div>
              <span className="text-[10px] text-slate-400">{tk.createdAt}</span>
            </div>

            <h4 className="font-bold text-sm text-slate-900 dark:text-white">{tk.subject}</h4>
            <p className="text-xs text-slate-500 line-clamp-1">{tk.description}</p>

            <div className="flex justify-between items-center text-[11px] text-slate-400 pt-2 border-t border-slate-100 dark:border-slate-800">
              <span>Category: {tk.category}</span>
              <span className="font-semibold text-rose-500">Priority: {tk.priority}</span>
            </div>
          </Card>
        ))}
      </div>

      {/* CREATE TICKET SHEET */}
      <BottomSheet
        isOpen={showCreateSheet}
        onClose={() => setShowCreateSheet(false)}
        title="Raise Helpdesk Support Ticket"
      >
        <form onSubmit={handleCreateSubmit} className="space-y-4">
          <Input
            label="Subject / Short Title"
            value={subject}
            onChange={(e) => setSubject(e.target.value)}
            placeholder="e.g. Need VPN access reset for remote work"
          />

          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500">
                Category
              </label>
              <select
                value={category}
                onChange={(e) => setCategory(e.target.value as any)}
                className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-3 text-sm text-slate-900 dark:text-slate-100"
              >
                <option value="IT Support">IT Support</option>
                <option value="HR Query">HR Query</option>
                <option value="Payroll">Payroll</option>
                <option value="Facilities">Facilities</option>
                <option value="Other">Other</option>
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500">
                Priority
              </label>
              <select
                value={priority}
                onChange={(e) => setPriority(e.target.value as any)}
                className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-3 text-sm text-slate-900 dark:text-slate-100"
              >
                <option value="Low">Low</option>
                <option value="Medium">Medium</option>
                <option value="High">High</option>
                <option value="Urgent">Urgent</option>
              </select>
            </div>
          </div>

          <div className="space-y-1.5">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500">
              Detailed Issue Description
            </label>
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              required
              rows={4}
              placeholder="Explain what happened and steps to reproduce..."
              className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-3 text-sm text-slate-900 dark:text-slate-100"
            />
          </div>

          <Button fullWidth size="lg">
            <Send className="w-4 h-4 mr-1" /> Submit Ticket
          </Button>
        </form>
      </BottomSheet>

      {/* CONVERSATION THREAD MODAL */}
      <BottomSheet
        isOpen={!!activeTicket}
        onClose={() => setActiveTicket(null)}
        title={activeTicket ? `Ticket ${activeTicket.ticketNumber}` : ''}
      >
        {activeTicket && (
          <div className="space-y-4">
            <div className="p-3.5 bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 space-y-1">
              <div className="flex justify-between items-center">
                <StatusBadge status={activeTicket.status} />
                <span className="text-xs text-rose-500 font-bold">{activeTicket.priority} Priority</span>
              </div>
              <h4 className="font-bold text-sm text-slate-900 dark:text-white">{activeTicket.subject}</h4>
            </div>

            {/* Conversation Messages */}
            <div className="space-y-3 max-h-60 overflow-y-auto p-1">
              {activeTicket.messages.map((msg) => (
                <div
                  key={msg.id}
                  className={`flex gap-2.5 ${msg.isStaff ? 'flex-row' : 'flex-row-reverse'}`}
                >
                  <img
                    src={msg.senderAvatar}
                    alt={msg.senderName}
                    className="w-8 h-8 rounded-full object-cover shrink-0"
                  />
                  <div
                    className={`max-w-[80%] p-3 rounded-2xl text-xs space-y-1 ${
                      msg.isStaff
                        ? 'bg-slate-100 dark:bg-slate-800 text-slate-900 dark:text-slate-100 rounded-tl-none'
                        : 'bg-[#4F39F6] text-white rounded-tr-none'
                    }`}
                  >
                    <div className="flex justify-between items-center gap-2 opacity-80 text-[10px]">
                      <span className="font-bold">{msg.senderName}</span>
                      <span>{msg.timestamp}</span>
                    </div>
                    <p>{msg.text}</p>
                  </div>
                </div>
              ))}
            </div>

            {/* Reply Composer */}
            <form onSubmit={handleSendReply} className="flex gap-2 pt-2 border-t border-slate-200 dark:border-slate-800">
              <input
                type="text"
                value={replyText}
                onChange={(e) => setReplyText(e.target.value)}
                placeholder="Type your response..."
                className="flex-1 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white"
              />
              <Button size="sm" type="submit">
                <Send className="w-3.5 h-3.5" />
              </Button>
            </form>
          </div>
        )}
      </BottomSheet>
    </div>
  );
};
