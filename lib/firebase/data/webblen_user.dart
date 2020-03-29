import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:webblen_web_app/firebase/services/image_upload.dart';
import 'package:webblen_web_app/models/webblen_user.dart';

class WebblenUserData {
  static final firestore = fb.firestore();
  final CollectionReference userRef = firestore.collection("users");
  final CollectionReference eventRef = firestore.collection("events");
  final CollectionReference notifRef = firestore.collection("user_notifications");

  Stream<WebblenUser> streamCurrentUser(String uid) {
    return userRef.doc(uid).onSnapshot.map((snapshot) => WebblenUser.fromMap(Map<String, dynamic>.from(snapshot.data())));
  }

  Future<bool> userAccountIsSetup(String uid) async {
    bool accountIsSetup = false;
    DocumentSnapshot snapshot = await userRef.doc(uid).get();
    if (snapshot.exists) {
      accountIsSetup = true;
    }
    return accountIsSetup;
  }

  Future<bool> checkIfUsernameExists(String username) async {
    bool usernameExists = false;
    QuerySnapshot snapshot = await userRef.where("username", "==", username).get();
    if (!snapshot.empty) {
      usernameExists = true;
    }
    return usernameExists;
  }

  Future<String> completeAccountSetup(File userImgFile, String uid, String username) async {
    String error = "";
    bool usernameExists = await checkIfUsernameExists(username.toLowerCase());
    print(usernameExists);
    if (!usernameExists) {
      String userImgURL = await ImageUploadService().uploadImageToFirebaseStorage(userImgFile, UserImgFile, uid);
      print(userImgURL);
      if (userImgURL != null) {
        WebblenUser newUser = WebblenUser(
          uid: uid,
          username: username.toLowerCase(),
          messageToken: "",
          profilePicURL: userImgURL,
          savedEvents: [],
          tags: [],
          friends: [],
          blockedUsers: [],
          webblen: 0.001,
          ap: 1.01,
          apLvl: 1,
          eventsToLvlUp: 20,
          lastCheckInTimeInMilliseconds: 1584468891299,
          lastNotifInMilliseconds: 1584468891299,
          lastPayoutTimeInMilliseconds: 1584468891299,
          canMakeAds: false,
          isAdmin: false,
        );
        await userRef.doc(uid).set(newUser.toMap()).whenComplete(() {}).catchError((e) {
          error = e.toString();
        });
      } else {
        error = "There was an Issue Setting Up Your Account. Please Try Again.";
      }
    } else {
      error = "Username Unavailable";
    }
    return error;
  }
}
