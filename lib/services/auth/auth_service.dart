import 'dart:async';
import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';

class AuthService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserDataService _userDataService = locator<UserDataService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();

  ///AUTH STATE
  Future<bool> signInAnonymously() async {
    UserCredential userCredential = await firebaseAuth.signInAnonymously();
    return userCredential.user != null;
  }

  Future<bool> isAnonymous() async {
    User user = await firebaseAuth.currentUser!;
    return user.isAnonymous;
  }

  Future<bool> isLoggedIn() async {
    User? user = await firebaseAuth.currentUser;
    return user != null;
  }

  Future<String?> getCurrentUserID() async {
    User? user = await firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  Future<String?> signOut() async {
    await firebaseAuth.signOut();
    User? user = await firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  ///SIGN IN & REGISTRATION
  //Email
  Future signUpWithEmail({required String email, required String password}) async {
    try {
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      credential.user!.sendEmailVerification();
      WebblenUser user = WebblenUser().generateNewUser(credential.user!.uid);
      user.emailAddress = email;
      _userDataService.createWebblenUser(user);
      return credential.user != null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> signInWithEmail({required String email, required String password}) async {
    bool signedIn = false;
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) {
      signedIn = true;
    }).catchError((error) {
      _customDialogService.showErrorDialog(description: error.message);
    });
    return signedIn;
  }

  Future sendSMSCode({required String phoneNo}) async {
    ConfirmationResult? result;
    final RecaptchaVerifier recaptchaVerifier = RecaptchaVerifier(
      onError: (exception) {
        _customDialogService.showErrorDialog(description: exception.message!);
      },
      onExpired: () {
        _customDialogService.showErrorDialog(description: "reCAPTCHA Expired");
      },
      size: RecaptchaVerifierSize.compact,
      theme: RecaptchaVerifierTheme.dark,
    );

    await FirebaseAuth.instance.signInWithPhoneNumber(phoneNo, recaptchaVerifier).then((val) async {
      result = val;
    }).catchError((e) {
      _customDialogService.showErrorDialog(description: e.message);
    });

    return result == null ? null : result;
  }

  Future<bool> signInWithPhone({required ConfirmationResult confirmationResult, required String phoneNo, required String smsCode}) async {
    bool signedIn = false;
    await confirmationResult.confirm(smsCode).then((credential) async {
      bool userExists = await _userDataService.checkIfUserExists(credential.user!.uid);
      if (!userExists) {
        WebblenUser user = WebblenUser().generateNewUser(credential.user!.uid);
        await _userDataService.createWebblenUser(user);
      }

      //hide captcha container
      var captcha = querySelector('#__ff-recaptcha-container');
      if (captcha != null) {
        captcha.hidden = true;
      }

      signedIn = true;
    }).catchError((e) {
      _customDialogService.showErrorDialog(description: e.message);
    });
    return signedIn;
  }

  //Apple
  Future<bool> signInWithApple() async {
    bool signedIn = false;
    await FirebaseAuthOAuth().openSignInFlow("apple.com", ["email"]).then((user) async {
      print('apple sign in with user: ${user!.uid}');
      print(user.email);
      bool userExists = await _userDataService.checkIfUserExists(user.uid);
      if (!userExists) {
        WebblenUser webblenUser = WebblenUser().generateNewUser(user.uid);
        await _userDataService.createWebblenUser(webblenUser);
      }
      signedIn = true;
    }).catchError((error) {
      _customDialogService.showErrorDialog(description: error.message);
      signedIn = false;
    });
    return signedIn;
  }

  //Google
  Future<bool> signInWithGoogle() async {
    bool signedIn = false;
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    await _googleSignIn.signIn().then((googleAccount) async {
      await googleAccount!.authentication.then((googleAuth) async {
        AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        await FirebaseAuth.instance.signInWithCredential(credential).then((val) async {
          bool userExists = await _userDataService.checkIfUserExists(val.user!.uid);
          if (!userExists) {
            WebblenUser user = WebblenUser().generateNewUser(val.user!.uid);
            user.googleIDToken = googleAuth.idToken;
            user.googleAccessToken = googleAuth.accessToken;
            await _userDataService.createWebblenUser(user);
          }
          signedIn = true;
        }).catchError((e) {
          _customDialogService.showErrorDialog(description: e.message);
        });
      });
    }).catchError((e) {
      _customDialogService.showErrorDialog(description: e.message);
    });
    return signedIn;
  }

  //Facebook
  Future<bool> signInWithFacebook() async {
    bool signedIn = false;
    final FacebookAuth fbAuth = FacebookAuth.instance;
    final LoginResult result = await fbAuth.login(permissions: ['email']);
    switch (result.status) {
      case LoginStatus.success:
        final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(credential).then((val) async {
          bool userExists = await _userDataService.checkIfUserExists(val.user!.uid);
          if (!userExists) {
            WebblenUser user = WebblenUser().generateNewUser(val.user!.uid);
            user.fbAccessToken = result.accessToken!.token;
            await _userDataService.createWebblenUser(user);
          }
          signedIn = true;
        }).catchError((e) {
          _customDialogService.showErrorDialog(description: e.message);
        });
        break;
      case LoginStatus.cancelled:
        _customDialogService.showErrorDialog(description: "Cancelled Facebook Sign In");
        break;
      case LoginStatus.failed:
        _customDialogService.showErrorDialog(description: "There was an Issue Signing Into Facebook");
        break;
      case LoginStatus.operationInProgress:
        // TODO: Handle this case.
        break;
    }
    return signedIn;
  }
}
