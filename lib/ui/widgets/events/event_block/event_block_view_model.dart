import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class EventBlockViewModel extends BaseViewModel {
  SnackbarService _snackbarService = locator<SnackbarService>();
  NavigationService _navigationService = locator<NavigationService>();
  EventDataService _eventDataService = locator<EventDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  WebblenBaseViewModel _webblenBaseViewModel = locator<WebblenBaseViewModel>();

  bool eventIsHappeningNow = false;
  bool savedEvent = false;
  String authorImageURL = "";
  String authorUsername = "";

  initialize(WebblenEvent event) {
    setBusy(true);

    //check if user saved event
    if (event.savedBy.contains(_webblenBaseViewModel.uid)) {
      savedEvent = true;
    }

    //check if event is happening now
    isEventHappeningNow(event);

    _userDataService.getWebblenUserByID(event.authorID).then((res) {
      if (res is String) {
        //print(String);
      } else {
        authorImageURL = res.profilePicURL;
        authorUsername = res.username;
      }
      notifyListeners();
      setBusy(false);
    });
  }

  isEventHappeningNow(WebblenEvent event) {
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

  saveUnsaveEvent({String eventID}) async {
    if (savedEvent) {
      savedEvent = false;
    } else {
      savedEvent = true;
    }
    HapticFeedback.lightImpact();
    notifyListeners();
    await _eventDataService.saveUnsaveEvent(uid: _webblenBaseViewModel.uid, eventID: eventID, savedEvent: savedEvent);
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
  navigateToEventView({String eventID}) async {
    // String res = await _navigationService.navigateTo(Routes.EventViewRoute, arguments: {'id': eventID});
    // if (res == "event no longer exists") {
    //   _snackbarService.showSnackbar(
    //     title: 'Uh Oh...',
    //     message: "This event no longer exists",
    //     duration: Duration(seconds: 5),
    //   );
    // }
  }

  navigateToUserView(String id) {
    // _navigationService.navigateTo(Routes.UserProfileView, arguments: {'id': id});
  }
}
