import 'auth_service.dart';
import 'firestore_service.dart';

class SettingsService {
  SettingsService({
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService();

  final FirestoreService _firestore;
  final AuthService _auth;

  Future<Map<String, dynamic>> getSettings() async {
    final userId = _auth.currentUserId;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final snapshot = await _firestore.getDocument(
      'users/$userId',
    );

    if (!snapshot.exists) {
      return _defaultSettings();
    }

    final data = snapshot.data();

    if (data == null) {
      return _defaultSettings();
    }

    final settings = data['settings'];

    if (settings is Map<String, dynamic>) {
      return {
        ..._defaultSettings(),
        ...settings,
      };
    }

    return _defaultSettings();
  }

  Future<void> updateSetting(
      String key,
      dynamic value,
      ) async {
    final userId = _auth.currentUserId;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    await _firestore.updateDocument(
      'users/$userId',
      {
        'settings.$key': value,
      },
    );
  }

  Future<void> updateSettings(
      Map<String, dynamic> settings,
      ) async {
    final userId = _auth.currentUserId;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final data = <String, dynamic>{};

    settings.forEach((key, value) {
      data['settings.$key'] = value;
    });

    await _firestore.updateDocument(
      'users/$userId',
      data,
    );
  }

  Map<String, dynamic> _defaultSettings() {
    return {
      'pushNotifications': true,
      'emailNotifications': true,
      'biometricSignIn': false,
      'language': 'English',
    };
  }
}