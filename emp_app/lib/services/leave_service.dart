import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/leave_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'user_service.dart';

class LeaveService {
  LeaveService({
    FirestoreService? firestoreService,
    AuthService? authService,
    UserService? userService,
  }) : _firestore = firestoreService ?? FirestoreService(),
       _auth = authService ?? AuthService(),
       _userService = userService ?? UserService();

  final FirestoreService _firestore;
  final AuthService _auth;
  final UserService _userService;

  static const String requestsCollection = 'leave_requests';
  static const String balancesCollection = 'leave_balances';

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
  // Leave Balances
  // ---------------------------------------------------------------------------

  Future<List<LeaveBalance>> getMyLeaveBalances() async {
    final snapshot = await _firestore
        .collection(balancesCollection)
        .where('employeeId', isEqualTo: _uid)
        .get();

    return snapshot.docs
        .map((doc) => LeaveBalance.fromMap(doc.data()))
        .toList();
  }

  Stream<List<LeaveBalance>> watchMyLeaveBalances() {
    return _firestore
        .collection(balancesCollection)
        .where('employeeId', isEqualTo: _uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LeaveBalance.fromMap(doc.data()))
              .toList(),
        );
  }

  // ---------------------------------------------------------------------------
  // Apply Leave
  // ---------------------------------------------------------------------------

  Future<String> applyLeave(LeaveRequest request) async {
    final id = request.id.isEmpty
        ? _firestore.newId(requestsCollection)
        : request.id;

    await _firestore.setDocument('$requestsCollection/$id', {
      ...request.toMap(),
      'id': id,
      'employeeId': _uid,
      'status': 'Pending',
      'appliedDate': request.appliedDate.isEmpty
          ? DateTime.now().toIso8601String()
          : request.appliedDate,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return id;
  }

  // ---------------------------------------------------------------------------
  // My Leave Requests
  // ---------------------------------------------------------------------------

  Future<List<LeaveRequest>> getMyLeaves() async {
    final snapshot = await _firestore
        .collection(requestsCollection)
        .where('employeeId', isEqualTo: _uid)
        .get();

    final requests = snapshot.docs
        .map((doc) => LeaveRequest.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
    requests.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
    return requests;
  }

  Stream<List<LeaveRequest>> watchMyLeaves() {
    return _firestore
        .collection(requestsCollection)
        .where('employeeId', isEqualTo: _uid)
        .snapshots()
        .map((snapshot) {
          final requests = snapshot.docs
              .map((doc) => LeaveRequest.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
          requests.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
          return requests;
        });
  }

  // ---------------------------------------------------------------------------
  // Cancel Leave
  // ---------------------------------------------------------------------------

  Future<void> cancelLeave(String requestId) {
    return _firestore.updateDocument('$requestsCollection/$requestId', {
      'status': 'Cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ---------------------------------------------------------------------------
  // Manager - Pending Leave Approvals
  // ---------------------------------------------------------------------------

  Future<List<LeaveRequest>> getPendingApprovals() async {
    final snapshot = await _firestore
        .collection(requestsCollection)
        .where('status', isEqualTo: 'Pending')
        .get();

    final requests =
        snapshot.docs
            .map((doc) => LeaveRequest.fromMap({...doc.data(), 'id': doc.id}))
            .where((request) => request.employeeId != _uid)
            .toList()
          ..sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
    return requests;
  }

  Stream<List<LeaveRequest>> watchPendingApprovals() {
    return _firestore
        .collection(requestsCollection)
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        LeaveRequest.fromMap({...doc.data(), 'id': doc.id}),
                  )
                  .where((request) => request.employeeId != _uid)
                  .toList()
                ..sort((a, b) => b.appliedDate.compareTo(a.appliedDate)),
        );
  }

  // ---------------------------------------------------------------------------
  // Approve Leave
  // ---------------------------------------------------------------------------

  Future<void> approveLeave(String requestId) {
    return _reviewLeave(requestId, 'Approved');
  }

  // ---------------------------------------------------------------------------
  // Reject Leave
  // ---------------------------------------------------------------------------

  Future<void> rejectLeave(String requestId, {String? reason}) {
    return _reviewLeave(requestId, 'Rejected', rejectionReason: reason);
  }

  // ---------------------------------------------------------------------------
  // Review Leave
  // ---------------------------------------------------------------------------

  Future<void> _reviewLeave(
    String id,
    String status, {
    String? rejectionReason,
  }) async {
    final reviewer = await _userService.getCurrentUser();
    if (reviewer?.role != UserRole.manager) {
      throw StateError('Only managers can review leave requests.');
    }

    final requestRef = _firestore.document('$requestsCollection/$id');
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(requestRef);
      final request = snapshot.data();

      if (!snapshot.exists || request == null) {
        throw StateError('Leave request no longer exists.');
      }
      if (request['employeeId'] == _uid) {
        throw StateError('You cannot review your own leave request.');
      }
      if (request['status'] != 'Pending') {
        throw StateError('This leave request has already been reviewed.');
      }

      transaction.update(requestRef, {
        'status': status,
        'reviewedBy': _uid,
        'reviewedAt': DateTime.now().toIso8601String(),
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
