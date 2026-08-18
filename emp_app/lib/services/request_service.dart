import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class RequestService {
  RequestService({
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService();

  final FirestoreService _firestore;
  final AuthService _auth;
  static const String collectionName = 'self_service_requests';

  String get _uid {
    final uid = _auth.currentUserId;
    if (uid == null) throw StateError('No authenticated user.');
    return uid;
  }

  Future<String> createRequest(SelfServiceRequest request) async {
    final id =
    request.id.isEmpty ? _firestore.newId(collectionName) : request.id;
    await _firestore.setDocument('$collectionName/$id', {
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

  Future<List<SelfServiceRequest>> getMyRequests() async {
    final snapshot = await _firestore
        .collection(collectionName)
        .where('employeeId', isEqualTo: _uid)
        .get();
    final list = snapshot.docs
        .map((doc) => SelfServiceRequest.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
    list.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
    return list;
  }

  Stream<List<SelfServiceRequest>> watchMyRequests() => _firestore
      .collection(collectionName)
      .where('employeeId', isEqualTo: _uid)
      .snapshots()
      .map((snapshot) {
    final list = snapshot.docs
        .map((doc) => SelfServiceRequest.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
    list.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
    return list;
  });

  Future<SelfServiceRequest?> getRequestById(String id) async {
    final snapshot = await _firestore.getDocument('$collectionName/$id');
    if (!snapshot.exists || snapshot.data() == null) return null;
    return SelfServiceRequest.fromMap({...snapshot.data()!, 'id': snapshot.id});
  }
}
