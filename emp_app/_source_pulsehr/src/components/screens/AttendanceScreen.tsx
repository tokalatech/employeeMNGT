import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button, BottomSheet, Input } from '../common/UIComponents';
import {
  Clock,
  Calendar as CalendarIcon,
  ListFilter,
  CheckCircle2,
  AlertCircle,
  FileCheck2,
  Send,
  Play,
  Square,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';
import { AttendanceRecord } from '../../types';

export const AttendanceScreen: React.FC = () => {
  const {
    clockStatus,
    clockInTime,
    clockOutTime,
    liveTimerSeconds,
    handleClockIn,
    handleClockOut,
    attendanceRecords,
    requestAttendanceCorrection,
  } = useApp();

  const [activeTab, setActiveTab] = useState<'today' | 'history' | 'calendar'>('today');
  const [statusFilter, setStatusFilter] = useState<string>('All');
  const [selectedRecord, setSelectedRecord] = useState<AttendanceRecord | null>(null);

  // Attendance Correction state
  const [showCorrectionSheet, setShowCorrectionSheet] = useState(false);
  const [corrDate, setCorrDate] = useState('2026-08-10');
  const [corrIn, setCorrIn] = useState('09:00 AM');
  const [corrOut, setCorrOut] = useState('06:00 PM');
  const [corrReason, setCorrReason] = useState('');
  const [corrSubmitted, setCorrSubmitted] = useState(false);

  const formatTimer = (totalSecs: number) => {
    const hrs = Math.floor(totalSecs / 3600);
    const mins = Math.floor((totalSecs % 3600) / 60);
    const secs = totalSecs % 60;
    return `${hrs.toString().padStart(2, '0')}:${mins
      .toString()
      .padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const filteredHistory = attendanceRecords.filter((rec) => {
    if (statusFilter === 'All') return true;
    return rec.status.toLowerCase() === statusFilter.toLowerCase();
  });

  const handleCorrectionSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!corrReason) return;
    requestAttendanceCorrection(corrDate, corrIn, corrOut, corrReason);
    setCorrSubmitted(true);
    setTimeout(() => {
      setCorrSubmitted(false);
      setShowCorrectionSheet(false);
      setCorrReason('');
    }, 1200);
  };

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Module Tabs Header */}
      <div className="flex bg-slate-100 dark:bg-slate-900 p-1 rounded-2xl border border-slate-200 dark:border-slate-800">
        <button
          onClick={() => setActiveTab('today')}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            activeTab === 'today'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500'
          }`}
        >
          Today Shift
        </button>
        <button
          onClick={() => setActiveTab('history')}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            activeTab === 'history'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500'
          }`}
        >
          History Log
        </button>
        <button
          onClick={() => setActiveTab('calendar')}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            activeTab === 'calendar'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500'
          }`}
        >
          Calendar
        </button>
      </div>

      {/* TODAY SHIFT TAB */}
      {activeTab === 'today' && (
        <div className="space-y-4">
          <Card className="bg-gradient-to-br from-[#0F172B] to-[#1E293B] text-white p-5 border-0 shadow-xl">
            <div className="flex items-center justify-between mb-4">
              <div>
                <span className="text-[10px] font-bold uppercase tracking-widest text-indigo-300">
                  Daily Clock Status
                </span>
                <h3 className="text-lg font-black text-white">
                  {new Date().toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })}
                </h3>
              </div>
              <StatusBadge status={clockStatus} />
            </div>

            {clockStatus === 'Working' ? (
              <div className="py-3 text-center bg-slate-900/60 rounded-2xl border border-slate-800 my-2">
                <p className="text-xs text-indigo-300">Elapsed Working Time</p>
                <h1 className="text-4xl font-black text-white tracking-widest font-mono my-1">
                  {formatTimer(liveTimerSeconds)}
                </h1>
                <p className="text-xs text-emerald-400">Clocked in at {clockInTime}</p>
              </div>
            ) : clockStatus === 'Completed' ? (
              <div className="p-4 bg-emerald-950/40 rounded-2xl border border-emerald-800 text-center my-2">
                <CheckCircle2 className="w-8 h-8 text-emerald-400 mx-auto mb-1" />
                <h4 className="font-bold text-white text-base">Shift Completed</h4>
                <p className="text-xs text-emerald-200">
                  In: {clockInTime} • Out: {clockOutTime} (Total: 8h 32m)
                </p>
              </div>
            ) : (
              <div className="p-4 bg-slate-900/40 rounded-2xl border border-slate-800 text-center my-2">
                <p className="text-xs text-slate-400">Shift Hours: 09:00 AM - 06:00 PM</p>
                <h4 className="font-bold text-white text-base mt-1">Tap Clock In to log start time</h4>
              </div>
            )}

            <div className="mt-4 pt-3 flex gap-2">
              {clockStatus === 'Not Checked In' ? (
                <Button fullWidth size="lg" onClick={handleClockIn} className="bg-emerald-500 hover:bg-emerald-600">
                  <Play className="w-4 h-4 fill-current" /> Clock In
                </Button>
              ) : clockStatus === 'Working' ? (
                <Button fullWidth size="lg" variant="danger" onClick={handleClockOut}>
                  <Square className="w-4 h-4 fill-current" /> Clock Out
                </Button>
              ) : null}
            </div>
          </Card>

          {/* Break & Punch Info */}
          <Card>
            <h4 className="text-xs font-bold uppercase tracking-wider text-slate-500 mb-3">Today Break Summary</h4>
            <div className="grid grid-cols-2 gap-3 text-center">
              <div className="bg-slate-50 dark:bg-slate-900 p-3 rounded-xl border border-slate-200 dark:border-slate-800">
                <p className="text-[10px] text-slate-400 font-semibold uppercase">Lunch Break</p>
                <p className="text-sm font-bold text-slate-900 dark:text-white mt-0.5">45 Minutes</p>
                <span className="text-[10px] text-emerald-600">Taken (1:00 PM)</span>
              </div>
              <div className="bg-slate-50 dark:bg-slate-900 p-3 rounded-xl border border-slate-200 dark:border-slate-800">
                <p className="text-[10px] text-slate-400 font-semibold uppercase">Tea / Coffee Break</p>
                <p className="text-sm font-bold text-slate-900 dark:text-white mt-0.5">15 Minutes</p>
                <span className="text-[10px] text-slate-400">Remaining</span>
              </div>
            </div>
          </Card>

          {/* Correction Request Trigger */}
          <Card className="bg-indigo-50/60 dark:bg-indigo-950/30 border border-indigo-200 dark:border-indigo-900">
            <div className="flex items-center justify-between">
              <div>
                <h4 className="text-xs font-bold text-slate-900 dark:text-slate-100">Missed a Punch?</h4>
                <p className="text-[11px] text-slate-500 dark:text-slate-400">Request attendance correction from manager</p>
              </div>
              <Button size="sm" onClick={() => setShowCorrectionSheet(true)}>
                <FileCheck2 className="w-3.5 h-3.5" /> Request
              </Button>
            </div>
          </Card>
        </div>
      )}

      {/* HISTORY TAB */}
      {activeTab === 'history' && (
        <div className="space-y-3">
          {/* Filter Pills */}
          <div className="flex items-center gap-1.5 overflow-x-auto pb-1 scrollbar-none">
            {['All', 'Present', 'Late', 'Half Day', 'Absent', 'On Leave'].map((st) => (
              <button
                key={st}
                onClick={() => setStatusFilter(st)}
                className={`px-3 py-1 rounded-full text-xs font-semibold whitespace-nowrap border transition-all ${
                  statusFilter === st
                    ? 'bg-[#4F39F6] text-white border-[#4F39F6]'
                    : 'bg-white dark:bg-[#131C2E] text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-800'
                }`}
              >
                {st}
              </button>
            ))}
          </div>

          {/* History List */}
          <div className="space-y-2">
            {filteredHistory.map((rec) => (
              <Card key={rec.id} onClick={() => setSelectedRecord(rec)} className="p-3">
                <div className="flex items-center justify-between mb-1">
                  <div className="flex items-center gap-2">
                    <span className="text-xs font-bold text-slate-900 dark:text-white">{rec.date}</span>
                    <StatusBadge status={rec.status} />
                  </div>
                  <span className="text-xs font-mono font-bold text-slate-700 dark:text-slate-300">
                    {rec.totalHours || '--'}
                  </span>
                </div>

                <div className="flex items-center justify-between text-[11px] text-slate-500 dark:text-slate-400 pt-1 border-t border-slate-100 dark:border-slate-800/80">
                  <span>In: {rec.clockIn || 'N/A'}</span>
                  <span>Out: {rec.clockOut || 'N/A'}</span>
                  {rec.breakDuration && <span>Break: {rec.breakDuration}</span>}
                </div>
              </Card>
            ))}
          </div>
        </div>
      )}

      {/* CALENDAR TAB */}
      {activeTab === 'calendar' && (
        <div className="space-y-4">
          <Card>
            <div className="flex items-center justify-between mb-4">
              <h3 className="font-bold text-sm text-slate-900 dark:text-slate-100">August 2026</h3>
              <div className="flex gap-1">
                <button className="p-1 rounded-lg border border-slate-200 dark:border-slate-800">
                  <ChevronLeft className="w-4 h-4" />
                </button>
                <button className="p-1 rounded-lg border border-slate-200 dark:border-slate-800">
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>

            {/* Calendar Day Grid */}
            <div className="grid grid-cols-7 gap-1 text-center text-[10px] font-bold text-slate-400 mb-2">
              <span>S</span><span>M</span><span>T</span><span>W</span><span>T</span><span>F</span><span>S</span>
            </div>
            <div className="grid grid-cols-7 gap-1.5 text-center text-xs">
              {Array.from({ length: 31 }).map((_, i) => {
                const dayNum = i + 1;
                let bgClass = 'bg-slate-50 dark:bg-slate-900 text-slate-700 dark:text-slate-300';
                if ([2, 3, 4, 7, 10, 11, 12].includes(dayNum)) {
                  bgClass = 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300 font-bold';
                } else if ([9].includes(dayNum)) {
                  bgClass = 'bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300 font-bold';
                } else if ([5, 6].includes(dayNum)) {
                  bgClass = 'bg-indigo-100 text-indigo-800 dark:bg-indigo-950 dark:text-indigo-300 font-bold';
                }

                return (
                  <div
                    key={dayNum}
                    className={`py-2 rounded-xl text-center border border-transparent ${bgClass}`}
                  >
                    {dayNum}
                  </div>
                );
              })}
            </div>

            {/* Visual Legend */}
            <div className="mt-4 pt-3 border-t border-slate-200 dark:border-slate-800 grid grid-cols-3 gap-2 text-[10px]">
              <div className="flex items-center gap-1.5">
                <span className="w-2.5 h-2.5 rounded-full bg-emerald-500" />
                <span className="text-slate-600 dark:text-slate-300">Present</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="w-2.5 h-2.5 rounded-full bg-amber-500" />
                <span className="text-slate-600 dark:text-slate-300">Late</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="w-2.5 h-2.5 rounded-full bg-indigo-500" />
                <span className="text-slate-600 dark:text-slate-300">Leave</span>
              </div>
            </div>
          </Card>
        </div>
      )}

      {/* Record Detail Sheet */}
      <BottomSheet
        isOpen={!!selectedRecord}
        onClose={() => setSelectedRecord(null)}
        title="Attendance Record Details"
      >
        {selectedRecord && (
          <div className="space-y-4">
            <div className="flex justify-between items-center p-3 rounded-2xl bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
              <div>
                <p className="text-xs text-slate-400">Date</p>
                <h4 className="font-bold text-sm text-slate-900 dark:text-white">{selectedRecord.date}</h4>
              </div>
              <StatusBadge status={selectedRecord.status} size="md" />
            </div>

            <div className="grid grid-cols-2 gap-3 text-center">
              <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
                <p className="text-[10px] text-slate-400 font-semibold uppercase">Clock In</p>
                <p className="text-sm font-black text-slate-900 dark:text-white mt-0.5">{selectedRecord.clockIn || '--'}</p>
              </div>
              <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
                <p className="text-[10px] text-slate-400 font-semibold uppercase">Clock Out</p>
                <p className="text-sm font-black text-slate-900 dark:text-white mt-0.5">{selectedRecord.clockOut || '--'}</p>
              </div>
            </div>

            {selectedRecord.notes && (
              <div className="p-3 bg-indigo-50 dark:bg-indigo-950/40 rounded-xl border border-indigo-200 dark:border-indigo-900 text-xs">
                <span className="font-bold text-[#4F39F6] block mb-0.5">Notes:</span>
                <p className="text-slate-700 dark:text-slate-300">{selectedRecord.notes}</p>
              </div>
            )}
          </div>
        )}
      </BottomSheet>

      {/* Attendance Correction Sheet */}
      <BottomSheet
        isOpen={showCorrectionSheet}
        onClose={() => setShowCorrectionSheet(false)}
        title="Attendance Correction Request"
      >
        {corrSubmitted ? (
          <div className="text-center py-8 space-y-2">
            <CheckCircle2 className="w-12 h-12 text-emerald-500 mx-auto" />
            <h4 className="font-bold text-base text-slate-900 dark:text-white">Request Submitted</h4>
            <p className="text-xs text-slate-500">Your manager will review the punch correction.</p>
          </div>
        ) : (
          <form onSubmit={handleCorrectionSubmit} className="space-y-4">
            <Input
              label="Select Date"
              type="date"
              value={corrDate}
              onChange={(e) => setCorrDate(e.target.value)}
            />
            <div className="grid grid-cols-2 gap-3">
              <Input
                label="Requested Clock In"
                value={corrIn}
                onChange={(e) => setCorrIn(e.target.value)}
              />
              <Input
                label="Requested Clock Out"
                value={corrOut}
                onChange={(e) => setCorrOut(e.target.value)}
              />
            </div>
            <div className="space-y-1.5">
              <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500">
                Reason for Correction
              </label>
              <textarea
                value={corrReason}
                onChange={(e) => setCorrReason(e.target.value)}
                required
                placeholder="e.g. Biometric device offline or client site deployment"
                className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-3 text-sm"
                rows={3}
              />
            </div>
            <Button fullWidth size="lg">
              <Send className="w-4 h-4 mr-1" /> Submit Correction Request
            </Button>
          </form>
        )}
      </BottomSheet>
    </div>
  );
};
