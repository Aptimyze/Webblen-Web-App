import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class ProfileViewModel extends ReactiveViewModel {
  WebblenBaseViewModel _webblenBaseViewModel = locator<WebblenBaseViewModel>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  CustomBottomSheetService _customBottomSheetService = locator<CustomBottomSheetService>();

  ///DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  //open user site
  openWebsite() {
    UrlHandler().launchInWebViewOrVC(_reactiveWebblenUserService.user.website!);
  }

  //show current user options
  showOptions() {
    _customBottomSheetService.showCurrentUserOptions(user);
  }

  //navigate to auth view
  navigateToAuthView() {
    _webblenBaseViewModel.navigateToAuthView();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];
}
