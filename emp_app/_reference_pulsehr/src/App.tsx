import React from 'react';
import { AppProvider, useApp } from './context/AppContext';
import { BottomNav } from './components/mobile/BottomNav';
import { MoreDrawer } from './components/mobile/MoreDrawer';

// Screens
import { AuthScreen } from './components/screens/AuthScreen';
import { HomeScreen } from './components/screens/HomeScreen';
import { AttendanceScreen } from './components/screens/AttendanceScreen';
import { LeaveScreen } from './components/screens/LeaveScreen';
import { ManagerLeaveApprovalsScreen } from './components/screens/ManagerLeaveApprovalsScreen';
import { TeamScreen } from './components/screens/TeamScreen';
import { PayslipsScreen } from './components/screens/PayslipsScreen';
import { PerformanceScreen } from './components/screens/PerformanceScreen';
import { HelpdeskScreen } from './components/screens/HelpdeskScreen';
import { CalendarScreen } from './components/screens/CalendarScreen';
import { RequestsScreen } from './components/screens/RequestsScreen';
import { AnnouncementsScreen } from './components/screens/AnnouncementsScreen';
import { DocumentsScreen } from './components/screens/DocumentsScreen';
import { NotificationsScreen } from './components/screens/NotificationsScreen';
import { ProfileScreen } from './components/screens/ProfileScreen';
import { SettingsScreen } from './components/screens/SettingsScreen';

// Icons & UI
import {
  Bell,
  ArrowLeft,
  Moon,
  Sun,
  ShieldCheck,
  WifiOff,
  AlertTriangle,
  RefreshCw,
  Wifi,
  Battery,
  Signal,
  Sparkles,
} from 'lucide-react';

