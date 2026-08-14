import React, { createContext, useContext, useState, useEffect } from 'react';
import {
  UserRole,
  User,
  ScreenId,
  AttendanceStatus,
  AttendanceRecord,
  LeaveRequest,
  LeaveBalance,
  HelpdeskTicket,
  SelfServiceRequest,
  AppNotification,
  TeamMember,
  AppStateMode,
} from '../types';
import {
  EMPLOYEE_USER,
  MANAGER_USER,
  MOCK_LEAVE_BALANCES,
  MOCK_ATTENDANCE_HISTORY,
  MOCK_LEAVE_REQUESTS,
  MOCK_PAYSLIPS,
  MOCK_GOALS,
  MOCK_PERFORMANCE_REVIEWS,
  MOCK_HELPDESK_TICKETS,
  MOCK_ANNOUNCEMENTS,
  MOCK_CALENDAR_EVENTS,
  MOCK_SELF_SERVICE_REQUESTS,
  MOCK_DOCUMENTS,
  MOCK_NOTIFICATIONS,
  MOCK_TEAM_MEMBERS,
} from '../mockData';

export type DeviceFrameType = 'iphone16' | 'pixel9' | 'responsive';

interface AppContextType {
  role: UserRole;
  user: User;
  setRole: (role: UserRole) => void;
  activeScreen: ScreenId;
  setActiveScreen: (screen: ScreenId) => void;
  navigationHistory: ScreenId[];
  navigateTo: (screen: ScreenId) => void;
  goBack: () => void;
  
  // App state testing mode
  appStateMode: AppStateMode;
  setAppStateMode: (mode: AppStateMode) => void;

  // Theme & Shell
  isDarkMode: boolean;
  toggleDarkMode: () => void;
  deviceFrame: DeviceFrameType;
  setDeviceFrame: (frame: DeviceFrameType) => void;
  showFlutterSpec: boolean;
  setShowFlutterSpec: (show: boolean) => void;

  // Clock In / Out State
  clockStatus: AttendanceStatus;
  clockInTime: string | null;
  clockOutTime: string | null;
  liveTimerSeconds: number;
  handleClockIn: () => void;
  handleClockOut: () => void;

  // Leaves
  leaveBalances: LeaveBalance[];
  leaveRequests: LeaveRequest[];
  applyLeave: (request: Omit<LeaveRequest, 'id' | 'status' | 'appliedDate' | 'employeeId' | 'employeeName' | 'employeeAvatar' | 'department'>) => void;
  cancelLeave: (id: string) => void;
  approveLeave: (id: string) => void;
  rejectLeave: (id: string, reason: string) => void;

  // Attendance
  attendanceRecords: AttendanceRecord[];
  requestAttendanceCorrection: (date: string, reqIn: string, reqOut: string, reason: string) => void;

  // Tickets
  tickets: HelpdeskTicket[];
  createTicket: (subject: string, category: HelpdeskTicket['category'], priority: HelpdeskTicket['priority'], description: string) => void;
  replyToTicket: (ticketId: string, text: string) => void;

  // Self Service Requests
  requests: SelfServiceRequest[];
  createSelfServiceRequest: (type: SelfServiceRequest['requestType'], description: string) => void;

  // Notifications
  notifications: AppNotification[];
  markNotificationRead: (id: string) => void;
  markAllNotificationsRead: () => void;

  // Team
  teamMembers: TeamMember[];

  // Auth mock
  isAuthenticated: boolean;
  login: () => void;
  signUp: (name: string, email: string, role: UserRole, department: string) => void;
  logout: () => void;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [role, setRoleState] = useState<UserRole>('EMPLOYEE');
  const [user, setUser] = useState<User>(EMPLOYEE_USER);
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(true);
  const [activeScreen, setActiveScreenState] = useState<ScreenId>('home');
  const [navigationHistory, setNavigationHistory] = useState<ScreenId[]>(['home']);
  const [appStateMode, setAppStateMode] = useState<AppStateMode>('normal');

  // Shell options
  const [isDarkMode, setIsDarkMode] = useState<boolean>(false);
  const [deviceFrame, setDeviceFrame] = useState<DeviceFrameType>('iphone16');
  const [showFlutterSpec, setShowFlutterSpec] = useState<boolean>(false);

  // Clock state
  const [clockStatus, setClockStatus] = useState<AttendanceStatus>('Working');
  const [clockInTime, setClockInTime] = useState<string | null>('08:58 AM');
  const [clockOutTime, setClockOutTime] = useState<string | null>(null);
  const [liveTimerSeconds, setLiveTimerSeconds] = useState<number>(3 * 3600 + 42 * 60 + 15); // 03h 42m 15s

