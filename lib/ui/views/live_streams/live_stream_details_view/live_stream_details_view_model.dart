import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/app/router.gr.dart';
import 'package:webblen_web_app/enums/bottom_sheet_type.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
import 'package:webblen_web_app/services/firestore/data/comment_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/add_to_calendar.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class LiveStreamDetailsViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  UserDataService _userDataService = locator<UserDataService>();
  LiveStreamDataService _streamDataService = locator<LiveStreamDataService>();
  TicketDistroDataService _ticketDistroDataService = locator<TicketDistroDataService>();
  LocationService _locationService = locator<LocationService>();
  CommentDataService _commentDataService = locator<CommentDataService>();
  NotificationDataService _notificationDataService = locator<NotificationDataService>();
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ShareService _shareService = locator<ShareService>();

  ///STREAM HOST
  WebblenUser host;
  bool isHost = false;

  ///STREAM
  WebblenLiveStream stream;
  bool hasSocialAccounts = false;
  bool streamIsLive = false;

  ///TICKETS
  WebblenTicketDistro ticketDistro;

  ///INITIALIZE
  initialize(BuildContext context) async {
    setBusy(true);

    var routeData = RouteData.of(context);
    // .value will return the raw string value
    String id = routeData.pathParams['id'].value;

    //get stream data
    var res = await _streamDataService.getStreamByID(id);
    if (res == null) {
      _navigationService.back();
      return;
    } else {
      stream = res;
    }

    //check if stream is live
    isStreamLive();

    //get tickets if they exist
    if (stream.hasTickets) {
      ticketDistro = await _ticketDistroDataService.getTicketDistroByID(stream.id);
    }

    //check if stream has social accounts
    if ((stream.fbUsername != null && stream.fbUsername.isNotEmpty) ||
        (stream.instaUsername != null && stream.instaUsername.isNotEmpty) ||
        (stream.twitterUsername != null && stream.twitterUsername.isNotEmpty) ||
        (stream.website != null && stream.website.isNotEmpty)) {
      hasSocialAccounts = true;
    }

    //get author info
    host = await _userDataService.getWebblenUserByID(stream.hostID);

    if (webblenBaseViewModel.uid == stream.hostID) {
      isHost = true;
    }

    notifyListeners();
    setBusy(false);
  }

  isStreamLive() {
    int currentDateInMilli = DateTime.now().millisecondsSinceEpoch;
    int eventStartDateInMilli = stream.startDateTimeInMilliseconds;
    int eventEndDateInMilli = stream.endDateTimeInMilliseconds;
    if (currentDateInMilli >= eventStartDateInMilli && currentDateInMilli <= eventEndDateInMilli) {
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
    _locationService.openMaps(address: stream.audienceLocation);
  }

  openFacebook() {
    if (stream.fbUsername != null) {
      String url = "https://facebook.com/${stream.fbUsername}";
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  openInstagram() {
    if (stream.instaUsername != null) {
      String url = "https://instagram.com/${stream.instaUsername}";
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  openTwitter() {
    if (stream.twitterUsername != null) {
      String url = "https://twitter.com/${stream.twitterUsername}";
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  openWebsite() {
    if (stream.website != null) {
      String url = stream.website;
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  ///STREAMING
  streamNow() async {
    String url = await _platformDataService.getWebblenDownloadLink();
    DialogResponse response = await _dialogService.showDialog(
      title: "Streaming Only Available in App",
      description: "Download Webblen in Order to Watch this Stream",
      cancelTitle: "Cancel",
      buttonTitle: "Download Webblen",
    );
    if (response.confirmed) {
      UrlHandler().launchInWebViewOrVC(url);
    }
  }

  ///DIALOGS & BOTTOM SHEETS
  showContentOptions() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: isHost ? BottomSheetType.contentAuthorOptions : BottomSheetType.contentOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "edit") {
        //edit
        // _navigationService.navigateTo(Routes.CreateLiveStreamViewRoute, arguments: {
        //   'id': stream.id,
        // });
      } else if (res == "share") {
        //share
        WebblenUser author = await _userDataService.getWebblenUserByID(stream.hostID);
        String url = await _dynamicLinkService.createLiveStreamLink(authorUsername: author.username, stream: stream);
        _shareService.copyContentLink(contentType: "stream", url: url);
      } else if (res == "report") {
        //report
        _streamDataService.reportStream(streamID: stream.id, reporterID: webblenBaseViewModel.uid);
      } else if (res == "delete") {
        //delete
        deleteContentConfirmation();
      }
    }
  }

  deleteContentConfirmation() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      title: "Delete Stream",
      description: "Are You Sure You Want to Delete this Stream?",
      mainButtonTitle: "Delete Stream",
      secondaryButtonTitle: "Cancel",
      barrierDismissible: true,
      variant: BottomSheetType.destructiveConfirmation,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "confirmed") {
        await _streamDataService.deleteStream(stream: stream);
        _navigationService.back();
      }
    }
  }

  ///NAVIGATION
  navigateToUserView(String id) {
    _navigationService.navigateTo(Routes.UserProfileView(id: id));
  }

// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
