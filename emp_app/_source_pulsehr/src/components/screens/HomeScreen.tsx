import React from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button, SkeletonCard, EmptyState } from '../common/UIComponents';
import {
  Clock,
  CalendarDays,
  FileText,
  LifeBuoy,
  Send,
  Bell,
  Play,
  Square,
  Users,
  ChevronRight,
  TrendingUp,
  AlertCircle,
  Megaphone,
} from 'lucide-react';
import { MOCK_ANNOUNCEMENTS, MOCK_CALENDAR_EVENTS } from '../../mockData';

export const HomeScreen: React.FC = () => {
  const {
    role,
    user,
    clockStatus,
    clockInTime,
    clockOutTime,
    liveTimerSeconds,
    handleClockIn,
    handleClockOut,
    leaveBalances,
    leaveRequests,
    setActiveScreen,
    appStateMode,
    teamMembers,
  } = useApp();

  const isManager = role === 'MANAGER';

  // Format seconds to HH:MM:SS
  const formatTimer = (totalSecs: number) => {
    const hrs = Math.floor(totalSecs / 3600);
    const mins = Math.floor((totalSecs % 3600) / 60);
    const secs = totalSecs % 60;
    return `${hrs.toString().padStart(2, '0')}:${mins
      .toString()
      .padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  if (appStateMode === 'loading') {
    return (
      <div className="p-4 space-y-4">
        <SkeletonCard />
        <SkeletonCard />
        <SkeletonCard />
      </div>
    );
  }

  if (appStateMode === 'error') {
    return (
      <EmptyState
        title="Failed to Load Dashboard"
        description="Unable to connect to HRMS server. Please check your network connection."
        actionText="Try Again"
        onAction={() => window.location.reload()}
        icon={AlertCircle}
      />
    );
  }

  const pendingLeavesForManager = leaveRequests.filter((r) => r.status === 'Pending').length;

  return (
    <div className="p-4 space-y-5 pb-20">
      {/* Employee Header */}
      <div className="flex items-center justify-between pt-1">
        <div className="flex items-center gap-3">
          <div className="relative" onClick={() => setActiveScreen('profile')}>
            <img
              src={user.avatar}
              alt={user.name}
              className="w-12 h-12 rounded-full object-cover border-2 border-[#4F39F6]"
            />
            <span className="absolute bottom-0 right-0 w-3.5 h-3.5 bg-emerald-500 border-2 border-white dark:border-slate-900 rounded-full" />
          </div>
          <div>
            <span className="text-xs font-semibold text-[#4F39F6] dark:text-indigo-400 uppercase tracking-wider">
              {role === 'MANAGER' ? 'Manager Portal' : 'Employee Portal'}
            </span>
            <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-1.5">
              Hello, {user.name.split(' ')[0]} 👋
            </h2>
            <p className="text-xs text-slate-500 dark:text-slate-400">{user.designation}</p>
          </div>
        </div>

        <button
          onClick={() => setActiveScreen('notifications')}
          className="p-2.5 rounded-2xl bg-white dark:bg-[#131C2E] border border-slate-200 dark:border-slate-800 text-slate-700 dark:text-slate-300 relative shadow-xs active:scale-95 transition-all"
        >
          <Bell className="w-5 h-5" />
          <span className="absolute top-2 right-2 w-2 h-2 bg-rose-500 rounded-full animate-ping" />
        </button>
      </div>

      {/* Clock In / Clock Out Attendance Card */}
      <Card className="bg-gradient-to-br from-[#0F172B] via-[#1A263A] to-[#0F172B] text-white p-5 shadow-xl border-0 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-32 h-32 bg-indigo-500/10 rounded-full blur-2xl pointer-events-none" />

        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <Clock className="w-4 h-4 text-indigo-400" />
            <span className="text-xs font-medium text-slate-300">
              {new Date().toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })}
            </span>
          </div>
          <StatusBadge status={clockStatus} />
        </div>

        <div className="my-2">
          {clockStatus === 'Working' ? (
            <div>
              <p className="text-[11px] uppercase tracking-wider text-indigo-200 font-semibold">
                Working Timer
              </p>
              <h1 className="text-3xl font-black text-white tracking-widest my-1 font-mono">
                {formatTimer(liveTimerSeconds)}
              </h1>
              <p className="text-xs text-slate-300">
                Clocked in at <span className="font-semibold text-emerald-300">{clockInTime}</span>
              </p>
            </div>
          ) : clockStatus === 'Completed' ? (
            <div>
              <p className="text-[11px] uppercase tracking-wider text-emerald-400 font-semibold">
                Shift Completed Today
              </p>
              <h3 className="text-xl font-bold text-white mt-1">
                In: {clockInTime} • Out: {clockOutTime}
              </h3>
              <p className="text-xs text-slate-300 mt-1">Total Hours: 8h 32m</p>
            </div>
          ) : (
            <div>
              <p className="text-[11px] uppercase tracking-wider text-slate-400 font-semibold">
                Not Checked In
              </p>
              <h3 className="text-lg font-bold text-white mt-1">Ready to start your shift?</h3>
              <p className="text-xs text-slate-300">Standard shift: 09:00 AM - 06:00 PM</p>
            </div>
          )}
        </div>

        {/* Action Button */}
        <div className="mt-4 pt-3 border-t border-slate-700/60 flex items-center justify-between gap-3">
          {clockStatus === 'Not Checked In' ? (
            <Button
              fullWidth
              size="lg"
              onClick={handleClockIn}
              className="bg-emerald-500 hover:bg-emerald-600 text-white font-bold"
            >
              <Play className="w-4 h-4 fill-current" />
              <span>Clock In Now</span>
            </Button>
          ) : clockStatus === 'Working' ? (
            <Button
              fullWidth
              size="lg"
              variant="danger"
              onClick={handleClockOut}
              className="font-bold"
            >
              <Square className="w-4 h-4 fill-current" />
              <span>Clock Out Shift</span>
            </Button>
          ) : (
            <div className="w-full text-center py-2 text-xs text-emerald-300 font-medium">
              ✓ Attendance logged successfully for today.
            </div>
          )}
        </div>
      </Card>

      {/* Manager Specific Quick Overview Card */}
      {isManager && (
        <Card className="bg-indigo-50/70 dark:bg-indigo-950/40 border border-indigo-200 dark:border-indigo-800/60 p-4">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2">
              <Users className="w-4 h-4 text-[#4F39F6]" />
              <h3 className="text-sm font-bold text-slate-900 dark:text-slate-100">Team At A Glance</h3>
            </div>
            <button
              onClick={() => setActiveScreen('my_team')}
              className="text-xs font-bold text-[#4F39F6] dark:text-indigo-400 flex items-center"
            >
              View Team <ChevronRight className="w-3.5 h-3.5" />
            </button>
          </div>
          <div className="grid grid-cols-4 gap-2 text-center">
            <div className="bg-white dark:bg-[#131C2E] p-2 rounded-xl border border-slate-200 dark:border-slate-800">
              <p className="text-[10px] text-slate-500 font-semibold uppercase">Total</p>
              <p className="text-base font-extrabold text-slate-900 dark:text-white">{teamMembers.length}</p>
            </div>
            <div className="bg-white dark:bg-[#131C2E] p-2 rounded-xl border border-slate-200 dark:border-slate-800">
              <p className="text-[10px] text-emerald-600 font-semibold uppercase">Present</p>
              <p className="text-base font-extrabold text-emerald-600">3</p>
            </div>
            <div className="bg-white dark:bg-[#131C2E] p-2 rounded-xl border border-slate-200 dark:border-slate-800">
              <p className="text-[10px] text-amber-600 font-semibold uppercase">On Leave</p>
              <p className="text-base font-extrabold text-amber-600">1</p>
            </div>
            <div
              onClick={() => setActiveScreen('manager_leave_approvals')}
              className="bg-rose-50 dark:bg-rose-950/40 p-2 rounded-xl border border-rose-200 dark:border-rose-900 cursor-pointer"
            >
              <p className="text-[10px] text-rose-600 font-bold uppercase">Pending</p>
              <p className="text-base font-black text-rose-600">{pendingLeavesForManager}</p>
            </div>
          </div>
        </Card>
      )}

      {/* Quick Action Shortcuts */}
      <div className="space-y-2">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
          Quick Actions
        </h3>
        <div className="grid grid-cols-4 gap-2">
          <button
            onClick={() => setActiveScreen('leave')}
            className="flex flex-col items-center p-3 bg-white dark:bg-[#131C2E] rounded-2xl border border-slate-200 dark:border-slate-800 active:scale-95 transition-all shadow-xs"
          >
            <div className="w-10 h-10 rounded-xl bg-indigo-50 dark:bg-indigo-950/50 flex items-center justify-center text-[#4F39F6] mb-1.5">
              <CalendarDays className="w-5 h-5" />
            </div>
            <span className="text-[11px] font-semibold text-slate-800 dark:text-slate-200">Apply Leave</span>
          </button>

          <button
            onClick={() => setActiveScreen('attendance')}
            className="flex flex-col items-center p-3 bg-white dark:bg-[#131C2E] rounded-2xl border border-slate-200 dark:border-slate-800 active:scale-95 transition-all shadow-xs"
          >
            <div className="w-10 h-10 rounded-xl bg-blue-50 dark:bg-blue-950/50 flex items-center justify-center text-blue-600 mb-1.5">
              <Clock className="w-5 h-5" />
            </div>
            <span className="text-[11px] font-semibold text-slate-800 dark:text-slate-200">History</span>
          </button>

          <button
            onClick={() => setActiveScreen('payslips')}
            className="flex flex-col items-center p-3 bg-white dark:bg-[#131C2E] rounded-2xl border border-slate-200 dark:border-slate-800 active:scale-95 transition-all shadow-xs"
          >
            <div className="w-10 h-10 rounded-xl bg-emerald-50 dark:bg-emerald-950/50 flex items-center justify-center text-emerald-600 mb-1.5">
              <FileText className="w-5 h-5" />
            </div>
            <span className="text-[11px] font-semibold text-slate-800 dark:text-slate-200">Payslip</span>
          </button>

          <button
            onClick={() => setActiveScreen('helpdesk')}
            className="flex flex-col items-center p-3 bg-white dark:bg-[#131C2E] rounded-2xl border border-slate-200 dark:border-slate-800 active:scale-95 transition-all shadow-xs"
          >
            <div className="w-10 h-10 rounded-xl bg-rose-50 dark:bg-rose-950/50 flex items-center justify-center text-rose-600 mb-1.5">
              <LifeBuoy className="w-5 h-5" />
            </div>
            <span className="text-[11px] font-semibold text-slate-800 dark:text-slate-200">Support</span>
          </button>
        </div>
      </div>

      {/* Leave Balance Summary */}
      <Card>
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <CalendarDays className="w-4 h-4 text-[#4F39F6]" />
            <h3 className="text-sm font-bold text-slate-900 dark:text-slate-100">Leave Balances</h3>
          </div>
          <button
            onClick={() => setActiveScreen('leave')}
            className="text-xs font-bold text-[#4F39F6] flex items-center"
          >
            Details <ChevronRight className="w-3.5 h-3.5" />
          </button>
        </div>

        <div className="grid grid-cols-3 gap-2">
          {leaveBalances.slice(0, 3).map((item) => (
            <div
              key={item.type}
              className="p-2.5 rounded-xl bg-slate-50 dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800"
            >
              <span className="text-[10px] font-semibold text-slate-500 uppercase tracking-tight block truncate">
                {item.type}
              </span>
              <p className="text-lg font-black text-slate-900 dark:text-white mt-0.5">
                {item.remaining} <span className="text-[10px] font-medium text-slate-400">/ {item.total}</span>
              </p>
              <div className="w-full bg-slate-200 dark:bg-slate-800 h-1.5 rounded-full mt-2 overflow-hidden">
                <div
                  className="h-full rounded-full"
                  style={{
                    width: `${(item.remaining / item.total) * 100}%`,
                    backgroundColor: item.color,
                  }}
                />
              </div>
            </div>
          ))}
        </div>
      </Card>

      {/* Upcoming Events */}
      <Card>
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <TrendingUp className="w-4 h-4 text-emerald-600" />
            <h3 className="text-sm font-bold text-slate-900 dark:text-slate-100">Upcoming Events</h3>
          </div>
          <button
            onClick={() => setActiveScreen('calendar')}
            className="text-xs font-bold text-[#4F39F6] flex items-center"
          >
            Calendar <ChevronRight className="w-3.5 h-3.5" />
          </button>
        </div>

        <div className="space-y-2">
          {MOCK_CALENDAR_EVENTS.slice(0, 2).map((ev) => (
            <div
              key={ev.id}
              className="flex items-center justify-between p-2.5 rounded-xl bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800"
            >
              <div className="flex items-center gap-3">
                <div
                  className="w-2.5 h-8 rounded-full"
                  style={{ backgroundColor: ev.color }}
                />
                <div>
                  <h4 className="text-xs font-bold text-slate-900 dark:text-slate-100">{ev.title}</h4>
                  <p className="text-[10px] text-slate-500">{ev.description}</p>
                </div>
              </div>
              <span className="text-xs font-semibold text-slate-700 dark:text-slate-300 bg-white dark:bg-slate-800 px-2 py-1 rounded-md border border-slate-200 dark:border-slate-700">
                {ev.date}
              </span>
            </div>
          ))}
        </div>
      </Card>

      {/* Recent Announcements */}
      <Card>
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <Megaphone className="w-4 h-4 text-amber-500" />
            <h3 className="text-sm font-bold text-slate-900 dark:text-slate-100">Announcements</h3>
          </div>
          <button
            onClick={() => setActiveScreen('announcements')}
            className="text-xs font-bold text-[#4F39F6] flex items-center"
          >
            All Notice <ChevronRight className="w-3.5 h-3.5" />
          </button>
        </div>

        <div className="space-y-2">
          {MOCK_ANNOUNCEMENTS.slice(0, 2).map((ann) => (
            <div
              key={ann.id}
              onClick={() => setActiveScreen('announcements')}
              className="p-3 rounded-xl bg-slate-50 dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 cursor-pointer active:scale-[0.99] transition-all"
            >
              <div className="flex items-center justify-between mb-1">
                <span className="text-[10px] font-bold text-amber-600 bg-amber-50 dark:bg-amber-950 px-2 py-0.5 rounded-md border border-amber-200">
                  {ann.category}
                </span>
                <span className="text-[10px] text-slate-400">{ann.publishedDate}</span>
              </div>
              <h4 className="text-xs font-bold text-slate-900 dark:text-slate-100 line-clamp-1">{ann.title}</h4>
              <p className="text-[11px] text-slate-500 dark:text-slate-400 line-clamp-1 mt-0.5">{ann.summary}</p>
            </div>
          ))}
        </div>
      </Card>
    </div>
  );
};
