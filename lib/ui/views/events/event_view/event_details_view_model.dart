import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/comment_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class EventDetailsViewModel extends ReactiveViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService? _userDataService = locator<UserDataService>();
  EventDataService _eventDataService = locator<EventDataService>();
  TicketDistroDataService? _ticketDistroDataService = locator<TicketDistroDataService>();
  LocationService? _locationService = locator<LocationService>();
  CommentDataService? _commentDataService = locator<CommentDataService>();
  NotificationDataService? _notificationDataService = locator<NotificationDataService>();
  CustomDialogService customDialogService = locator<CustomDialogService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///USER DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  ///HOST
  WebblenUser? host;
  bool isHost = false;

  ///EVENT
  WebblenEvent? event;
  bool hasSocialAccounts = false;
  bool liveNow = false;

  ///TICKETS
  WebblenTicketDistro? ticketDistro;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

  ///INITIALIZE
  initialize(String eventID) async {
    setBusy(true);

    // .value will return the raw string value
    String id = eventID;

    //get stream data
    var res = await _eventDataService.getEventByID(id);
    if (!res.isValid()) {
      _navigationService.back();
      return;
    } else {
      event = res;
    }

    //check if stream is live
    isHappeningNow();

    //get tickets if they exist
    if (event!.hasTickets!) {
      ticketDistro = await _ticketDistroDataService!.getTicketDistroByID(event!.id);
    }

    //check if stream has social accounts
    if ((event!.fbUsername != null && event!.fbUsername!.isNotEmpty) ||
        (event!.instaUsername != null && event!.instaUsername!.isNotEmpty) ||
        (event!.twitterUsername != null && event!.twitterUsername!.isNotEmpty) ||
        (event!.website != null && event!.website!.isNotEmpty)) {
      hasSocialAccounts = true;
    }

    //get author info
    host = await _userDataService!.getWebblenUserByID(event!.authorID);

    if (user.id == event!.authorID) {
      isHost = true;
    }

    notifyListeners();
    setBusy(false);
  }

  isHappeningNow() {
    int currentDateInMilli = DateTime.now().millisecondsSinceEpoch;
    int eventStartDateInMilli = event!.startDateTimeInMilliseconds!;
    int? eventEndDateInMilli = event!.endDateTimeInMilliseconds;
    if (currentDateInMilli >= eventStartDateInMilli && currentDateInMilli <= eventEndDateInMilli!) {
      liveNow = true;
    } else {
      liveNow = false;
    }
    print(liveNow);
    notifyListeners();
  }

  addToCalendar() {
    //addStreamToCalendar(webblenStream: stream);
  }

  openMaps() {
    _locationService!.openMaps(address: event!.streetAddress!);
  }

  openFacebook() {
    if (event!.fbUsername != null) {
      String url = "https://facebook.com/${event!.fbUsername}";
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  openInstagram() {
    if (event!.instaUsername != null) {
      String url = "https://instagram.com/${event!.instaUsername}";
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  openTwitter() {
    if (event!.twitterUsername != null) {
      String url = "https://twitter.com/${event!.twitterUsername}";
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  openWebsite() {
    if (event!.website != null) {
      String url = event!.website!;
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  ///NAVIGATION
  navigateToUserView(String? id) {
    _navigationService.navigateTo(Routes.UserProfileView(id: id));
  }

  navigateToTicketView() {
    _navigationService.navigateTo(Routes.TicketSelectionViewRoute(id: event!.id));
  }

// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
