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
  final String? managerId;

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
    this.managerId
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
      managerId:map['managerId'],
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
      'managerId': managerId,
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
