import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/app/router.gr.dart';

class UserBlockViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();

  ///NAVIGATION
  navigateToUserView(String id) {
    _navigationService.navigateTo(Routes.UserProfileView(id: id));
  }
}
