//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:webblen_web_app/models/base_user.dart';
//import 'package:webblen_web_app/models/webblen_user.dart';
//
//class AuthService {
//
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final CollectionReference userRef = Firestore().collection("webblen_user");
//
//  // create user obj based on firebase user
//  Future<WebblenUser> userFromFirestore(FirebaseUser user) async {
//    WebblenUser currentUser;
//    if (user != null){
//      DocumentSnapshot userDoc = await userRef.document(user.uid).get();
//      currentUser = WebblenUser.fromMap(userDoc.data["d"]);
//    }
//    return currentUser;
//  }
//
//  Stream<WebblenUser> getWebblenUser(FirebaseUser user) {
//    return userRef.document(user.uid).snapshots().map((event) => WebblenUser.fromMap(event.data['d']));
//  }
//
//  // auth change user stream
////  Stream<BaseUser> get user {
////    return _auth.onAuthStateChanged
////        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
////        .map(u);
////  }
//
//  // sign in anon
//  Future signInAnon() async {
//    try {
//      AuthResult result = await _auth.signInAnonymously();
//      FirebaseUser user = result.user;
//      return _userFromFirebaseUser(user);
//    } catch (e) {
//      print(e.toString());
//      return null;
//    }
//  }
//
//// sign in with email and password
//
//// register with email and password
//
//// sign out
//
//}
