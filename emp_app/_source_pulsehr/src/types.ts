export type UserRole = 'EMPLOYEE' | 'MANAGER';

export type AppStateMode = 'normal' | 'loading' | 'empty' | 'error' | 'offline';

export type ScreenId =
  | 'splash'
  | 'login'
  | 'home'
  | 'attendance'
  | 'leave'
  | 'manager_leave_approvals'
  | 'my_team'
  | 'team_attendance'
  | 'team_performance'
  | 'payslips'
  | 'performance'
  | 'helpdesk'
  | 'calendar'
  | 'requests'
  | 'announcements'
  | 'documents'
  | 'notifications'
  | 'profile'
  | 'settings'
  | 'more';

export interface User {
  id: string;
  name: string;
  email: string;
  avatar: string;
  designation: string;
  department: string;
  employeeId: string;
  role: UserRole;
  joiningDate: string;
  employmentType: string;
  managerName?: string;
  phone?: string;
  dob?: string;
  address?: string;
  emergencyContact?: {
    name: string;
    relationship: string;
    phone: string;
  };
}

export type AttendanceStatus = 'Not Checked In' | 'Working' | 'Completed' | 'Late' | 'Half Day' | 'Absent' | 'On Leave';

export interface AttendanceRecord {
  id: string;
  date: string; // YYYY-MM-DD
  status: 'Present' | 'Late' | 'Half Day' | 'Absent' | 'On Leave';
  clockIn?: string; // HH:mm AM/PM
  clockOut?: string; // HH:mm AM/PM
  totalHours?: string;
  breakDuration?: string;
  notes?: string;
  isCorrectionRequested?: boolean;
}

export interface AttendanceCorrectionRequest {
  id: string;
  date: string;
  existingClockIn?: string;
  existingClockOut?: string;
  requestedClockIn: string;
  requestedClockOut: string;
  reason: string;
  status: 'Pending' | 'Approved' | 'Rejected';
  createdAt: string;
}

export type LeaveType = 'Paid Leave' | 'Casual Leave' | 'Sick Leave' | 'Maternity/Paternity';

export interface LeaveBalance {
  type: LeaveType;
  total: number;
  used: number;
  remaining: number;
  color: string;
}

export interface LeaveRequest {
  id: string;
  employeeId: string;
  employeeName: string;
  employeeAvatar: string;
  department: string;
  leaveType: LeaveType;
  startDate: string;
  endDate: string;
  totalDays: number;
  reason: string;
  attachmentName?: string;
  status: 'Pending' | 'Approved' | 'Rejected' | 'Cancelled';
  appliedDate: string;
  reviewedBy?: string;
  reviewedAt?: string;
  rejectionReason?: string;
}

export interface Payslip {
  id: string;
  month: string;
  year: number;
  netSalary: number;
  grossSalary: number;
  totalDeductions: number;
  status: 'Paid' | 'Processing';
  issueDate: string;
  earnings: {
    basic: number;
    hra: number;
    transport: number;
    specialAllowance: number;
  };
  deductions: {
    pf: number;
    tax: number;
    insurance: number;
  };
}

export interface Goal {
  id: string;
  title: string;
  description: string;
  kpi: string;
  target: string;
  currentValue: string;
  progressPercent: number;
  deadline: string;
  status: 'On Track' | 'At Risk' | 'Completed' | 'Pending';
  managerComments?: string;
  assignedToName?: string;
}

export interface PerformanceReview {
  id: string;
  period: string;
  overallRating: number; // 1-5
  status: 'Completed' | 'Pending Review';
  strengths: string[];
  areasForImprovement: string[];
  managerFeedback: string;
  employeeComments?: string;
  reviewDate: string;
}

export interface HelpdeskTicket {
  id: string;
  ticketNumber: string;
  subject: string;
  category: 'IT Support' | 'HR Query' | 'Payroll' | 'Facilities' | 'Other';
  priority: 'Low' | 'Medium' | 'High' | 'Urgent';
  status: 'Open' | 'In Progress' | 'Resolved';
  createdAt: string;
  description: string;
  messages: {
    id: string;
    senderName: string;
    senderAvatar: string;
    isStaff: boolean;
    text: string;
    timestamp: string;
  }[];
}

export interface Announcement {
  id: string;
  title: string;
  summary: string;
  content: string;
  publishedDate: string;
  category: 'Company' | 'Policy' | 'Event' | 'HR Notice';
  priority: 'High' | 'Normal';
  isRead: boolean;
  author: string;
}

export interface CalendarEvent {
  id: string;
  title: string;
  date: string; // YYYY-MM-DD
  type: 'Holiday' | 'Leave' | 'Company Event' | 'Deadline';
  description?: string;
  color: string;
}

export interface SelfServiceRequest {
  id: string;
  requestType:
    | 'Attendance Correction'
    | 'Employment Certificate'
    | 'Document Request'
    | 'Profile Update'
    | 'Bank Detail Change';
  appliedDate: string;
  description: string;
  status: 'Pending' | 'Approved' | 'Rejected' | 'Completed';
  comments?: string;
  attachmentName?: string;
}

export interface EmployeeDocument {
  id: string;
  name: string;
  category: 'My Documents' | 'Company Policies' | 'Payslips' | 'Certificates';
  dateAdded: string;
  fileType: 'PDF' | 'DOCX' | 'JPG' | 'PNG';
  fileSize: string;
  url?: string;
}

export interface AppNotification {
  id: string;
  title: string;
  description: string;
  timestamp: string;
  category: 'Leave' | 'Attendance' | 'Payroll' | 'Performance' | 'Announcements' | 'Helpdesk' | 'Requests';
  isRead: boolean;
  targetScreen?: ScreenId;
}

export interface TeamMember {
  id: string;
  name: string;
  avatar: string;
  designation: string;
  department: string;
  joiningDate: string;
  email: string;
  phone: string;
  statusToday: 'Present' | 'Late' | 'On Leave' | 'Work From Home' | 'Absent';
  clockInTime?: string;
  clockOutTime?: string;
  workingHoursToday?: string;
  pendingLeavesCount: number;
  goalCompletionRate: number;
  rating: number;
}
