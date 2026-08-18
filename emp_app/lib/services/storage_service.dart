import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadBytes({
    required String path,
    required Uint8List bytes,
    String? contentType,
  }) async {
    try {
      if (bytes.isEmpty) {
        throw StateError('The selected file is empty.');
      }

      final ref = _storage.ref().child(path);

      final metadata = SettableMetadata(contentType: contentType);

      final uploadTask = ref.putData(bytes, metadata);

      try {
        await uploadTask.timeout(const Duration(seconds: 45));
      } on TimeoutException {
        await uploadTask.cancel();
        throw StateError(
          'Firebase Storage upload timed out. '
          'The upload was cancelled. Check your internet connection and '
          'try again with a smaller file. '
          'Please try again.',
        );
      }

      try {
        return await ref.getDownloadURL().timeout(const Duration(seconds: 30));
      } on TimeoutException {
        throw StateError(
          'File uploaded, but Firebase could not retrieve the download URL.',
        );
      }
    } on FirebaseException catch (e) {
      throw StateError(
        'Storage error: ${e.code}${e.message != null ? ' - ${e.message}' : ''}',
      );
    } catch (e) {
      if (e is StateError) {
        rethrow;
      }

      throw StateError('Unable to upload file: $e');
    }
  }

  Future<void> delete(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } on FirebaseException catch (e) {
      throw StateError(
        'Unable to delete file: ${e.code}${e.message != null ? ' - ${e.message}' : ''}',
      );
    }
  }

  Future<String> getDownloadUrl(String path) async {
    try {
      return await _storage
          .ref()
          .child(path)
          .getDownloadURL()
          .timeout(const Duration(seconds: 30));
    } on FirebaseException catch (e) {
      throw StateError(
        'Unable to get file URL: ${e.code}${e.message != null ? ' - ${e.message}' : ''}',
      );
    }
  }
}
