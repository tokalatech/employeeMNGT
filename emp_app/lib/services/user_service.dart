import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class UserService {
  UserService({FirestoreService? firestoreService, AuthService? authService})
      : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService();

  final FirestoreService _firestore;
  final AuthService _auth;

  static const String collectionName = 'users';

  String get _uid {
    final uid = _auth.currentUserId;
    if (uid == null) throw StateError('No authenticated user.');
    return uid;
  }

  Future<UserModel?> getCurrentUser() => getUserById(_uid);

  Future<UserModel?> getUserById(String uid) async {
    final snapshot = await _firestore.getDocument('$collectionName/$uid');
    if (!snapshot.exists || snapshot.data() == null) return null;
    return UserModel.fromMap({...snapshot.data()!, 'id': snapshot.id});
  }

  Stream<UserModel?> watchCurrentUser() {
    return _firestore.watchDocument('$collectionName/$_uid').map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return UserModel.fromMap({...snapshot.data()!, 'id': snapshot.id});
    });
  }

  Future<void> createOrUpdateUser(UserModel user) {
    return _firestore.setDocument(
      '$collectionName/${user.id}',
      user.toMap(),
    );
  }

  Future<void> updateProfile({
    String? name,
    String? avatar,
    String? phone,
    String? dob,
    String? address,
    EmergencyContact? emergencyContact,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (avatar != null) data['avatar'] = avatar;
    if (phone != null) data['phone'] = phone;
    if (dob != null) data['dob'] = dob;
    if (address != null) data['address'] = address;
    if (emergencyContact != null) {
      data['emergencyContact'] = emergencyContact.toMap();
    }
    if (data.isEmpty) return;
    await _firestore.updateDocument('$collectionName/$_uid', data);
  }

  Future<List<UserModel>> getTeamMembers() async {
    final snapshot = await _firestore.collection(collectionName)
        .where('managerId', isEqualTo: _uid)
        .get();
    return snapshot.docs
        .map((doc) => UserModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Stream<List<UserModel>> watchTeamMembers() {
    return _firestore.collection(collectionName)
        .where('managerId', isEqualTo: _uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList());
  }

  Future<UserModel?> getUserByEmployeeId(String employeeId) async {
    final snapshot = await _firestore.collection(collectionName)
        .where('employeeId', isEqualTo: employeeId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return UserModel.fromMap({...doc.data(), 'id': doc.id});
  }
}
