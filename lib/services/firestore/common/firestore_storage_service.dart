import 'dart:async';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;

class FirestoreStorageService {
  late fb.UploadTask uploadTask;
  late fb.UploadTaskSnapshot uploadTaskSnapshot;

  Future<String> uploadImage({required File? imgFile, required String storageBucket, required String folderName, required String fileName}) async {
    String imgURL = "";
    uploadTask = fb.storage().refFromURL("gs://webblen-events.appspot.com").child(storageBucket).child(folderName).child(fileName).put(
          imgFile,
          fb.UploadMetadata(
            contentType: "image/jpeg",
            cacheControl: 'public, max-age=3600, s-maxage=3600',
          ),
        );
    uploadTaskSnapshot = await uploadTask.future;

    int attempts = 0;

    while (attempts < 10 && imgURL.isEmpty) {
      await Future.delayed(Duration(milliseconds: 500));
      imgURL = await attemptToGetDownloadURL(storageBucket: storageBucket, folderName: folderName, fileName: fileName);
      attempts += 1;
    }
    return imgURL;
  }

  deleteImage({required String storageBucket, required String folderName, required String fileName}) async {
    fb.storage().refFromURL("gs://webblen-events.appspot.com").child(storageBucket).child(folderName).child(fileName + "_500x500").delete().catchError((e) {});
  }

  Future<String> attemptToGetDownloadURL({required String storageBucket, required String folderName, required String fileName}) async {
    String downloadURL = "";

    await fb
        .storage()
        .refFromURL("gs://webblen-events.appspot.com")
        .child(storageBucket)
        .child(folderName)
        .child(fileName + "_500x500")
        .getDownloadURL()
        .then((result) {
      downloadURL = result.toString();
    }).catchError((e) {
      print(e);
    });

    return downloadURL;
  }
}
