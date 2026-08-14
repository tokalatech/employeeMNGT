import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button, BottomSheet, Input } from '../common/UIComponents';
import {
  Users,
  Search,
  Filter,
  Mail,
  Phone,
  Calendar,
  Award,
  Clock,
  TrendingUp,
  CheckCircle2,
  ChevronRight,
  ShieldCheck,
} from 'lucide-react';
import { TeamMember } from '../../types';

export const TeamScreen: React.FC = () => {
  const { teamMembers, activeScreen } = useApp();

  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('All');
  const [selectedMember, setSelectedMember] = useState<TeamMember | null>(null);

  const filteredTeam = teamMembers.filter((m) => {
    const matchesSearch =
      m.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      m.designation.toLowerCase().includes(searchQuery.toLowerCase());
    if (statusFilter === 'All') return matchesSearch;
    return matchesSearch && m.statusToday.toLowerCase().includes(statusFilter.toLowerCase());
  });

  const isTeamAttendanceScreen = activeScreen === 'team_attendance';
  const isTeamPerformanceScreen = activeScreen === 'team_performance';

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Header Banner */}
      <div className="bg-gradient-to-r from-[#0F172B] to-[#1E293B] text-white p-4 rounded-2xl shadow-md flex items-center justify-between">
        <div>
          <span className="text-[10px] font-bold uppercase tracking-wider text-indigo-300">
            Manager View
          </span>
          <h2 className="text-lg font-black text-white flex items-center gap-2">
            {isTeamAttendanceScreen ? (
              <>
                <Clock className="w-5 h-5 text-sky-400" /> Team Live Attendance
              </>
            ) : isTeamPerformanceScreen ? (
              <>
                <TrendingUp className="w-5 h-5 text-amber-400" /> Team Performance KPIs
              </>
            ) : (
              <>
                <Users className="w-5 h-5 text-indigo-400" /> My Team ({teamMembers.length})
              </>
            )}
          </h2>
        </div>
      </div>

      {/* TEAM ATTENDANCE MODE */}
      {isTeamAttendanceScreen && (
        <div className="space-y-3">
          <div className="grid grid-cols-4 gap-2 text-center">
            <div className="bg-white dark:bg-[#131C2E] p-2.5 rounded-xl border border-slate-200 dark:border-slate-800">
              <p className="text-[10px] text-emerald-600 font-bold uppercase">Present</p>
              <p className="text-lg font-black text-emerald-600">3</p>
            </div>
            <div className="bg-white dark:bg-[#131C2E] p-2.5 rounded-xl border border-slate-200 dark:border-slate-800">
              <p className="text-[10px] text-sky-600 font-bold uppercase">WFH</p>
              <p className="text-lg font-black text-sky-600">1</p>
            </div>
            <div className="bg-white dark:bg-[#131C2E] p-2.5 rounded-xl border border-slate-200 dark:border-slate-800">
              <p className="text-[10px] text-amber-600 font-bold uppercase">Late</p>
              <p className="text-lg font-black text-amber-600">1</p>
            </div>
            <div className="bg-white dark:bg-[#131C2E] p-2.5 rounded-xl border border-slate-200 dark:border-slate-800">
              <p className="text-[10px] text-rose-600 font-bold uppercase">Leave</p>
              <p className="text-lg font-black text-rose-600">1</p>
            </div>
          </div>

          <div className="space-y-2">
            {teamMembers.map((tm) => (
              <Card key={tm.id} className="p-3.5 flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <img src={tm.avatar} alt={tm.name} className="w-10 h-10 rounded-full object-cover" />
                  <div>
                    <h4 className="font-bold text-xs text-slate-900 dark:text-white">{tm.name}</h4>
                    <p className="text-[10px] text-slate-400">{tm.designation}</p>
                  </div>
                </div>
                <div className="text-right">
                  <StatusBadge status={tm.statusToday} />
                  <p className="text-[10px] text-slate-500 mt-1">
                    {tm.clockInTime ? `In: ${tm.clockInTime}` : 'Not Checked In'}
                  </p>
                </div>
              </Card>
            ))}
          </div>
        </div>
      )}

      {/* TEAM PERFORMANCE MODE */}
      {isTeamPerformanceScreen && (
        <div className="space-y-3">
          {teamMembers.map((tm) => (
            <Card key={tm.id} className="p-4 space-y-3">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <img src={tm.avatar} alt={tm.name} className="w-10 h-10 rounded-full object-cover" />
                  <div>
                    <h4 className="font-bold text-sm text-slate-900 dark:text-white">{tm.name}</h4>
                    <p className="text-[11px] text-slate-400">{tm.designation}</p>
                  </div>
                </div>
                <div className="text-right">
                  <span className="text-xs font-black text-amber-600 bg-amber-50 px-2 py-0.5 rounded-md">
                    ★ {tm.rating} / 5.0
                  </span>
                </div>
              </div>

              <div>
                <div className="flex justify-between items-center text-xs font-semibold mb-1">
                  <span className="text-slate-600 dark:text-slate-300">Goal Completion Rate</span>
                  <span className="text-[#4F39F6] font-bold">{tm.goalCompletionRate}%</span>
                </div>
                <div className="w-full bg-slate-100 dark:bg-slate-800 h-2 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-[#4F39F6] rounded-full"
                    style={{ width: `${tm.goalCompletionRate}%` }}
                  />
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}

      {/* STANDARD MY TEAM DIRECTORY MODE */}
      {!isTeamAttendanceScreen && !isTeamPerformanceScreen && (
        <div className="space-y-3">
          {/* Search & Status Filter */}
          <Input
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search team member name or title..."
            icon={Search}
          />

          <div className="flex gap-1.5 overflow-x-auto pb-1 scrollbar-none">
            {['All', 'Present', 'Work From Home', 'Late', 'On Leave'].map((st) => (
              <button
                key={st}
                onClick={() => setStatusFilter(st)}
                className={`px-3 py-1 rounded-full text-xs font-semibold whitespace-nowrap border ${
                  statusFilter === st
                    ? 'bg-[#4F39F6] text-white border-[#4F39F6]'
                    : 'bg-white dark:bg-[#131C2E] text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-800'
                }`}
              >
                {st}
              </button>
            ))}
          </div>

          {/* Member Cards */}
          <div className="space-y-2.5">
            {filteredTeam.map((tm) => (
              <Card
                key={tm.id}
                onClick={() => setSelectedMember(tm)}
                className="p-3.5 flex items-center justify-between"
              >
                <div className="flex items-center gap-3">
                  <div className="relative">
                    <img
                      src={tm.avatar}
                      alt={tm.name}
                      className="w-12 h-12 rounded-full object-cover border border-slate-200"
                    />
                    <span
                      className={`absolute bottom-0 right-0 w-3.5 h-3.5 border-2 border-white dark:border-slate-900 rounded-full ${
                        tm.statusToday === 'Present'
                          ? 'bg-emerald-500'
                          : tm.statusToday === 'Work From Home'
                          ? 'bg-sky-500'
                          : 'bg-amber-500'
                      }`}
                    />
                  </div>
                  <div>
                    <h4 className="font-bold text-sm text-slate-900 dark:text-white">{tm.name}</h4>
                    <p className="text-[11px] text-slate-500">{tm.designation}</p>
                    <span className="text-[10px] text-indigo-600 dark:text-indigo-400 font-semibold mt-0.5 block">
                      {tm.email}
                    </span>
                  </div>
                </div>

                <div className="text-right">
                  <StatusBadge status={tm.statusToday} />
                  <ChevronRight className="w-4 h-4 text-slate-400 ml-auto mt-2" />
                </div>
              </Card>
            ))}
          </div>
        </div>
      )}

      {/* MEMBER DETAILS SHEET */}
      <BottomSheet
        isOpen={!!selectedMember}
        onClose={() => setSelectedMember(null)}
        title="Team Member Profile"
      >
        {selectedMember && (
          <div className="space-y-4 text-xs">
            <div className="flex items-center gap-4 p-4 rounded-2xl bg-gradient-to-r from-[#0F172B] to-[#1E293B] text-white">
              <img
                src={selectedMember.avatar}
                alt={selectedMember.name}
                className="w-14 h-14 rounded-full object-cover border-2 border-indigo-400"
              />
              <div>
                <h3 className="font-bold text-base text-white">{selectedMember.name}</h3>
                <p className="text-xs text-indigo-200">{selectedMember.designation}</p>
                <p className="text-[10px] text-slate-300 mt-1">{selectedMember.department}</p>
              </div>
            </div>

            <div className="space-y-2 p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
              <div className="flex items-center gap-2 text-slate-700 dark:text-slate-300">
                <Mail className="w-4 h-4 text-[#4F39F6]" />
                <span>{selectedMember.email}</span>
              </div>
              <div className="flex items-center gap-2 text-slate-700 dark:text-slate-300">
                <Phone className="w-4 h-4 text-[#4F39F6]" />
                <span>{selectedMember.phone}</span>
              </div>
              <div className="flex items-center gap-2 text-slate-700 dark:text-slate-300">
                <Calendar className="w-4 h-4 text-[#4F39F6]" />
                <span>Joined: {selectedMember.joiningDate}</span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3 text-center">
              <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
                <span className="text-[10px] text-slate-400 font-bold uppercase">KPI Completion</span>
                <p className="text-base font-black text-[#4F39F6] mt-0.5">{selectedMember.goalCompletionRate}%</p>
              </div>
              <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
                <span className="text-[10px] text-slate-400 font-bold uppercase">Performance Rating</span>
                <p className="text-base font-black text-amber-500 mt-0.5">★ {selectedMember.rating}</p>
              </div>
            </div>
          </div>
        )}
      </BottomSheet>
    </div>
  );
};
