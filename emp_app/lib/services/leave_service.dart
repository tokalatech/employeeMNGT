import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/leave_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class LeaveService {
  LeaveService({FirestoreService? firestoreService, AuthService? authService,UserService? userService,})
      : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService(),
        _userService = userService ?? UserService();

  final FirestoreService _firestore;
  final UserService _userService;
  final AuthService _auth;
  static const String requestsCollection = 'leave_requests';
  static const String balancesCollection = 'leave_balances';

  String get _uid {
    final uid = _auth.currentUserId;
    if (uid == null) throw StateError('No authenticated user.');
    return uid;
  }

  Future<List<LeaveBalance>> getMyLeaveBalances() async {
    final snapshot = await _firestore.collection(balancesCollection)
        .where('employeeId', isEqualTo: _uid).get();
    return snapshot.docs.map((doc) => LeaveBalance.fromMap(doc.data())).toList();
  }

  Stream<List<LeaveBalance>> watchMyLeaveBalances() {
    return _firestore.collection(balancesCollection)
        .where('employeeId', isEqualTo: _uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => LeaveBalance.fromMap(doc.data())).toList());
  }

  Future<String> applyLeave(LeaveRequest request) async {
    final id = request.id.isEmpty ? _firestore.newId(requestsCollection) : request.id;

    // Fall back to the signed-in user's profile managerId if the caller
    // didn't already resolve one (defensive — keeps approvals working even
    // if a future call site forgets to set it, same as employeeId below).
    var managerId = request.managerId;
    if (managerId == null || managerId.isEmpty) {
      final profile = await _userService.getCurrentUser();
      managerId = profile?.managerId ?? '';
    }

    await _firestore.setDocument('$requestsCollection/$id', {
      ...request.toMap(),
      'id': id,
      'employeeId': _uid,
      'managerId': managerId,
      'status': 'Pending',
      'appliedDate': request.appliedDate.isEmpty ? DateTime.now().toIso8601String() : request.appliedDate,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return id;
  }

  Future<List<LeaveRequest>> getMyLeaves() async {
    final snapshot = await _firestore.collection(requestsCollection)
        .where('employeeId', isEqualTo: _uid)
        .orderBy('appliedDate', descending: true).get();
    return snapshot.docs.map((doc) => LeaveRequest.fromMap({...doc.data(), 'id': doc.id})).toList();
  }

  Stream<List<LeaveRequest>> watchMyLeaves() {
    return _firestore.collection(requestsCollection)
        .where('employeeId', isEqualTo: _uid)
        .orderBy('appliedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => LeaveRequest.fromMap({...doc.data(), 'id': doc.id})).toList());
  }

  Future<void> cancelLeave(String requestId) => _firestore.updateDocument(
    '$requestsCollection/$requestId',
    {'status': 'Cancelled', 'updatedAt': FieldValue.serverTimestamp()},
  );

  Future<List<LeaveRequest>> getPendingApprovals() async {
    final snapshot = await _firestore.collection(requestsCollection)
        .where('managerId', isEqualTo: _uid)
        .where('status', isEqualTo: 'Pending')
        .orderBy('appliedDate', descending: true).get();
    return snapshot.docs.map((doc) => LeaveRequest.fromMap({...doc.data(), 'id': doc.id})).toList();
  }

  Stream<List<LeaveRequest>> watchPendingApprovals() {
    return _firestore.collection(requestsCollection)
        .where('managerId', isEqualTo: _uid)
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => LeaveRequest.fromMap({...doc.data(), 'id': doc.id})).toList());
  }

  Future<void> approveLeave(String requestId) => _reviewLeave(requestId, 'Approved');

  Future<void> rejectLeave(String requestId, {String? reason}) =>
      _reviewLeave(requestId, 'Rejected', rejectionReason: reason);

  Future<void> _reviewLeave(String id, String status, {String? rejectionReason}) =>
      _firestore.updateDocument('$requestsCollection/$id', {
        'status': status,
        'reviewedBy': _uid,
        'reviewedAt': DateTime.now().toIso8601String(),
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
        'updatedAt': FieldValue.serverTimestamp(),
      });
}
