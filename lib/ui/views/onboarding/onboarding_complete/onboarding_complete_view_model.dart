import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/navigation/custom_navigation_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class OnboardingCompleteViewModel extends BaseViewModel {
  UserDataService _userDataService = locator<UserDataService>();
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  ReactiveWebblenUserService _reactiveUserService = locator<ReactiveWebblenUserService>();
  CustomNavigationService customNavigationService = locator<CustomNavigationService>();

  ///USER
  WebblenUser get user => _reactiveUserService.user;

  late double reward;

  initialize() async {
    setBusy(true);
    reward = await _platformDataService.getNewAccountReward();
    await _userDataService.depositWebblen(uid: user.id!, amount: reward);
    await _userDataService.completeOnboarding(uid: user.id!);
    setBusy(false);
  }
}
