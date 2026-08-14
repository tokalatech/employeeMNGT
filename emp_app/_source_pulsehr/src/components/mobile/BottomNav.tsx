import React from 'react';
import { useApp } from '../../context/AppContext';
import { ScreenId } from '../../types';
import {
  Home,
  Clock,
  CalendarDays,
  Bell,
  Grid,
  Users,
} from 'lucide-react';

export const BottomNav: React.FC = () => {
  const { role, activeScreen, setActiveScreen, notifications } = useApp();

  const unreadCount = notifications.filter((n) => !n.isRead).length;

  // Tabs for Employee vs Manager
  const isManager = role === 'MANAGER';

  const employeeTabs: { id: ScreenId; label: string; icon: React.ElementType; badge?: number }[] = [
    { id: 'home', label: 'Home', icon: Home },
    { id: 'attendance', label: 'Attendance', icon: Clock },
    { id: 'leave', label: 'Leave', icon: CalendarDays },
    { id: 'notifications', label: 'Alerts', icon: Bell, badge: unreadCount },
    { id: 'more', label: 'More', icon: Grid },
  ];

  const managerTabs: { id: ScreenId; label: string; icon: React.ElementType; badge?: number }[] = [
    { id: 'home', label: 'Home', icon: Home },
    { id: 'attendance', label: 'Attendance', icon: Clock },
    { id: 'my_team', label: 'My Team', icon: Users },
    { id: 'leave', label: 'Leave', icon: CalendarDays },
    { id: 'more', label: 'More', icon: Grid, badge: unreadCount },
  ];

  const currentTabs = isManager ? managerTabs : employeeTabs;

  return (
    <nav
      id="bottom-navigation-bar"
      className="bg-white dark:bg-[#0F172B] border-t border-slate-200 dark:border-slate-800 px-2 py-1.5 flex items-center justify-around z-30 select-none shadow-lg"
    >
      {currentTabs.map((tab) => {
        const Icon = tab.icon;
        const isActive = activeScreen === tab.id;

        return (
          <button
            key={tab.id}
            id={`nav-tab-${tab.id}`}
            onClick={() => setActiveScreen(tab.id)}
            className={`flex flex-col items-center justify-center py-1 px-2 rounded-xl transition-all relative ${
              isActive
                ? 'text-[#4F39F6] font-bold dark:text-indigo-400'
                : 'text-slate-500 dark:text-slate-400 font-medium hover:text-slate-900 dark:hover:text-slate-200'
            }`}
          >
            <div className="relative">
              <Icon className={`w-5 h-5 transition-transform ${isActive ? 'scale-110' : ''}`} />
              {tab.badge && tab.badge > 0 ? (
                <span className="absolute -top-1 -right-2 min-w-4 h-4 bg-rose-500 text-white text-[10px] font-extrabold rounded-full flex items-center justify-center px-1">
                  {tab.badge > 9 ? '9+' : tab.badge}
                </span>
              ) : null}
            </div>
            <span className="text-[11px] mt-0.5 tracking-tight">{tab.label}</span>
            {isActive && (
              <span className="w-1 h-1 rounded-full bg-[#4F39F6] dark:bg-indigo-400 mt-0.5"></span>
            )}
          </button>
        );
      })}
    </nav>
  );
};
