import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/app/router.gr.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';

class AuthViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  ThemeService _themeService = locator<ThemeService>();
  SnackbarService _snackbarService = locator<SnackbarService>();

  ///HELPERS
  final phoneMaskController = MaskedTextController(mask: '000-000-0000');
  final smsController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool signInViaPhone = true;
  String phoneNo;
  String phoneVerificationID;

  ///Sign Up Via Email
  Future signInWithEmail({@required email, @required password}) async {
    setBusy(true);

    var result = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        navigateToHomePage();
      } else {
        _dialogService.showDialog(
          title: 'Login Error',
          description: "There Was an Issue Logging In. Please Try Again",
          barrierDismissible: true,
          buttonTitle: "Ok",
        );
      }
    } else {
      _dialogService.showDialog(
        title: 'Login Error',
        description: result,
        barrierDismissible: true,
        buttonTitle: "Ok",
      );
    }
  }

  Future<bool> sendSMSCode({@required phoneNo}) async {
    //Phone Timeout & Verifcation

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      phoneVerificationID = verId;
      notifyListeners();
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      phoneVerificationID = verId;
      notifyListeners();
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException exception) {
      return _dialogService.showDialog(
        title: 'Phone Login Error',
        description: exception.message,
        barrierDismissible: true,
        buttonTitle: "Ok",
      );
    };

    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
      // ANDROID ONLY!
      // Sign the user in (or link) with the auto-generated credential
      // if (Platform.isAndroid) {
      //   await FirebaseAuth.instance.signInWithCredential(credential);
      // }
    };

    if (phoneNo != null && phoneNo.isNotEmpty && phoneNo.length >= 10) {
      //SEND SMS CODE FOR VERIFICATION
      String error = await _authService.signInWithPhoneNumber(
        phoneNo: phoneNo,
        // autoRetrievalTimeout: autoRetrieve,
        // smsCodeSent: smsCodeSent,
        // verificationCompleted: verificationCompleted,
        // verificationFailed: verificationFailed,
      );

      if (error != null) {
        _dialogService.showDialog(
          title: 'Phone Login Error',
          description: error,
          barrierDismissible: true,
          buttonTitle: "Ok",
        );
        return false;
      } else {
        return true;
      }
    } else {
      setBusy(false);
      _dialogService.showDialog(
        title: 'Phone Login Error',
        description: "Invalid Phone Number",
        barrierDismissible: true,
        buttonTitle: "Ok",
      );
      return false;
    }
  }

  signInWithSMSCode({@required BuildContext context, @required String smsCode}) async {
    Navigator.of(context).pop();

    setBusy(true);

    var res = await _authService.signInWithSMSCode(verificationID: phoneVerificationID, smsCode: smsCode);

    if (res is String) {
      setBusy(false);
      _dialogService.showDialog(
        title: 'Phone Login Error',
        description: res,
        barrierDismissible: true,
        buttonTitle: "Ok",
      );
    } else {
      navigateToHomePage();
    }
  }

  setPhoneNo(String val) {
    phoneNo = val.replaceAll("-", "");
    notifyListeners();
  }

  togglePhoneEmailAuth() {
    if (signInViaPhone) {
      signInViaPhone = false;
    } else {
      signInViaPhone = true;
    }
    notifyListeners();
  }

  loginWithFacebook() async {
    setBusy(true);

    var res = await _authService.loginWithFacebook();

    setBusy(false);

    if (res is String) {
      _dialogService.showDialog(
        title: 'Facebook Sign In Error',
        description: res,
        barrierDismissible: true,
        buttonTitle: "Ok",
      );
    } else {
      navigateToHomePage();
    }
  }

  ///NAVIGATION
  navigateToHomePage() {
    _navigationService.pushNamedAndRemoveUntil(Routes.WebblenBaseViewRoute);
  }
}
