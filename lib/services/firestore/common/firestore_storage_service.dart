import 'dart:async';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/foundation.dart';

class FirestoreStorageService {
  fb.UploadTask uploadTask;
  fb.UploadTaskSnapshot uploadTaskSnapshot;

  Future<String> uploadImage({@required File imgFile, @required String storageBucket, @required String folderName, @required String fileName}) async {
    String imgURL;
    uploadTask = fb.storage().refFromURL("gs://webblen-events.appspot.com").child(storageBucket).child(folderName).child(fileName).put(imgFile);
    uploadTaskSnapshot = await uploadTask.future;
    imgURL = await (await uploadTaskSnapshot.ref.getDownloadURL()).toString();
    return imgURL;
  }

  deleteImage({@required String storageBucket, @required String folderName, @required String fileName}) async {
    fb.storage().refFromURL("gs://webblen-events.appspot.com").child(storageBucket).child(folderName).child(fileName).delete().catchError((e) {});
  }
}