const AppContent: React.FC = () => {
  const {
    isAuthenticated,
    activeScreen,
    setActiveScreen,
    goBack,
    navigationHistory,
    isDarkMode,
    toggleDarkMode,
    role,
    setRole,
    user,
    notifications,
    deviceFrame,
    appStateMode,
  } = useApp();

  const unreadNotifsCount = notifications.filter((n) => !n.isRead).length;

  if (!isAuthenticated) {
    return <AuthScreen />;
  }

  // Screen title mapper
  const getScreenTitle = () => {
    switch (activeScreen) {
      case 'home':
        return 'Pulse HRMS';
      case 'attendance':
        return 'Clock & Time Tracking';
      case 'leave':
        return 'Leave Management';
      case 'manager_leave_approvals':
        return 'Team Approvals';
      case 'my_team':
        return 'Team Directory';
      case 'team_attendance':
        return 'Team Attendance';
      case 'team_performance':
        return 'Team KPIs';
      case 'payslips':
        return 'Salary Payslips';
      case 'performance':
        return 'Performance & Goals';
      case 'helpdesk':
        return 'Helpdesk & Support';
      case 'calendar':
        return 'Master Calendar';
      case 'requests':
        return 'Self-Service Requests';
      case 'announcements':
        return 'Announcements';
      case 'documents':
        return 'Document Center';
      case 'notifications':
        return 'Notifications';
      case 'profile':
        return 'My Profile';
      case 'settings':
        return 'App Settings';
      case 'more':
        return 'All Modules & Apps';
      default:
        return 'Pulse HRMS';
    }
  };

  // Render current screen component
  const renderScreen = () => {
    // If testing loading mode
    if (appStateMode === 'loading') {
      return (
        <div className="p-4 space-y-4 animate-pulse">
          <div className="h-32 bg-slate-200 dark:bg-slate-800 rounded-2xl" />
          <div className="h-20 bg-slate-200 dark:bg-slate-800 rounded-2xl" />
          <div className="h-40 bg-slate-200 dark:bg-slate-800 rounded-2xl" />
        </div>
      );
    }

    // If testing error mode
    if (appStateMode === 'error') {
      return (
        <div className="p-8 text-center space-y-3">
          <AlertTriangle className="w-12 h-12 text-rose-500 mx-auto" />
          <h3 className="font-bold text-lg text-slate-900 dark:text-white">Failed to Sync Data</h3>
          <p className="text-xs text-slate-500">
            A network timeout occurred while reaching HR servers. Please try again.
          </p>
          <button
            onClick={() => window.location.reload()}
            className="px-4 py-2 bg-[#4F39F6] text-white font-bold text-xs rounded-xl"
          >
            Retry Connection
          </button>
        </div>
      );
    }

    // Router
    switch (activeScreen) {
      case 'home':
        return <HomeScreen />;
      case 'attendance':
        return <AttendanceScreen />;
      case 'leave':
        return <LeaveScreen />;
      case 'manager_leave_approvals':
        return <ManagerLeaveApprovalsScreen />;
      case 'my_team':
      case 'team_attendance':
      case 'team_performance':
        return <TeamScreen />;
      case 'payslips':
        return <PayslipsScreen />;
      case 'performance':
        return <PerformanceScreen />;
      case 'helpdesk':
        return <HelpdeskScreen />;
      case 'calendar':
        return <CalendarScreen />;
      case 'requests':
        return <RequestsScreen />;
      case 'announcements':
        return <AnnouncementsScreen />;
      case 'documents':
        return <DocumentsScreen />;
      case 'notifications':
        return <NotificationsScreen />;
      case 'profile':
        return <ProfileScreen />;
      case 'settings':
        return <SettingsScreen />;
      case 'more':
        return <MoreDrawer />;
      default:
        return <HomeScreen />;
    }
  };

  const isCanGoBack = navigationHistory.length > 1 && activeScreen !== 'home';

  // Frame container classes
  const getFrameContainerStyle = () => {
    if (deviceFrame === 'iphone16') {
      return 'max-w-[410px] h-[850px] rounded-[48px] border-[10px] border-slate-900 shadow-2xl overflow-hidden my-4 ring-1 ring-slate-800';
    }
    if (deviceFrame === 'pixel9') {
      return 'max-w-[420px] h-[860px] rounded-[36px] border-[12px] border-slate-800 shadow-2xl overflow-hidden my-4';
    }
    return 'w-full max-w-md h-screen md:h-[90vh] md:rounded-3xl md:border md:border-slate-800 shadow-2xl overflow-hidden my-0 md:my-4';
  };

  return (
    <div
      className={`min-h-screen w-full flex items-center justify-center bg-slate-950 text-slate-900 dark:text-slate-100 font-sans transition-colors ${
        isDarkMode ? 'dark' : ''
      }`}
    >
      {/* Mobile Frame Container */}
      <div
        id="app-device-frame"
        className={`relative flex flex-col bg-slate-50 dark:bg-[#0B101D] transition-all w-full ${getFrameContainerStyle()}`}
      >
        {/* Mobile Device Status Bar Mock */}
        <div className="bg-white dark:bg-[#0F172B] px-5 pt-2 pb-1 flex justify-between items-center text-[11px] font-bold text-slate-700 dark:text-slate-300 select-none z-40 border-b border-slate-100 dark:border-slate-800/60">
          <span>09:41</span>
          <div className="w-16 h-4 bg-slate-900 rounded-full mx-auto -mt-1 hidden md:block" />
          <div className="flex items-center gap-1.5">
            <Signal className="w-3.5 h-3.5" />
            <Wifi className="w-3.5 h-3.5" />
            <Battery className="w-4 h-4" />
          </div>
        </div>

        {/* Offline Banner indicator if simulated */}
        {appStateMode === 'offline' && (
          <div className="bg-amber-500 text-slate-950 px-3 py-1 text-[11px] font-bold flex items-center justify-center gap-1.5 shrink-0 z-40">
            <WifiOff className="w-3.5 h-3.5" />
            <span>Offline Mode — Showing Cached Offline Data</span>
          </div>
        )}

        {/* Header App Bar */}
        <header
          id="app-header-bar"
          className="bg-white dark:bg-[#0F172B] border-b border-slate-200 dark:border-slate-800 px-4 py-3 flex items-center justify-between shrink-0 z-30 shadow-xs"
        >
          <div className="flex items-center gap-2">
            {isCanGoBack ? (
              <button
                onClick={goBack}
                className="p-1.5 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300 transition-all"
              >
                <ArrowLeft className="w-5 h-5" />
              </button>
            ) : (
              <div className="w-8 h-8 rounded-xl bg-[#4F39F6] flex items-center justify-center text-white font-black text-sm shadow-xs">
                P
              </div>
            )}
            <div>
              <h1 className="text-sm font-black text-slate-900 dark:text-white leading-tight">
                {getScreenTitle()}
              </h1>
              <span className="text-[10px] text-indigo-600 dark:text-indigo-400 font-extrabold uppercase tracking-wide">
                {role === 'MANAGER' ? 'Manager View' : 'Employee View'}
              </span>
            </div>
          </div>

          <div className="flex items-center gap-1.5">
            {/* Quick Role Switcher Button */}
            <button
              onClick={() => setRole(role === 'EMPLOYEE' ? 'MANAGER' : 'EMPLOYEE')}
              className={`px-2.5 py-1 rounded-xl text-[10px] font-extrabold uppercase tracking-wider flex items-center gap-1 transition-all border ${
                role === 'MANAGER'
                  ? 'bg-amber-500/10 text-amber-600 border-amber-300 dark:border-amber-900'
                  : 'bg-indigo-500/10 text-indigo-600 border-indigo-200 dark:border-indigo-900'
              }`}
            >
              <ShieldCheck className="w-3 h-3" />
              {role}
            </button>

            {/* Notifications Bell */}
            <button
              onClick={() => setActiveScreen('notifications')}
              className="p-2 rounded-xl text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 relative transition-all"
            >
              <Bell className="w-4 h-4" />
              {unreadNotifsCount > 0 && (
                <span className="absolute top-1 right-1 w-2 h-2 rounded-full bg-rose-500 animate-ping" />
              )}
            </button>

            {/* Dark Mode Toggle */}
            <button
              onClick={toggleDarkMode}
              className="p-2 rounded-xl text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition-all"
            >
              {isDarkMode ? <Sun className="w-4 h-4 text-amber-400" /> : <Moon className="w-4 h-4 text-slate-700" />}
            </button>
          </div>
        </header>

        {/* Scrollable Main Screen Content */}
        <main
          id="app-main-content-scroll"
          className="flex-1 overflow-y-auto scrollbar-none relative"
        >
          {renderScreen()}
        </main>

        {/* Fixed Bottom Navigation Bar */}
        <BottomNav />
      </div>
    </div>
  );
};

export default function App() {
  return (
    <AppProvider>
      <AppContent />
    </AppProvider>
  );
}
