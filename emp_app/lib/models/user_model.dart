enum UserRole {
  employee,
  manager,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String designation;
  final String department;
  final String employeeId;
  final UserRole role;
  final String joiningDate;
  final String employmentType;
  final String? managerName;
  final String? phone;
  final String? dob;
  final String? address;
  final EmergencyContact? emergencyContact;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.designation,
    required this.department,
    required this.employeeId,
    required this.role,
    required this.joiningDate,
    required this.employmentType,
    this.managerName,
    this.phone,
    this.dob,
    this.address,
    this.emergencyContact,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatar: map['avatar'] ?? '',
      designation: map['designation'] ?? '',
      department: map['department'] ?? '',
      employeeId: map['employeeId'] ?? '',
      role: map['role'] == 'MANAGER'
          ? UserRole.manager
          : UserRole.employee,
      joiningDate: map['joiningDate'] ?? '',
      employmentType: map['employmentType'] ?? '',
      managerName: map['managerName'],
      phone: map['phone'],
      dob: map['dob'],
      address: map['address'],
      emergencyContact: map['emergencyContact'] != null
          ? EmergencyContact.fromMap(
        Map<String, dynamic>.from(map['emergencyContact']),
      )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'designation': designation,
      'department': department,
      'employeeId': employeeId,
      'role': role == UserRole.manager ? 'MANAGER' : 'EMPLOYEE',
      'joiningDate': joiningDate,
      'employmentType': employmentType,
      'managerName': managerName,
      'phone': phone,
      'dob': dob,
      'address': address,
      'emergencyContact': emergencyContact?.toMap(),
    };
  }
}

class EmergencyContact {
  final String name;
  final String relationship;
  final String phone;

  EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
    };
  }
}

class TeamMember {
  final String id;
  final String name;
  final String avatar;
  final String designation;
  final String department;
  final String joiningDate;
  final String email;
  final String phone;
  final TeamMemberStatusToday statusToday;
  final String? clockInTime;
  final String? clockOutTime;
  final String? workingHoursToday;
  final int pendingLeavesCount;
  final double goalCompletionRate;
  final double rating;

  TeamMember({
    required this.id,
    required this.name,
    required this.avatar,
    required this.designation,
    required this.department,
    required this.joiningDate,
    required this.email,
    required this.phone,
    required this.statusToday,
    this.clockInTime,
    this.clockOutTime,
    this.workingHoursToday,
    required this.pendingLeavesCount,
    required this.goalCompletionRate,
    required this.rating,
  });

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      designation: map['designation'] ?? '',
      department: map['department'] ?? '',
      joiningDate: map['joiningDate'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      statusToday: TeamMemberStatusToday.values.firstWhere(
            (value) => value.name == _statusToEnum(map['statusToday']),
        orElse: () => TeamMemberStatusToday.absent,
      ),
      clockInTime: map['clockInTime'],
      clockOutTime: map['clockOutTime'],
      workingHoursToday: map['workingHoursToday'],
      pendingLeavesCount: map['pendingLeavesCount'] ?? 0,
      goalCompletionRate: (map['goalCompletionRate'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'designation': designation,
      'department': department,
      'joiningDate': joiningDate,
      'email': email,
      'phone': phone,
      'statusToday': _statusFromEnum(statusToday),
      'clockInTime': clockInTime,
      'clockOutTime': clockOutTime,
      'workingHoursToday': workingHoursToday,
      'pendingLeavesCount': pendingLeavesCount,
      'goalCompletionRate': goalCompletionRate,
      'rating': rating,
    };
  }

  static String _statusToEnum(dynamic value) {
    switch (value) {
      case 'Present':
        return 'present';
      case 'Late':
        return 'late';
      case 'On Leave':
        return 'onLeave';
      case 'Work From Home':
        return 'workFromHome';
      default:
        return 'absent';
    }
  }

  static String _statusFromEnum(TeamMemberStatusToday value) {
    switch (value) {
      case TeamMemberStatusToday.present:
        return 'Present';
      case TeamMemberStatusToday.late:
        return 'Late';
      case TeamMemberStatusToday.onLeave:
        return 'On Leave';
      case TeamMemberStatusToday.workFromHome:
        return 'Work From Home';
      case TeamMemberStatusToday.absent:
        return 'Absent';
    }
  }
}

enum TeamMemberStatusToday {
  present,
  late,
  onLeave,
  workFromHome,
  absent,
}