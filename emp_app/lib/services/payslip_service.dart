import '../models/payslip_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class PayslipService {
  PayslipService({FirestoreService? firestoreService, AuthService? authService})
      : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService();

  final FirestoreService _firestore;
  final AuthService _auth;
  static const String collectionName = 'payslips';

  String get _uid {
    final uid = _auth.currentUserId;
    print('PAYSLIP USER UID: $uid');
    if (uid == null) throw StateError('No authenticated user.');
    return uid;
  }

  Future<List<Payslip>> getMyPayslips() async {
    final snapshot = await _firestore
        .collection(collectionName)
        .where('employeeId', isEqualTo: _uid)
        .get();

    final payslips = snapshot.docs
        .map(
          (doc) => Payslip.fromMap({
        ...doc.data(),
        'id': doc.id,
      }),
    )
        .toList();

    payslips.sort((a, b) {
      final yearComparison = b.year.compareTo(a.year);

      if (yearComparison != 0) {
        return yearComparison;
      }

      return _monthNumber(b.month).compareTo(_monthNumber(a.month));
    });

    return payslips;
  }

  Stream<List<Payslip>> watchMyPayslips() {
    return _firestore
        .collection(collectionName)
        .where('employeeId', isEqualTo: _uid)
        .snapshots()
        .map((snapshot) {
      final payslips = snapshot.docs
          .map(
            (doc) => Payslip.fromMap({
          ...doc.data(),
          'id': doc.id,
        }),
      )
          .toList();

      payslips.sort((a, b) {
        final yearComparison = b.year.compareTo(a.year);

        if (yearComparison != 0) {
          return yearComparison;
        }

        return _monthNumber(b.month).compareTo(_monthNumber(a.month));
      });

      return payslips;
    });
  }

  int _monthNumber(String month) {
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    return months[month] ?? 0;
  }

  Future<Payslip?> getPayslipById(String id) async {
    final snapshot = await _firestore.getDocument('$collectionName/$id');
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Payslip.fromMap({...snapshot.data()!, 'id': snapshot.id});
  }
}


