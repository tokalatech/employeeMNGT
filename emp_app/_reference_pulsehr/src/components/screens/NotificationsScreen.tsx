import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button } from '../common/UIComponents';
import {
  Bell,
  CheckCheck,
  Calendar,
  Clock,
  FileText,
  Award,
  LifeBuoy,
  Send,
  ChevronRight,
} from 'lucide-react';
import { AppNotification } from '../../types';

export const NotificationsScreen: React.FC = () => {
  const { notifications, markNotificationRead, markAllNotificationsRead, setActiveScreen } = useApp();
  const [activeCategory, setActiveCategory] = useState<string>('All');

  const filteredNotifications = notifications.filter((n) => {
    if (activeCategory === 'All') return true;
    return n.category.toLowerCase() === activeCategory.toLowerCase();
  });

  const unreadCount = notifications.filter((n) => !n.isRead).length;

  const handleNotificationClick = (notif: AppNotification) => {
    markNotificationRead(notif.id);
    if (notif.targetScreen) {
      setActiveScreen(notif.targetScreen);
    }
  };

  const getCategoryIcon = (category: string) => {
    switch (category) {
      case 'Leave':
        return <Calendar className="w-4 h-4 text-emerald-600" />;
      case 'Attendance':
        return <Clock className="w-4 h-4 text-sky-600" />;
      case 'Payroll':
        return <FileText className="w-4 h-4 text-indigo-600" />;
      case 'Performance':
        return <Award className="w-4 h-4 text-amber-600" />;
      case 'Helpdesk':
        return <LifeBuoy className="w-4 h-4 text-rose-600" />;
      case 'Requests':
        return <Send className="w-4 h-4 text-purple-600" />;
      default:
        return <Bell className="w-4 h-4 text-[#4F39F6]" />;
    }
  };

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
            <Bell className="w-5 h-5 text-[#4F39F6]" /> Notifications ({unreadCount})
          </h2>
          <p className="text-xs text-slate-500">Real-time alerts, approvals & updates</p>
        </div>
        {unreadCount > 0 && (
          <Button variant="ghost" size="sm" onClick={markAllNotificationsRead} className="text-xs text-[#4F39F6]">
            <CheckCheck className="w-4 h-4 mr-1" /> Mark All Read
          </Button>
        )}
      </div>

      {/* Category Filter Pills */}
      <div className="flex gap-1.5 overflow-x-auto pb-1 scrollbar-none">
        {['All', 'Leave', 'Attendance', 'Payroll', 'Performance', 'Helpdesk', 'Requests'].map((cat) => (
          <button
            key={cat}
            onClick={() => setActiveCategory(cat)}
            className={`px-3 py-1 rounded-full text-xs font-semibold border whitespace-nowrap ${
              activeCategory === cat
                ? 'bg-[#4F39F6] text-white border-[#4F39F6]'
                : 'bg-white dark:bg-[#131C2E] text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-800'
            }`}
          >
            {cat}
          </button>
        ))}
      </div>

      {/* Notification List */}
      <div className="space-y-2.5">
        {filteredNotifications.length === 0 ? (
          <div className="p-8 text-center bg-white dark:bg-[#131C2E] rounded-2xl border border-slate-200 dark:border-slate-800">
            <Bell className="w-10 h-10 text-slate-300 mx-auto mb-2" />
            <h4 className="font-bold text-sm text-slate-900 dark:text-white">No Notifications</h4>
            <p className="text-xs text-slate-500 mt-1">You are all caught up!</p>
          </div>
        ) : (
          filteredNotifications.map((n) => (
            <Card
              key={n.id}
              onClick={() => handleNotificationClick(n)}
              className={`p-3.5 space-y-2 border-l-4 transition-all ${
                !n.isRead
                  ? 'border-l-[#4F39F6] bg-indigo-50/40 dark:bg-indigo-950/20'
                  : 'border-l-slate-300 dark:border-l-slate-700 opacity-90'
              }`}
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="p-1.5 rounded-lg bg-white dark:bg-slate-800 shadow-xs">
                    {getCategoryIcon(n.category)}
                  </div>
                  <span className="text-[10px] font-bold uppercase tracking-wider text-slate-500">
                    {n.category}
                  </span>
                  {!n.isRead && (
                    <span className="w-2 h-2 rounded-full bg-[#4F39F6] animate-pulse" />
                  )}
                </div>
                <span className="text-[10px] text-slate-400">{n.timestamp}</span>
              </div>

              <div>
                <h4 className="font-bold text-xs text-slate-900 dark:text-white">{n.title}</h4>
                <p className="text-xs text-slate-600 dark:text-slate-300 mt-0.5 line-clamp-2">
                  {n.description}
                </p>
              </div>

              {n.targetScreen && (
                <div className="flex items-center justify-end text-[10px] font-bold text-[#4F39F6] pt-1 border-t border-slate-100 dark:border-slate-800">
                  <span>View Details</span>
                  <ChevronRight className="w-3 h-3 ml-0.5" />
                </div>
              )}
            </Card>
          ))
        )}
      </div>
    </div>
  );
};
