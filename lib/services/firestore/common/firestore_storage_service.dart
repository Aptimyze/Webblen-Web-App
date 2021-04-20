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
            contentType: "image/png",
            cacheControl: 'public, max-age=3600, s-maxage=3600',
          ),
        );
    uploadTaskSnapshot = await uploadTask.future;
    imgURL = await (await uploadTaskSnapshot.ref.getDownloadURL()).toString();
    return imgURL;
  }

  deleteImage({required String storageBucket, required String folderName, required String fileName}) async {
    fb.storage().refFromURL("gs://webblen-events.appspot.com").child(storageBucket).child(folderName).child(fileName).delete().catchError((e) {});
  }
}
