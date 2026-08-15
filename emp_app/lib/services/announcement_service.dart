import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/announcement_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class AnnouncementService {
  AnnouncementService({FirestoreService? firestoreService, AuthService? authService})
      : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService();

  final FirestoreService _firestore;
  final AuthService _auth;
  static const String collectionName = 'announcements';
  static const String readsCollection = 'announcement_reads';

  String get _uid {
    final uid = _auth.currentUserId;
    if (uid == null) throw StateError('No authenticated user.');
    return uid;
  }

  Future<List<Announcement>> getAnnouncements() async {
    final snapshot = await _firestore.collection(collectionName).orderBy('publishedDate', descending: true).get();
    final readIds = await _getReadIds();
    return snapshot.docs.map((doc) {
      final data = {...doc.data(), 'id': doc.id, 'isRead': readIds.contains(doc.id)};
      return Announcement.fromMap(data);
    }).toList();
  }

  Stream<List<Announcement>> watchAnnouncements() {
    return _firestore.collection(collectionName).orderBy('publishedDate', descending: true).snapshots().asyncMap((snapshot) async {
      final readIds = await _getReadIds();
      return snapshot.docs.map((doc) => Announcement.fromMap({...doc.data(), 'id': doc.id, 'isRead': readIds.contains(doc.id)})).toList();
    });
  }

  Future<Announcement?> getAnnouncementById(String id) async {
    final snapshot = await _firestore.getDocument('$collectionName/$id');
    if (!snapshot.exists || snapshot.data() == null) return null;
    final readIds = await _getReadIds();
    return Announcement.fromMap({...snapshot.data()!, 'id': snapshot.id, 'isRead': readIds.contains(id)});
  }

  Future<void> markAsRead(String announcementId) => _firestore.setDocument(
    '$readsCollection/${_uid}_$announcementId',
    {'userId': _uid, 'announcementId': announcementId, 'readAt': FieldValue.serverTimestamp()},
  );

  Future<Set<String>> _getReadIds() async {
    final snapshot = await _firestore.collection(readsCollection).where('userId', isEqualTo: _uid).get();
    return snapshot.docs.map((doc) => doc.data()['announcementId'] as String).toSet();
  }
}
