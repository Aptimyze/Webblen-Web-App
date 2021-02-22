import 'dart:html';

import 'package:auto_route/auto_route.dart';
import 'package:firebase/firebase.dart' as fb;

class FirestoreStorageService {
  fb.UploadTask uploadTask;
  fb.UploadTaskSnapshot uploadTaskSnapshot;

  Future<String> uploadImage({@required File img, @required String storageBucket, @required String folderName, @required String fileName}) async {
    String imgURL;
    uploadTask = fb.storage().refFromURL("gs://webblen-events.appspot.com").child(storageBucket).child(folderName).child(fileName).put(img);
    uploadTaskSnapshot = await uploadTask.future;
    imgURL = await (await uploadTaskSnapshot.ref.getDownloadURL()).toString();
    return imgURL;
  }

  deleteImage({@required String storageBucket, @required String folderName, @required String fileName}) async {
    fb.storage().refFromURL("gs://webblen-events.appspot.com").child(storageBucket).child(folderName).child(fileName).delete().catchError((e) {});
  }
}
