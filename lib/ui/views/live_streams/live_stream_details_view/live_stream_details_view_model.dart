import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/comment_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/add_to_calendar.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class LiveStreamDetailsViewModel extends ReactiveViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService? _userDataService = locator<UserDataService>();
  LiveStreamDataService? _streamDataService = locator<LiveStreamDataService>();
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

  ///STREAM HOST
  WebblenUser? host;
  bool isHost = false;

  ///STREAM
  WebblenLiveStream? stream;
  bool hasSocialAccounts = false;
  bool streamIsLive = false;

  ///TICKETS
  WebblenTicketDistro? ticketDistro;

  ///INITIALIZE
  initialize(String? streamID) async {
    setBusy(true);

    // .value will return the raw string value
    String? id = streamID;

    //get stream data
    var res = await _streamDataService!.getStreamByID(id);
    if (res == null) {
      _navigationService!.back();
      return;
    } else {
      stream = res;
    }

    //check if stream is live
    isStreamLive();

    //get tickets if they exist
    if (stream!.hasTickets!) {
      ticketDistro = await _ticketDistroDataService!.getTicketDistroByID(stream!.id);
    }

    //check if stream has social accounts
    if ((stream!.fbUsername != null && stream!.fbUsername!.isNotEmpty) ||
        (stream!.instaUsername != null && stream!.instaUsername!.isNotEmpty) ||
        (stream!.twitterUsername != null && stream!.twitterUsername!.isNotEmpty) ||
        (stream!.website != null && stream!.website!.isNotEmpty)) {
      hasSocialAccounts = true;
    }

    //get author info
    host = await _userDataService!.getWebblenUserByID(stream!.hostID);

    if (user.id == stream!.hostID) {
      isHost = true;
    }

    notifyListeners();
    setBusy(false);
  }

  isStreamLive() {
    int currentDateInMilli = DateTime.now().millisecondsSinceEpoch;
    int eventStartDateInMilli = stream!.startDateTimeInMilliseconds!;
    int? eventEndDateInMilli = stream!.endDateTimeInMilliseconds;
    if (currentDateInMilli >= eventStartDateInMilli && currentDateInMilli <= eventEndDateInMilli!) {
      streamIsLive = true;
    } else {
      streamIsLive = false;
    }
    notifyListeners();
  }

  addToCalendar() {
    addStreamToCalendar(webblenStream: stream);
  }

  openMaps() {
    _locationService!.openMaps(address: stream!.audienceLocation!);
  }

  openFacebook() {
    if (stream!.fbUsername != null) {
      String url = "https://facebook.com/${stream!.fbUsername}";
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  openInstagram() {
    if (stream!.instaUsername != null) {
      String url = "https://instagram.com/${stream!.instaUsername}";
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  openTwitter() {
    if (stream!.twitterUsername != null) {
      String url = "https://twitter.com/${stream!.twitterUsername}";
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  openWebsite() {
    if (stream!.website != null) {
      String url = stream!.website!;
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  ///NAVIGATION
  navigateToUserView(String? id) {
    _navigationService.navigateTo(Routes.UserProfileView(id: id));
  }

  @override
  // TODO: implement reactiveServices
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
