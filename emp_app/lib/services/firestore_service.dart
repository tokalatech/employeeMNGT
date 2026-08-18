import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // ---------------------------------------------------------------------------
  // References
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> document(String path) {
    return _firestore.doc(path);
  }

  // ---------------------------------------------------------------------------
  // Read - Single Document
  // ---------------------------------------------------------------------------

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
      String path,
      ) {
    return document(path).get();
  }

  // ---------------------------------------------------------------------------
  // Read - Collection
  // ---------------------------------------------------------------------------

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
      String path,
      ) {
    return collection(path).get();
  }

  // ---------------------------------------------------------------------------
  // Real-time - Single Document
  // ---------------------------------------------------------------------------

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDocument(
      String path,
      ) {
    return document(path).snapshots();
  }

  // ---------------------------------------------------------------------------
  // Real-time - Collection
  // ---------------------------------------------------------------------------

  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(
      String path,
      ) {
    return collection(path).snapshots();
  }

  // ---------------------------------------------------------------------------
  // Create / Set Document
  // ---------------------------------------------------------------------------

  Future<void> setDocument(
      String path,
      Map<String, dynamic> data, {
        bool merge = true,
      }) {
    return document(path).set(
      data,
      SetOptions(merge: merge),
    );
  }

  // ---------------------------------------------------------------------------
  // Add New Document With Auto-generated ID
  // ---------------------------------------------------------------------------

  Future<String> addDocument(
      String collectionPath,
      Map<String, dynamic> data,
      ) async {
    final ref = collection(collectionPath).doc();

    await ref.set({
      ...data,
      'id': ref.id,
    });

    return ref.id;
  }

  // ---------------------------------------------------------------------------
  // Update Document
  // ---------------------------------------------------------------------------

  Future<void> updateDocument(
      String path,
      Map<String, dynamic> data,
      ) {
    return document(path).update(data);
  }

  // ---------------------------------------------------------------------------
  // Delete Document
  // ---------------------------------------------------------------------------

  Future<void> deleteDocument(String path) {
    return document(path).delete();
  }

  // ---------------------------------------------------------------------------
  // Batch Operations
  // ---------------------------------------------------------------------------

  WriteBatch batch() {
    return _firestore.batch();
  }

  // ---------------------------------------------------------------------------
  // Transaction
  // ---------------------------------------------------------------------------

  Future<void> runTransaction(
      Future<void> Function(Transaction transaction) action,
      ) {
    return _firestore.runTransaction(action);
  }

  // ---------------------------------------------------------------------------
  // Generate New Firestore Document ID
  // ---------------------------------------------------------------------------

  String newId(String collectionPath) {
    return collection(collectionPath).doc().id;
  }
}