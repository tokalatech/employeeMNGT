import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/performance_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class PerformanceService {
  PerformanceService({FirestoreService? firestoreService, AuthService? authService})
      : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService();

  final FirestoreService _firestore;
  final AuthService _auth;
  static const String collectionName = 'performance_reviews';

  String get _uid {
    final uid = _auth.currentUserId;
    if (uid == null) throw StateError('No authenticated user.');
    return uid;
  }

  Future<List<PerformanceReview>> getMyReviews() async {
    final snapshot = await _firestore.collection(collectionName)
        .where('employeeId', isEqualTo: _uid).get();
    return snapshot.docs.map((doc) => PerformanceReview.fromMap({...doc.data(), 'id': doc.id})).toList();
  }

  Stream<List<PerformanceReview>> watchMyReviews() => _firestore.collection(collectionName)
      .where('employeeId', isEqualTo: _uid)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => PerformanceReview.fromMap({...doc.data(), 'id': doc.id})).toList());

  Future<void> addEmployeeComments(String reviewId, String comments) =>
      _firestore.updateDocument('$collectionName/$reviewId', {
        'employeeComments': comments,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<PerformanceReview?> getReviewById(String id) async {
    final snapshot = await _firestore.getDocument('$collectionName/$id');
    if (!snapshot.exists || snapshot.data() == null) return null;
    return PerformanceReview.fromMap({...snapshot.data()!, 'id': snapshot.id});
  }

}
