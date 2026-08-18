import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/notification_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class NotificationService {
  NotificationService({
    FirestoreService? firestoreService,
    AuthService? authService,
    FirebaseMessaging? messaging,
  })  : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService(),
        _messaging = messaging ?? FirebaseMessaging.instance;

  final FirestoreService _firestore;
  final AuthService _auth;
  final FirebaseMessaging _messaging;

  static const String collectionName = 'notifications';

  String get _uid {
    final uid = _auth.currentUserId;

    if (uid == null) {
      throw StateError('No authenticated user.');
    }

    return uid;
  }

  // ------------------------------------------------------------
  // FCM INITIALIZATION
  // ------------------------------------------------------------

  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken();

    if (token != null) {
      await saveFcmToken(token);
    }

    _messaging.onTokenRefresh.listen(saveFcmToken);
  }

  // ------------------------------------------------------------
  // FCM TOKEN
  // ------------------------------------------------------------

  Future<void> saveFcmToken(String token) {
    return _firestore.setDocument(
      'users/$_uid/device_tokens/${_safeTokenId(token)}',
      {
        'token': token,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  // ------------------------------------------------------------
  // GET NOTIFICATIONS
  // ------------------------------------------------------------

  Future<List<AppNotification>> getMyNotifications() async {
    final snapshot = await _firestore
        .collection(collectionName)
        .where(
      'employeeId',
      isEqualTo: _uid,
    )
        .get();

    final notifications = snapshot.docs
        .map(
          (doc) => AppNotification.fromMap({
        ...doc.data(),
        'id': doc.id,
      }),
    )
        .toList();

    notifications.sort(
          (a, b) => b.timestamp.compareTo(a.timestamp),
    );

    return notifications;
  }

  // ------------------------------------------------------------
  // REAL-TIME NOTIFICATIONS
  // ------------------------------------------------------------

  Stream<List<AppNotification>> watchMyNotifications() {
    return _firestore
        .collection(collectionName)
        .where(
      'employeeId',
      isEqualTo: _uid,
    )
        .snapshots()
        .map((snapshot) {
      final notifications = snapshot.docs
          .map(
            (doc) => AppNotification.fromMap({
          ...doc.data(),
          'id': doc.id,
        }),
      )
          .toList();

      notifications.sort(
            (a, b) => b.timestamp.compareTo(a.timestamp),
      );

      return notifications;
    });
  }

  // ------------------------------------------------------------
  // MARK AS READ
  // ------------------------------------------------------------

  Future<void> markAsRead(String id) {
    return _firestore.updateDocument(
      '$collectionName/$id',
      {
        'isRead': true,
      },
    );
  }

  // ------------------------------------------------------------
  // MARK ALL AS READ
  // ------------------------------------------------------------

  Future<void> markAllAsRead() async {
    final snapshot = await _firestore
        .collection(collectionName)
        .where(
      'employeeId',
      isEqualTo: _uid,
    )
        .where(
      'isRead',
      isEqualTo: false,
    )
        .get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(
        doc.reference,
        {
          'isRead': true,
        },
      );
    }

    await batch.commit();
  }

  // ------------------------------------------------------------
  // DELETE NOTIFICATION
  // ------------------------------------------------------------

  Future<void> deleteNotification(String id) {
    return _firestore.deleteDocument(
      '$collectionName/$id',
    );
  }

  // ------------------------------------------------------------
  // CREATE NOTIFICATION
  // ------------------------------------------------------------

  Future<String> createNotification({
    required String employeeId,
    required String title,
    required String description,
    required NotificationCategory category,
    ScreenId? targetScreen,
  }) async {
    final doc = await _firestore
        .collection(collectionName)
        .add({
      'employeeId': employeeId,
      'title': title,
      'description': description,
      'timestamp': DateTime.now().toIso8601String(),
      'category': notificationCategoryToString(category),
      'isRead': false,
      'targetScreen': targetScreen != null
          ? screenIdToString(targetScreen)
          : null,
    });

    return doc.id;
  }

  // ------------------------------------------------------------
  // CREATE NOTIFICATION FOR CURRENT USER
  // ------------------------------------------------------------

  Future<String> createMyNotification({
    required String title,
    required String description,
    required NotificationCategory category,
    ScreenId? targetScreen,
  }) {
    return createNotification(
      employeeId: _uid,
      title: title,
      description: description,
      category: category,
      targetScreen: targetScreen,
    );
  }

  // ------------------------------------------------------------
  // FCM TOKEN DOCUMENT ID
  // ------------------------------------------------------------

  String _safeTokenId(String token) {
    final sanitized = token.replaceAll(
      RegExp(r'[^A-Za-z0-9_-]'),
      '_',
    );

    return sanitized.substring(
      0,
      sanitized.length > 100 ? 100 : sanitized.length,
    );
  }
}