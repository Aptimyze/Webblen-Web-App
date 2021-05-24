import 'package:flutter/cupertino.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_connect_account_service.dart';

class EventHostPathViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  AlgoliaSearchService _algoliaSearchService = locator<AlgoliaSearchService>();
  ReactiveWebblenUserService _reactiveUserService = locator<ReactiveWebblenUserService>();
  UserDataService _userDataService = locator<UserDataService>();
  StripeConnectAccountService _stripeConnectAccountService = locator<StripeConnectAccountService>();

  ///USER
  WebblenUser get user => _reactiveUserService.user;

  ///TAG INFO
  Map<dynamic, dynamic> allTags = {};
  String selectedCategory = 'select category';
  List selectedTags = [];
  List<String> tagCategories = [];

  ///STRIPE
  late String stripeConnectURL;

  ///INTRO STATE
  final introKey = GlobalKey<IntroductionScreenState>();
  bool showSkipButton = true;
  bool showNextButton = true;
  int pageNum = 0;

  initialize() async {
    setBusy(true);
    _algoliaSearchService.getTagsAndCategories().then((res) {
      allTags = res;
      allTags.keys.forEach((key) {
        if (key != null) {
          tagCategories.add(key.toString());
        }
      });
      tagCategories.sort((a, b) => a.compareTo(b));
      tagCategories.insert(0, "select category");
      selectedCategory = tagCategories.first;
    });
    notifyListeners();
    setBusy(false);
  }

  createStripeAccount() {
    _stripeConnectAccountService.createStripeConnectAccount(uid: user.id!);
  }

  updatePageNum(int val) {
    pageNum = val;
    notifyListeners();
  }

  updateShowNextButton(bool val) {
    showNextButton = val;
    notifyListeners();
  }

  updateSelectedCategory(String val) {
    selectedCategory = val;
    notifyListeners();
  }

  updateSelectedTags(String val) {
    if (selectedTags.contains(val)) {
      selectedTags.remove(val);
    } else {
      selectedTags.add(val);
    }
    notifyListeners();
  }

  navigateToNextPage() {
    introKey.currentState!.next();
  }

  navigateToMonetizePage() {
    introKey.currentState!.animateScroll(1);
  }

  navigateToPreviousPage() {
    introKey.currentState!.animateScroll(pageNum - 1);
  }

  skipToSelectInterest() {
    introKey.currentState!.animateScroll(3);
  }

  completeOnboarding() {
    WebblenUser updatedUserVal = user;
    updatedUserVal.tags = selectedTags;
    _reactiveUserService.updateWebblenUser(updatedUserVal);
    _userDataService.updateInterests(user.id!, selectedTags);
    _userDataService.completeOnboarding(uid: user.id!);
    _navigationService.pushNamedAndRemoveUntil(Routes.WebblenBaseViewRoute);
  }

  navigateToSelectPath() {
    _navigationService.back();
  }
}
