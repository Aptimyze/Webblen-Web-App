import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';

class OnboardingPathSelectViewModel extends ReactiveViewModel {
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  ReactiveWebblenUserService _reactiveUserService = locator<ReactiveWebblenUserService>();
  LocationService _locationService = locator<LocationService>();
  UserDataService _userDataService = locator<UserDataService>();
  ThemeService _themeService = locator<ThemeService>();

  ///USER
  WebblenUser get user => _reactiveUserService.user;
  String emailAddress = "";
  bool isLoading = false;

  ///PERMISSIONS DATA
  bool notificationError = false;
  bool updatingLocation = false;
  bool locationError = false;
  bool hasLocation = false;
  String areaName = "The World";

  ///INTRO STATE
  final introKey = GlobalKey<IntroductionScreenState>();
  bool showSkipButton = true;
  bool showNextButton = true;
  bool freezeSwipe = false;
  int pageNum = 0;
  int imgFlex = 3;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveUserService];

  initialize() {
    setBusy(true);
    _themeService.setThemeMode(ThemeManagerMode.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    notifyListeners();
    setBusy(false);
  }

  updatePageNum(int val) {
    pageNum = val;
    notifyListeners();
  }

  updateImgFlex(int val) {
    imgFlex = val;
    notifyListeners();
  }

  updateShowNextButton(bool val) {
    showNextButton = val;
    notifyListeners();
  }

  updateEmail(String val) {
    emailAddress = val.trim();
    notifyListeners();
  }

  validateAndSubmitEmailAddress() {
    if (!isValidEmail(emailAddress)) {
      _customDialogService.showErrorDialog(description: "Invalid Email Address");
      return;
    } else {
      _userDataService.updateAssociatedEmailAddress(user.id!, emailAddress);
      introKey.currentState!.next();
    }
  }

  navigateToNextPage() {
    introKey.currentState!.next();
  }

  navigateToPreviousPage() {
    introKey.currentState!.animateScroll(pageNum - 1);
  }

  transitionToEventHostPath() {
    _navigationService.navigateTo(Routes.EventHostPathViewRoute);
  }

  transitionToStreamerPath() {
    _navigationService.navigateTo(Routes.StreamerPathViewRoute);
  }

  transitionToExplorerPath() {
    _navigationService.navigateTo(Routes.ExplorerPathViewRoute);
  }
}
