import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/helpdesk_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class HelpdeskService {
  HelpdeskService({
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _firestore = firestoreService ?? FirestoreService(),
        _auth = authService ?? AuthService();

  final FirestoreService _firestore;
  final AuthService _auth;
  static const String ticketsCollection = 'helpdesk_tickets';
  static const String messagesSubcollection = 'messages';

  String get _uid {
    final uid = _auth.currentUserId;
    if (uid == null) throw StateError('No authenticated user.');
    return uid;
  }

  Future<List<HelpdeskTicket>> getMyTickets() async {
    final snapshot = await _firestore
        .collection(ticketsCollection)
        .where('employeeId', isEqualTo: _uid)
        .get();
    final list = await Future.wait(snapshot.docs.map(_ticketFromDoc));
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Stream<List<HelpdeskTicket>> watchMyTickets() {
    return _firestore
        .collection(ticketsCollection)
        .where('employeeId', isEqualTo: _uid)
        .snapshots()
        .asyncMap((snapshot) async {
      final list = await Future.wait(snapshot.docs.map(_ticketFromDoc));
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Future<HelpdeskTicket?> getTicketById(String id) async {
    final snapshot = await _firestore.getDocument('$ticketsCollection/$id');
    if (!snapshot.exists || snapshot.data() == null) return null;
    return _ticketFromData(snapshot.id, snapshot.data()!);
  }

  Future<String> createTicket(HelpdeskTicket ticket) async {
    final id =
    ticket.id.isEmpty ? _firestore.newId(ticketsCollection) : ticket.id;
    final ticketNumber = ticket.ticketNumber.isEmpty
        ? 'TKT-${DateTime.now().millisecondsSinceEpoch}'
        : ticket.ticketNumber;
    await _firestore.setDocument('$ticketsCollection/$id', {
      ...ticket.toMap(),
      'id': id,
      'ticketNumber': ticketNumber,
      'employeeId': _uid,
      'createdAt': ticket.createdAt.isEmpty
          ? DateTime.now().toIso8601String()
          : ticket.createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return id;
  }

  Future<String> addMessage(String ticketId, HelpdeskMessage message) async {
    final ref = _firestore
        .collection('$ticketsCollection/$ticketId/$messagesSubcollection')
        .doc();
    await ref.set({...message.toMap(), 'id': ref.id});
    await _firestore.updateDocument(
        '$ticketsCollection/$ticketId', {'updatedAt': FieldValue.serverTimestamp()});
    return ref.id;
  }

  Stream<List<HelpdeskMessage>> watchMessages(String ticketId) => _firestore
      .collection('$ticketsCollection/$ticketId/$messagesSubcollection')
      .snapshots()
      .map((snapshot) {
    final list = snapshot.docs
        .map((doc) => HelpdeskMessage.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  });

  Future<void> updateTicketStatus(String ticketId, HelpdeskStatus status) =>
      _firestore.updateDocument('$ticketsCollection/$ticketId', {
        'status': helpdeskStatusToString(status),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<HelpdeskTicket> _ticketFromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    return _ticketFromData(doc.id, doc.data());
  }

  HelpdeskTicket _ticketFromData(String id, Map<String, dynamic> data) {
    return HelpdeskTicket.fromMap({...data, 'id': id});
  }
}
