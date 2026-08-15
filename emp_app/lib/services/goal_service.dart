import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class GoalService {
  GoalService({FirestoreService? firestoreService, AuthService? authService})
      : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService();

  final FirestoreService _firestore;
  final AuthService _auth;
  static const String collectionName = 'goals';

  String get _uid {
    final uid = _auth.currentUserId;
    if (uid == null) throw StateError('No authenticated user.');
    return uid;
  }

  Future<List<Goal>> getMyGoals() async {
    final snapshot = await _firestore.collection(collectionName)
        .where('employeeId', isEqualTo: _uid).get();
    return snapshot.docs.map((doc) => Goal.fromMap({...doc.data(), 'id': doc.id})).toList();
  }

  Stream<List<Goal>> watchMyGoals() => _firestore.collection(collectionName)
      .where('employeeId', isEqualTo: _uid)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Goal.fromMap({...doc.data(), 'id': doc.id})).toList());

  Future<Goal?> getGoalById(String id) async {
    final snapshot = await _firestore.getDocument('$collectionName/$id');
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Goal.fromMap({...snapshot.data()!, 'id': snapshot.id});
  }

  Future<String> createGoal(Goal goal, {required String employeeId}) async {
    final id = goal.id.isEmpty ? _firestore.newId(collectionName) : goal.id;
    await _firestore.setDocument('$collectionName/$id', {
      ...goal.toMap(), 'id': id, 'employeeId': employeeId,
      'managerId': _uid, 'updatedAt': FieldValue.serverTimestamp(),
    });
    return id;
  }

  Future<void> updateProgress(String goalId, String currentValue, double progressPercent) =>
      _firestore.updateDocument('$collectionName/$goalId', {
        'currentValue': currentValue,
        'progressPercent': progressPercent,
        'status': progressPercent >= 100 ? 'Completed' : 'On Track',
        'updatedAt': FieldValue.serverTimestamp(),
      });
}
