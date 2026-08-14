import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _firestore.collection(path);

  DocumentReference<Map<String, dynamic>> document(String path) =>
      _firestore.doc(path);

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String path) =>
      document(path).get();

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(String path) =>
      collection(path).get();

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDocument(String path) =>
      document(path).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(String path) =>
      collection(path).snapshots();

  Future<void> setDocument(
      String path,
      Map<String, dynamic> data, {
        bool merge = true,
      }) {
    return document(path).set(data, SetOptions(merge: merge));
  }

  Future<String> addDocument(
      String collectionPath,
      Map<String, dynamic> data,
      ) async {
    final ref = collection(collectionPath).doc();
    await ref.set({...data, 'id': ref.id});
    return ref.id;
  }

  Future<void> updateDocument(String path, Map<String, dynamic> data) =>
      document(path).update(data);

  Future<void> deleteDocument(String path) => document(path).delete();

  WriteBatch batch() => _firestore.batch();

  Future<void> runTransaction(
      Future<void> Function(Transaction transaction) action,
      ) {
    return _firestore.runTransaction(action);
  }

  String newId(String collectionPath) => collection(collectionPath).doc().id;
}
