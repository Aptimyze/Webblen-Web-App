import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/navigation/custom_navigation_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class VerticalScheduleStreamButtonModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  LiveStreamDataService _liveStreamDataService = locator<LiveStreamDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  CustomNavigationService customNavigationService = locator<CustomNavigationService>();
  NotificationDataService _notificationDataService = locator<NotificationDataService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();

  ///USER DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  onTap() {
    if (!isLoggedIn) {
      _customDialogService.showLoginRequiredDialog(description: "Login required to schedule a stream");
    } else {
      customNavigationService.navigateToCreateLiveStreamView("new");
    }
  }
}
