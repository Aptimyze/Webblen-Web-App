import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:webblen_web_app/models/webblen_user.dart';

class UserDataService {
  CollectionReference userRef = fb.firestore().collection('webblen_users');

  Future checkIfUserExists(String id) async {
    bool exists = false;
    DocumentSnapshot snapshot = await userRef.doc(id).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      exists = true;
    }
    return exists;
  }

  Future createWebblenUser(WebblenUser user) async {
    await userRef.doc(user.id).set(user.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future getWebblenUserByID(String id) async {
    WebblenUser user;
    DocumentSnapshot snapshot = await userRef.doc(id).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      user = WebblenUser.fromMap(snapshot.data());
    }
    return user;
  }

  Future updateWebblenUser(WebblenUser user) async {
    await userRef.doc(user.id).update(data: user.toMap()).catchError((e) {
      return e.message;
    });
  }
}
