import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';

class EventBlockViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  WebblenEvent event;
  bool eventIsHappeningNow;

  initialize(WebblenEvent data) {
    event = data;
    notifyListeners();
    determineIfEventIsHappeningNow();
  }

  determineIfEventIsHappeningNow() {
    int currentDateInMilli = DateTime.now().millisecondsSinceEpoch;
    int eventStartDateInMilli = event.startDateTimeInMilliseconds;
    int eventEndDateInMilli = event.endDateTimeInMilliseconds;
    if (currentDateInMilli >= eventStartDateInMilli && currentDateInMilli <= eventEndDateInMilli) {
      eventIsHappeningNow = true;
    } else {
      eventIsHappeningNow = false;
    }
    notifyListeners();
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
  navigateToEventDetails() {
    //_navigationService.navigateTo(PageRouteName);
    //_navigationService.navigateTo(Routes.SettingsViewRoute, arguments: {'data': 'example'});
  }
}
