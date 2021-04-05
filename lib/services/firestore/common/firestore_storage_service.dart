import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirestoreStorageService {
  final StorageReference storageReference = FirebaseStorage.instance.ref();

  Future<String> uploadImage({@required File img, @required String storageBucket, @required String folderName, @required String fileName}) async {
    StorageReference ref = storageReference.child(storageBucket).child(folderName).child(fileName);
    StorageUploadTask uploadTask = ref.putFile(img);
    await uploadTask;
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  deleteImage({@required String storageBucket, @required String folderName, @required String fileName}) async {
    StorageReference storageReference = FirebaseStorage.instance.ref();
    storageReference.child(storageBucket).child(folderName).child(fileName).delete().catchError((e) {});
  }
}
