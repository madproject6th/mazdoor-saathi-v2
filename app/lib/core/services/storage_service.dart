import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Firebase Storage uploads for progress photos.
/// Returns the download URL, or null when Storage is unavailable
/// (no Firebase config / offline) — callers then save a URL-less entry.
class StorageService {
  Future<String?> uploadProgressPhoto({
    required String jobId,
    required Uint8List bytes,
    String contentType = 'image/jpeg',
  }) async {
    try {
      final name =
          'progress/$jobId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(name);
      await ref.putData(bytes, SettableMetadata(contentType: contentType));
      return await ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }
}
