import React from 'react';
import { useApp } from '../../context/AppContext';
import { ScreenId } from '../../types';
import {
  FileText,
  Award,
  LifeBuoy,
  Calendar,
  Send,
  FolderArchive,
  UserCheck,
  Settings,
  Users,
  CheckSquare,
  Clock,
  TrendingUp,
  LogOut,
  ChevronRight,
  ShieldAlert,
} from 'lucide-react';
import { Card } from '../common/UIComponents';

export const MoreDrawer: React.FC = () => {
  const { role, user, setActiveScreen, logout } = useApp();

  const isManager = role === 'MANAGER';

  interface MenuItem {
    id: ScreenId;
    title: string;
    description: string;
    icon: React.ElementType;
    color: string;
    bgColor: string;
    managerOnly?: boolean;
  }

  const managerItems: MenuItem[] = [
    {
      id: 'manager_leave_approvals',
      title: 'Leave Approvals',
      description: 'Review and approve team requests',
      icon: CheckSquare,
      color: '#10B981',
      bgColor: 'bg-emerald-50 dark:bg-emerald-950/50 text-emerald-600',
    },
    {
      id: 'my_team',
      title: 'My Team',
      description: 'Directory, profiles and details',
      icon: Users,
      color: '#4F39F6',
      bgColor: 'bg-indigo-50 dark:bg-indigo-950/50 text-indigo-600',
    },
    {
      id: 'team_attendance',
      title: 'Team Attendance',
      description: 'Live daily clock-ins & presence',
      icon: Clock,
      color: '#3B82F6',
      bgColor: 'bg-blue-50 dark:bg-blue-950/50 text-blue-600',
    },
    {
      id: 'team_performance',
      title: 'Team Performance',
      description: 'Goal completion & review metrics',
      icon: TrendingUp,
      color: '#F59E0B',
      bgColor: 'bg-amber-50 dark:bg-amber-950/50 text-amber-600',
    },
  ];

  const employeeItems: MenuItem[] = [
    {
      id: 'payslips',
      title: 'Payslips',
      description: 'View monthly earnings & tax statements',
      icon: FileText,
      color: '#10B981',
      bgColor: 'bg-emerald-50 dark:bg-emerald-950/50 text-emerald-600',
    },
    {
      id: 'performance',
      title: 'Performance & Goals',
      description: 'KPI progress, ratings & reviews',
      icon: Award,
      color: '#F59E0B',
      bgColor: 'bg-amber-50 dark:bg-amber-950/50 text-amber-600',
    },
    {
      id: 'helpdesk',
      title: 'Helpdesk & Support',
      description: 'Raise IT, HR or payroll tickets',
      icon: LifeBuoy,
      color: '#EF4444',
      bgColor: 'bg-rose-50 dark:bg-rose-950/50 text-rose-600',
    },
    {
      id: 'calendar',
      title: 'Master Calendar',
      description: 'Company holidays, leaves & events',
      icon: Calendar,
      color: '#3B82F6',
      bgColor: 'bg-blue-50 dark:bg-blue-950/50 text-blue-600',
    },
    {
      id: 'requests',
      title: 'Self-Service Requests',
      description: 'Certificates, updates & corrections',
      icon: Send,
      color: '#8B5CF6',
      bgColor: 'bg-purple-50 dark:bg-purple-950/50 text-purple-600',
    },
    {
      id: 'documents',
      title: 'Document Center',
      description: 'Policies, handbook & certificates',
      icon: FolderArchive,
      color: '#06B6D4',
      bgColor: 'bg-cyan-50 dark:bg-cyan-950/50 text-cyan-600',
    },
    {
      id: 'profile',
      title: 'My Profile',
      description: 'Personal info, contact & job details',
      icon: UserCheck,
      color: '#4F39F6',
      bgColor: 'bg-indigo-50 dark:bg-indigo-950/50 text-indigo-600',
    },
    {
      id: 'settings',
      title: 'App Settings',
      description: 'Notifications, theme & security',
      icon: Settings,
      color: '#64748B',
      bgColor: 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300',
    },
  ];

  return (
    <div className="p-4 space-y-6 pb-20">
      {/* Profile summary header */}
      <Card
        onClick={() => setActiveScreen('profile')}
        className="bg-gradient-to-r from-[#0F172B] to-[#1E293B] text-white border-0 shadow-md p-4"
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <img
              src={user.avatar}
              alt={user.name}
              className="w-12 h-12 rounded-full object-cover border-2 border-indigo-400"
            />
            <div>
              <h3 className="font-bold text-base">{user.name}</h3>
              <p className="text-xs text-indigo-200">{user.designation}</p>
              <span className="inline-block px-2 py-0.5 bg-indigo-500/30 text-indigo-200 text-[10px] font-semibold rounded-md mt-1">
                {user.employeeId} • {role}
              </span>
            </div>
          </div>
          <ChevronRight className="w-5 h-5 text-slate-400" />
        </div>
      </Card>

      {/* Manager Specific section if Manager */}
      {isManager && (
        <div className="space-y-3">
          <div className="flex items-center gap-2">
            <ShieldAlert className="w-4 h-4 text-[#4F39F6]" />
            <h4 className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              Manager Tools
            </h4>
          </div>
          <div className="grid grid-cols-2 gap-3">
            {managerItems.map((item) => {
              const Icon = item.icon;
              return (
                <Card
                  key={item.id}
                  id={`more-menu-${item.id}`}
                  onClick={() => setActiveScreen(item.id)}
                  className="flex flex-col justify-between p-3.5 hover:border-indigo-400"
                >
                  <div className={`w-9 h-9 rounded-xl ${item.bgColor} flex items-center justify-center mb-2`}>
                    <Icon className="w-5 h-5" />
                  </div>
                  <div>
                    <h5 className="font-bold text-sm text-slate-900 dark:text-slate-100">{item.title}</h5>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400 line-clamp-1 mt-0.5">
                      {item.description}
                    </p>
                  </div>
                </Card>
              );
            })}
          </div>
        </div>
      )}

      {/* Employee Module Services */}
      <div className="space-y-3">
        <h4 className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
          Employee Services
        </h4>
        <div className="grid grid-cols-2 gap-3">
          {employeeItems.map((item) => {
            const Icon = item.icon;
            return (
              <Card
                key={item.id}
                id={`more-menu-${item.id}`}
                onClick={() => setActiveScreen(item.id)}
                className="flex flex-col justify-between p-3.5 hover:border-indigo-400"
              >
                <div className={`w-9 h-9 rounded-xl ${item.bgColor} flex items-center justify-center mb-2`}>
                  <Icon className="w-5 h-5" />
                </div>
                <div>
                  <h5 className="font-bold text-sm text-slate-900 dark:text-slate-100">{item.title}</h5>
                  <p className="text-[11px] text-slate-500 dark:text-slate-400 line-clamp-1 mt-0.5">
                    {item.description}
                  </p>
                </div>
              </Card>
            );
          })}
        </div>
      </div>

      {/* Logout button */}
      <div className="pt-2">
        <button
          onClick={logout}
          className="w-full py-3 px-4 rounded-xl bg-rose-50 dark:bg-rose-950/40 text-rose-600 dark:text-rose-400 font-bold text-sm flex items-center justify-center gap-2 border border-rose-200 dark:border-rose-900/50 active:scale-[0.98] transition-all"
        >
          <LogOut className="w-4 h-4" />
          <span>Sign Out Account</span>
        </button>
      </div>
    </div>
  );
};
