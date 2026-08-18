import '../models/user_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile_update_request_model.dart';
class UserService {
  UserService({
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService();

  final FirestoreService _firestore;
  final AuthService _auth;

  static const String collectionName = 'users';

  // ---------------------------------------------------------------------------
  // Current User ID
  // ---------------------------------------------------------------------------

  String get _uid {
    final uid = _auth.currentUserId;

    if (uid == null || uid.isEmpty) {
      throw StateError('No authenticated user.');
    }

    return uid;
  }

  // ---------------------------------------------------------------------------
  // Get Current User
  // ---------------------------------------------------------------------------

  Future<UserModel?> getCurrentUser() {
    return getUserById(_uid);
  }

  // ---------------------------------------------------------------------------
  // Get User By Firebase UID
  // ---------------------------------------------------------------------------

  Future<UserModel?> getUserById(String uid) async {
    final snapshot = await _firestore.getDocument(
      '$collectionName/$uid',
    );

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return UserModel.fromMap({
      ...snapshot.data()!,
      'id': snapshot.id,
    });
  }

  // ---------------------------------------------------------------------------
  // Watch Current User
  // ---------------------------------------------------------------------------

  Stream<UserModel?> watchCurrentUser() {
    return _firestore
        .watchDocument('$collectionName/$_uid')
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return UserModel.fromMap({
        ...snapshot.data()!,
        'id': snapshot.id,
      });
    });
  }

  // ---------------------------------------------------------------------------
  // Create / Update User
  // ---------------------------------------------------------------------------

  Future<void> createOrUpdateUser(UserModel user) {
    return _firestore.setDocument(
      '$collectionName/${user.id}',
      user.toMap(),
    );
  }
  Future<void> submitProfileUpdateRequest({
    String? name,
    String? phone,
  }) async {
    final user = await getCurrentUser();

    if (user == null) {
      throw Exception('User profile not found');
    }

    final requestedChanges = <String, dynamic>{};

    if (name != null && name.trim().isNotEmpty) {
      requestedChanges['name'] = name.trim();
    }

    if (phone != null && phone.trim().isNotEmpty) {
      requestedChanges['phone'] = phone.trim();
    }

    if (requestedChanges.isEmpty) {
      throw Exception('No changes submitted');
    }

    final request = ProfileUpdateRequestModel(
      id: '',
      employeeId: _uid,
      employeeName: user.name,
      requestedChanges: requestedChanges,
      status: 'pending',
      requestedAt: DateTime.now(),
    );
    await _firestore.setDocument(
      'profile_update_requests/$_uid',
      request.toFirestore(),
    );
  }

  // ---------------------------------------------------------------------------
  // Update Current User Profile
  // ---------------------------------------------------------------------------

  Future<void> updateProfile({
    String? name,
    String? avatar,
    String? phone,
    String? dob,
    String? address,
    EmergencyContact? emergencyContact,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) {
      data['name'] = name;
    }

    if (avatar != null) {
      data['avatar'] = avatar;
    }

    if (phone != null) {
      data['phone'] = phone;
    }

    if (dob != null) {
      data['dob'] = dob;
    }

    if (address != null) {
      data['address'] = address;
    }

    if (emergencyContact != null) {
      data['emergencyContact'] = emergencyContact.toMap();
    }

    if (data.isEmpty) {
      return;
    }

    await _firestore.updateDocument(
      '$collectionName/$_uid',
      data,
    );
  }

  // ---------------------------------------------------------------------------
  // Get User By Employee ID
  // ---------------------------------------------------------------------------

  Future<UserModel?> getUserByEmployeeId(
      String employeeId,
      ) async {
    final snapshot = await _firestore
        .collection(collectionName)
        .where(
      'employeeId',
      isEqualTo: employeeId,
    )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return UserModel.fromMap({
      ...doc.data(),
      'id': doc.id,
    });
  }
}
