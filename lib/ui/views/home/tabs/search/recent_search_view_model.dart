import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class RecentSearchViewModel extends BaseViewModel {
  NavigationService? _navigationService = locator<NavigationService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();

  ///DATA RESULTS
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  researchTerm(String term) {}

  navigateToSearchView() {}
}
