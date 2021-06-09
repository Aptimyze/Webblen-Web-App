import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_notification.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/navigation/custom_navigation_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class LiveStreamBlockViewModel extends BaseViewModel {
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

  bool isLive = false;
  bool savedStream = false;
  List savedBy = [];
  String? hostImageURL = "";
  String? hostUsername = "";

  initialize(WebblenLiveStream stream) async {
    setBusy(true);

    //check if user saved event
    if (stream.savedBy != null) {
      if (_reactiveWebblenUserService.userLoggedIn) {
        if (stream.savedBy!.contains(_reactiveWebblenUserService.user.id)) {
          savedStream = true;
        }
      }
      savedBy = stream.savedBy!;
    } else {
      savedBy = [];
    }

    //check if event is happening now
    isStreamLive(stream);

    WebblenUser author = await _userDataService.getWebblenUserByID(stream.hostID);
    if (author.isValid()) {
      hostImageURL = author.profilePicURL;
      hostUsername = author.username;
    }
    notifyListeners();
    setBusy(false);
  }

  isStreamLive(WebblenLiveStream stream) {
    int currentDateInMilli = DateTime.now().millisecondsSinceEpoch;
    int eventStartDateInMilli = stream.startDateTimeInMilliseconds!;
    int? eventEndDateInMilli = stream.endDateTimeInMilliseconds;
    if (currentDateInMilli >= eventStartDateInMilli && currentDateInMilli <= eventEndDateInMilli!) {
      isLive = true;
    } else {
      isLive = false;
    }
    notifyListeners();
  }

  saveUnsaveStream({required WebblenLiveStream stream}) async {
    if (!_reactiveWebblenUserService.user.isValid()) {
      _customDialogService.showLoginRequiredDialog(description: "You Must Be Logged in to Save Streams");
      return;
    }
    if (savedStream) {
      savedStream = false;
      savedBy.remove(user.id);
    } else {
      savedStream = true;
      savedBy.add(user.id);
      WebblenNotification notification = WebblenNotification().generateContentSavedNotification(
        receiverUID: stream.hostID!,
        senderUID: user.id!,
        username: user.username!,
        content: stream,
      );
      _notificationDataService.sendNotification(notif: notification);
    }
    HapticFeedback.lightImpact();
    notifyListeners();
    await _liveStreamDataService.saveUnsaveStream(uid: _reactiveWebblenUserService.user.id, streamID: stream.id!, savedStream: savedStream);
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
  navigateToStreamView(String? id) async {
    _navigationService.navigateTo(Routes.LiveStreamViewRoute(id: id));
  }

  navigateToUserView(String? id) {
    _navigationService.navigateTo(Routes.UserProfileView(id: id));
  }
}
