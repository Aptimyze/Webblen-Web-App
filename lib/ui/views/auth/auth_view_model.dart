import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class AuthViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  ThemeService? _themeService = locator<ThemeService>();
  SnackbarService? _snackbarService = locator<SnackbarService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  UserDataService _userDataService = locator<UserDataService>();

  ///HELPERS
  //final phoneMaskController = MaskedTextController(mask: '000-000-0000');
  final smsController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool signInViaPhone = true;
  String? phoneNo;
  ConfirmationResult? confirmationResult;

  ///Sign Up Via Email
  Future signInWithEmail({required email, required password}) async {
    setBusy(true);

    bool signedIn = await _authService.signInWithEmail(email: email, password: password);

    if (signedIn) {
      String? uid = await _authService.getCurrentUserID();
      if (uid != null) {
        await signUserIn(uid);
      }
    } else {
      setBusy(false);
    }
  }

  Future<bool> sendSMSCode({required phoneNo}) async {
    bool receivedConfirmationResult = false;
    confirmationResult = await _authService.sendSMSCode(phoneNo: phoneNo);
    if (confirmationResult != null) {
      receivedConfirmationResult = true;
      notifyListeners();
    }
    return receivedConfirmationResult;
  }

  signInWithSMSCode({required BuildContext context, required String smsCode}) async {
    Navigator.of(context).pop();

    setBusy(true);

    bool signedIn = await _authService.signInWithPhone(confirmationResult: confirmationResult!, phoneNo: phoneNo!, smsCode: smsCode);

    if (signedIn) {
      String? uid = await _authService.getCurrentUserID();
      if (uid != null) {
        await signUserIn(uid);
      }
    } else {
      setBusy(false);
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

  signInWithApple() async {
    setBusy(true);

    bool signedIn = await _authService.signInWithApple();

    if (signedIn) {
      String? uid = await _authService.getCurrentUserID();
      if (uid != null) {
        await signUserIn(uid);
      }
    } else {
      setBusy(false);
    }
  }

  signInWithGoogle() async {
    setBusy(true);

    bool signedIn = await _authService.signInWithGoogle();

    if (signedIn) {
      String? uid = await _authService.getCurrentUserID();
      if (uid != null) {
        await signUserIn(uid);
      }
    } else {
      setBusy(false);
    }
  }

  signInWithFacebook() async {
    setBusy(true);

    bool signedIn = await _authService.signInWithFacebook();

    if (signedIn) {
      String? uid = await _authService.getCurrentUserID();
      if (uid != null) {
        await signUserIn(uid);
      }
    } else {
      setBusy(false);
    }
  }

  signUserIn(String uid) async {
    WebblenUser user = WebblenUser();
    bool userExists = await _userDataService.checkIfUserExists(uid);
    if (!userExists) {
      user = WebblenUser().generateNewUser(uid);
      await _userDataService.createWebblenUser(user);
    } else {
      user = await _userDataService.getWebblenUserByID(uid);
    }
    _reactiveWebblenUserService.updateUserLoggedIn(true);
    _reactiveWebblenUserService.updateWebblenUser(user);
    notifyListeners();
    navigateToHomePage();
  }

  ///NAVIGATION
  navigateToHomePage() {
    _navigationService!.pushNamedAndRemoveUntil(Routes.WebblenBaseViewRoute);
  }
}
