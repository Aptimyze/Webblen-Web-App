import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class WebblenUserData {
  static final firestore = fb.firestore();
  final CollectionReference userRef = firestore.collection("webblen_user");
  final CollectionReference eventRef = firestore.collection("events");
  final CollectionReference notifRef = firestore.collection("user_notifications");

//  Stream<WebblenUser> streamCurrentUser(String uid) {
//    return userRef.document(uid).snapshots().map((snapshot) => WebblenUser.fromMap(Map<String, dynamic>.from(snapshot.data['d'])));
//  }
//
//  Future<String> setUserCloudMessageToken(String uid, String messageToken) async {
//    String status = "";
//    userRef.document(uid).updateData({"d.messageToken": messageToken}).whenComplete(() {}).catchError((e) {
//      status = e.details;
//    });
//    return status;
//  }
}
