import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class NotificationsViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  NotificationDataService _notificationDataService = locator<NotificationDataService>();
  ReactiveWebblenUserService _reactiveUserService = locator<ReactiveWebblenUserService>();

  ///USER DATA
  WebblenUser get user => _reactiveUserService.user;

  initialize() async {
    _notificationDataService.clearNotifications(user.id);
  }

  navigateBack() {
    _navigationService.back();
  }
}