  // Data lists
  const [leaveBalances, setLeaveBalances] = useState<LeaveBalance[]>(MOCK_LEAVE_BALANCES);
  const [leaveRequests, setLeaveRequests] = useState<LeaveRequest[]>(MOCK_LEAVE_REQUESTS);
  const [attendanceRecords, setAttendanceRecords] = useState<AttendanceRecord[]>(MOCK_ATTENDANCE_HISTORY);
  const [tickets, setTickets] = useState<HelpdeskTicket[]>(MOCK_HELPDESK_TICKETS);
  const [requests, setRequests] = useState<SelfServiceRequest[]>(MOCK_SELF_SERVICE_REQUESTS);
  const [notifications, setNotifications] = useState<AppNotification[]>(MOCK_NOTIFICATIONS);
  const [teamMembers] = useState<TeamMember[]>(MOCK_TEAM_MEMBERS);

  // Switch role logic
  const setRole = (newRole: UserRole) => {
    setRoleState(newRole);
    if (newRole === 'MANAGER') {
      setUser(MANAGER_USER);
    } else {
      setUser(EMPLOYEE_USER);
    }
  };

  // Timer ticker
  useEffect(() => {
    let interval: NodeJS.Timeout | null = null;
    if (clockStatus === 'Working') {
      interval = setInterval(() => {
        setLiveTimerSeconds((prev) => prev + 1);
      }, 1000);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [clockStatus]);

  // Navigation helpers
  const navigateTo = (screen: ScreenId) => {
    if (screen !== activeScreen) {
      setNavigationHistory((prev) => [...prev, screen]);
      setActiveScreenState(screen);
    }
  };

  const goBack = () => {
    if (navigationHistory.length > 1) {
      const newHistory = [...navigationHistory];
      newHistory.pop();
      const prevScreen = newHistory[newHistory.length - 1];
      setNavigationHistory(newHistory);
      setActiveScreenState(prevScreen);
    }
  };

  const setActiveScreen = (screen: ScreenId) => {
    setActiveScreenState(screen);
    setNavigationHistory([screen]);
  };

  const toggleDarkMode = () => setIsDarkMode((prev) => !prev);

  // Clock Actions
  const handleClockIn = () => {
    const now = new Date();
    const timeStr = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    setClockStatus('Working');
    setClockInTime(timeStr);
    setClockOutTime(null);
    setLiveTimerSeconds(0);
  };

  const handleClockOut = () => {
    const now = new Date();
    const timeStr = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    setClockStatus('Completed');
    setClockOutTime(timeStr);
  };

  // Leave Actions
  const applyLeave = (req: Omit<LeaveRequest, 'id' | 'status' | 'appliedDate' | 'employeeId' | 'employeeName' | 'employeeAvatar' | 'department'>) => {
    const newReq: LeaveRequest = {
      ...req,
      id: `lv-${Date.now()}`,
      employeeId: user.id,
      employeeName: user.name,
      employeeAvatar: user.avatar,
      department: user.department,
      status: 'Pending',
      appliedDate: 'Just now',
    };
    setLeaveRequests((prev) => [newReq, ...prev]);

    // Push notification
    const newNotif: AppNotification = {
      id: `notif-${Date.now()}`,
      title: 'Leave Submitted',
      description: `Applied for ${req.leaveType} (${req.totalDays} day${req.totalDays > 1 ? 's' : ''}). Pending approval.`,
      timestamp: 'Just now',
      category: 'Leave',
      isRead: false,
      targetScreen: 'leave',
    };
    setNotifications((prev) => [newNotif, ...prev]);
  };

  const cancelLeave = (id: string) => {
    setLeaveRequests((prev) =>
      prev.map((item) => (item.id === id ? { ...item, status: 'Cancelled' as const } : item))
    );
  };

  const approveLeave = (id: string) => {
    setLeaveRequests((prev) =>
      prev.map((item) =>
        item.id === id
          ? {
              ...item,
              status: 'Approved' as const,
              reviewedBy: user.name,
              reviewedAt: 'Today',
            }
          : item
      )
    );
  };

  const rejectLeave = (id: string, reason: string) => {
    setLeaveRequests((prev) =>
      prev.map((item) =>
        item.id === id
          ? {
              ...item,
              status: 'Rejected' as const,
              reviewedBy: user.name,
              reviewedAt: 'Today',
              rejectionReason: reason,
            }
          : item
      )
    );
  };

  // Attendance Correction
  const requestAttendanceCorrection = (date: string, reqIn: string, reqOut: string, reason: string) => {
    const newReq: SelfServiceRequest = {
      id: `req-${Date.now()}`,
      requestType: 'Attendance Correction',
      appliedDate: 'Just now',
      description: `Correction for ${date}: Requested In ${reqIn}, Out ${reqOut}. Reason: ${reason}`,
      status: 'Pending',
    };
    setRequests((prev) => [newReq, ...prev]);
  };

  // Helpdesk
  const createTicket = (
    subject: string,
    category: HelpdeskTicket['category'],
    priority: HelpdeskTicket['priority'],
    description: string
  ) => {
    const newTicket: HelpdeskTicket = {
      id: `tk-${Date.now()}`,
      ticketNumber: `TKT-${Math.floor(1000 + Math.random() * 9000)}`,
      subject,
      category,
      priority,
      status: 'Open',
      createdAt: 'Just now',
      description,
      messages: [
        {
          id: `msg-${Date.now()}`,
          senderName: user.name,
          senderAvatar: user.avatar,
          isStaff: false,
          text: description,
          timestamp: 'Just now',
        },
      ],
    };
    setTickets((prev) => [newTicket, ...prev]);
  };

  const replyToTicket = (ticketId: string, text: string) => {
    setTickets((prev) =>
      prev.map((tk) => {
        if (tk.id === ticketId) {
          return {
            ...tk,
            status: 'In Progress',
            messages: [
              ...tk.messages,
              {
                id: `msg-${Date.now()}`,
                senderName: user.name,
                senderAvatar: user.avatar,
                isStaff: false,
                text,
                timestamp: 'Just now',
              },
            ],
          };
        }
        return tk;
      })
    );
  };

  // Self service requests
  const createSelfServiceRequest = (type: SelfServiceRequest['requestType'], description: string) => {
    const newReq: SelfServiceRequest = {
      id: `req-${Date.now()}`,
      requestType: type,
      appliedDate: 'Just now',
      description,
      status: 'Pending',
    };
    setRequests((prev) => [newReq, ...prev]);
  };

  // Notifications
  const markNotificationRead = (id: string) => {
    setNotifications((prev) =>
      prev.map((n) => (n.id === id ? { ...n, isRead: true } : n))
    );
  };

  const markAllNotificationsRead = () => {
    setNotifications((prev) => prev.map((n) => ({ ...n, isRead: true })));
  };

  const login = () => {
    setIsAuthenticated(true);
    setActiveScreen('home');
  };

  const signUp = (name: string, email: string, userRole: UserRole, department: string) => {
    const newUser: User = {
      id: `usr-${Date.now()}`,
      employeeId: `EMP-${Math.floor(1000 + Math.random() * 9000)}`,
      name,
      email,
      department: department || 'Engineering',
      designation: userRole === 'MANAGER' ? 'Engineering Manager' : 'Software Engineer',
      avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
      role: userRole,
      joiningDate: 'Today',
      employmentType: 'Full-time',
      managerName: userRole === 'MANAGER' ? undefined : 'Sarah Jenkins',
    };
    setUser(newUser);
    setRoleState(userRole);
    setIsAuthenticated(true);
    setActiveScreen('home');
  };

  const logout = () => {
    setIsAuthenticated(false);
    setActiveScreen('login');
  };

  return (
    <AppContext.Provider
      value={{
        role,
        user,
        setRole,
        activeScreen,
        setActiveScreen,
        navigationHistory,
        navigateTo,
        goBack,
        appStateMode,
        setAppStateMode,
        isDarkMode,
        toggleDarkMode,
        deviceFrame,
        setDeviceFrame,
        showFlutterSpec,
        setShowFlutterSpec,
        clockStatus,
        clockInTime,
        clockOutTime,
        liveTimerSeconds,
        handleClockIn,
        handleClockOut,
        leaveBalances,
        leaveRequests,
        applyLeave,
        cancelLeave,
        approveLeave,
        rejectLeave,
        attendanceRecords,
        requestAttendanceCorrection,
        tickets,
        createTicket,
        replyToTicket,
        requests,
        createSelfServiceRequest,
        notifications,
        markNotificationRead,
        markAllNotificationsRead,
        teamMembers,
        isAuthenticated,
        login,
        signUp,
        logout,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};
