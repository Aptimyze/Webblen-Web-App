import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';

class UserBlockViewModel extends BaseViewModel {
  NavigationService? _navigationService = locator<NavigationService>();

  ///NAVIGATION
  navigateToUserView(String? id) {
    _navigationService!.navigateTo(Routes.UserProfileView(id: id));
  }
}
