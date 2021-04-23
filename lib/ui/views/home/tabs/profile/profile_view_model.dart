import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class ProfileViewModel extends ReactiveViewModel {
  WebblenBaseViewModel _webblenBaseViewModel = locator<WebblenBaseViewModel>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  CustomBottomSheetService _customBottomSheetService = locator<CustomBottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

  //open user site
  openWebsite() {
    UrlHandler().launchInWebViewOrVC(_reactiveWebblenUserService.user.website!);
  }

  navigateToFollowers() {
    _navigationService.navigateTo(Routes.UserFollowersViewRoute(id: user.id));
  }

  navigateToFollowing() {
    _navigationService.navigateTo(Routes.UserFollowingViewRoute(id: user.id));
  }

  //show current user options
  showOptions() {
    _customBottomSheetService.showCurrentUserOptions(user);
  }

  //navigate to auth view
  navigateToAuthView() {
    _webblenBaseViewModel.navigateToAuthView();
  }
}
