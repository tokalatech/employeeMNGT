import '../models/calendar_event_model.dart';
import 'firestore_service.dart';

class CalendarService {
  CalendarService({FirestoreService? firestoreService})
      : _firestore = firestoreService ?? FirestoreService();

  final FirestoreService _firestore;
  static const String collectionName = 'calendar_events';

  Future<List<CalendarEvent>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = _firestore.collection(collectionName).orderBy('date');
    if (startDate != null) {
      query = query.where('date', isGreaterThanOrEqualTo: _dateKey(startDate));
    }
    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: _dateKey(endDate));
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => CalendarEvent.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Stream<List<CalendarEvent>> watchEvents() => _firestore
      .collection(collectionName)
      .orderBy('date')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => CalendarEvent.fromMap({...doc.data(), 'id': doc.id}))
      .toList());

  Future<CalendarEvent?> getEventById(String id) async {
    final snapshot = await _firestore.getDocument('$collectionName/$id');
    if (!snapshot.exists || snapshot.data() == null) return null;
    return CalendarEvent.fromMap({...snapshot.data()!, 'id': snapshot.id});
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
