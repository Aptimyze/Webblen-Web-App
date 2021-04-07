import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ///AUTH STATE
  Future<bool> signInAnonymously() async {
    UserCredential userCredential = await firebaseAuth.signInAnonymously();
    return userCredential.user != null;
  }

  Future<bool> isAnonymous() async {
    User user = await firebaseAuth.currentUser;
    return user.isAnonymous;
  }

  Future<bool> isLoggedIn() async {
    User user = await firebaseAuth.currentUser;
    return user != null;
  }

  Future<String> getCurrentUserID() async {
    User user = await firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  Future<String> signOut() async {
    await firebaseAuth.signOut();
    User user = await firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  ///SIGN IN & REGISTRATION
  //Email
  Future signUpWithEmail({@required String email, @required String password}) async {
    try {
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      credential.user.sendEmailVerification();
      return credential.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signInWithEmail({@required String email, @required String password}) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        return true;
        // if (credential.user.emailVerified) {
        //   return true;
        // } else {
        //   return "Email Confirmation Required";
        // }
      }
    } catch (e) {
      return e.message;
    }
  }

  //Phone
  Future<String> signInWithPhoneNumber({
    @required String phoneNo,
  }) async {
    String error;
    final RecaptchaVerifier recaptchaVerifier = RecaptchaVerifier(
      onError: (exception) {
        error = exception.message;
        return error;
      },
      size: RecaptchaVerifierSize.compact,
      theme: RecaptchaVerifierTheme.dark,
    );
    await FirebaseAuth.instance.signInWithPhoneNumber(phoneNo, recaptchaVerifier);
    return error;
  }

  Future signInWithSMSCode({@required String verificationID, @required String smsCode}) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID,
      smsCode: smsCode,
    );

    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      if (user != null) {
        return true;
      } else {
        return 'There was an issue signing in.. Please Try Again';
      }
    }).catchError((e) {
      return e.message;
    });
  }

  //FACEBOOK AUTH
  Future loginWithFacebook() async {
    final FacebookAuth fbAuth = FacebookAuth.instance;
    final LoginResult result = await fbAuth.login(permissions: ['email']);
    switch (result.status) {
      case LoginStatus.success:
        final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
        FirebaseAuth.instance.signInWithCredential(credential).then((user) {
          if (user != null) {
            return user;
          } else {
            return 'There was an issue signing in with Facebook. Please Try Again';
          }
        });
        break;
      case LoginStatus.cancelled:
        return "Cancelled Facebook Sign In";
        break;
      case LoginStatus.failed:
        return "There was an Issue Signing Into Facebook";
        break;
    }
  }
}
