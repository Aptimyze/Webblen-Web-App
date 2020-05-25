import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationService {
  Future<bool> userIsSignedIn() async {
    await Future.delayed(Duration(seconds: 2));
    FirebaseUser user;
    bool userIsSignedIn = false;
    user = await FirebaseAuth.instance.currentUser();
    if (user != null && !user.isAnonymous) {
      userIsSignedIn = true;
    } else if (user == null) {
      FirebaseAuth.instance.signInAnonymously();
    }
    return userIsSignedIn;
  }

  Future<String> signOut() async {
    String error;
    await Future.delayed(Duration(seconds: 2));
    await FirebaseAuth.instance.signOut().catchError((e) {
      error = e;
    });
    if (error == null) {
      FirebaseAuth.instance.signInAnonymously();
    }
    return error;
  }

  Future<String> getCurrentUserID() async {
    String uid;
    await Future.delayed(Duration(seconds: 1));
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null && !user.isAnonymous) {
      uid = user.uid;
    }
    return uid;
  }

  Future<String> createUserWithEmail(String email, String password) async {
    String error;
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).catchError((e) {
      error = e.message;
    });
    return error;
  }

  Future<String> signInWithEmail(String email, String password) async {
    String error;
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).catchError((e) {
      error = e.message;
    });
    return error;
  }

  Future<bool> signInWithPhone(String verID, String smsCode) async {
    bool userIsSignedIn = false;
    AuthCredential credential = await PhoneAuthProvider.getCredential(
      verificationId: verID,
      smsCode: smsCode,
    );

    AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential).catchError((e) {
      print(e.details);
    });

    if (authResult.user != null && !authResult.user.isAnonymous) {
      userIsSignedIn = true;
    }

    return userIsSignedIn;
  }

  signInWithPhoneNumber() {}

  signInWithFacebook() {}

  signInWithGoogle() {}
}
