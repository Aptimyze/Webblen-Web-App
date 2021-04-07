import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:js/js.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/enums/bottom_sheet_type.dart';
import 'package:webblen_web_app/enums/init_error_status.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/location_js.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';
import 'package:webblen_web_app/utils/network_status.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class WebblenBaseViewModel extends StreamViewModel<WebblenUser> {
  ///SERVICES
  ThemeService _themeService = locator<ThemeService>();
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  LocationService _locationService = locator<LocationService>();
  PostDataService _postDataService = locator<PostDataService>();
  EventDataService _eventDataService = locator<EventDataService>();
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  ShareService _shareService = locator<ShareService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  // LiveStreamDataService _liveStreamDataService = locator<LiveStreamDataService>();

  ///INITIAL DATA
  bool loadedUID = false;
  InitErrorStatus initErrorStatus = InitErrorStatus.none;
  String cityName;
  String areaCode;
  String contentSortBy = "Latest";
  String contentTagFilter = "";
  Map<String, dynamic> currentLocation;

  ///CURRENT USER
  String uid;
  bool isAnonymous;
  WebblenUser user;

  ///PROMOS
  double postPromo;
  double streamPromo;
  double eventPromo;

  ///FILE UPLOAD DATA
  double uploadProgress;
  File imgToUpload;
  Uint8List imgToUploadByteMemory;

  ///TAB BAR STATE
  int _navBarIndex = 0;

  int get navBarIndex => _navBarIndex;

  void setNavBarIndex(int index) {
    _navBarIndex = index;
    notifyListeners();
  }

  ///STREAM USER DATA
  @override
  void onData(WebblenUser data) {
    if (data != null) {
      if (user != data) {
        user = data;
        notifyListeners();
        setBusy(false);
      }
    }
  }

  @override
  Stream<WebblenUser> get stream => streamUser();

  Stream<WebblenUser> streamUser() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      WebblenUser user;

      if (isAnonymous != null && !isAnonymous) {
        if (loadedUID) {
          user = await _userDataService.getWebblenUserByID(uid);
          //get previous location of user
          if (cityName == null || areaCode == null) {
            areaCode = user.lastSeenZipcode == null || user.lastSeenZipcode.isEmpty ? "58104" : user.lastSeenZipcode;
            cityName = await _locationService.getCityFromZip(areaCode);
            notifyListeners();
          }
        }
      }
      yield user;
    }
  }

  ///INITIALIZE DATA
  initialize() async {
    setBusy(true);
    _themeService.setThemeMode(ThemeManagerMode.light);

    //auth state listener
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        _authService.signInAnonymously();
      } else {
        if (firebaseUser.uid != uid && !firebaseUser.isAnonymous) {
          loadedUID = true;
          uid = firebaseUser.uid;
          isAnonymous = false;
          notifyListeners();
        } else {
          user = null;
          isAnonymous = true;
          notifyListeners();
          setBusy(false);
        }
      }
    });

    //getLocationDetails();
    //load content promos (if any exists)
    postPromo = await _platformDataService.getPostPromo();
    streamPromo = await _platformDataService.getStreamPromo();
    eventPromo = await _platformDataService.getEventPromo();
  }

  ///CHECKS IF USER IS LOGGED IN
  Future checkAuthState() async {
    bool isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      ///CHECK IF USER IS ANONYMOUS
      isAnonymous = await _authService.isAnonymous();
      if (!isAnonymous) {
        ///CHECK IF USER HAS CREATED PROFILE
        uid = await _authService.getCurrentUserID();
        loadedUID = true;
        notifyListeners();
        bool userExists = await _userDataService.checkIfUserExists(uid);
        if (!userExists) {
          //_navigationService.replaceWith(Routes.OnboardingViewRoute);
        }
      } else {
        //_navigationService.replaceWith(Routes.AuthViewRoute);
        notifyListeners();
        setBusy(false);
      }
    } else {
      isAnonymous = await _authService.signInAnonymously();
      notifyListeners();
      setBusy(false);
    }
  }

  ///NETWORK STATUS
  Future<bool> isConnectedToNetwork() async {
    bool isConnected = await NetworkStatus().isConnected();
    return isConnected;
  }

  ///LOCATION
  Future<bool> getLocationDetails() {
    getCurrentPosition(allowInterop((pos) {
      print(pos.coords.latitude);
      print(pos.coords.longitude);
      currentLocation['lat'] = pos.coords.latitude;
      currentLocation['lon'] = pos.coords.longitude;
      print(currentLocation['lat']);
      // cityName = await _locationService.getCityNameFromLatLon(pos.coords.latitude, pos.coords.longitude);
      // areaCode = await _locationService.getZipFromLatLon(pos.coords.latitude, pos.coords.longitude);
      //_userDataService.updateLastSeenZipcode(id: uid, zip: areaCode);
      notifyListeners();
      return;
    }));
  }

  acquireLocation(pos) async {
    try {
      print(pos.coords.latitude);
      print(pos.coords.longitude);
      currentLocation['lat'] = pos.coords.latitude;
      currentLocation['lon'] = pos.coords.longitude;
      print(currentLocation['lat']);
      cityName = await _locationService.getCityNameFromLatLon(pos.coords.latitude, pos.coords.longitude);
      areaCode = await _locationService.getZipFromLatLon(pos.coords.latitude, pos.coords.longitude);
      _userDataService.updateLastSeenZipcode(id: uid, zip: areaCode);
      notifyListeners();
    } catch (ex) {
      print("Location Error Exception thrown : " + ex.toString());
      //currentLocation = null;
    }
  }

  ///BOTTOM SHEETS
  //filters
  openFilter() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.homeFilter,
      takesInput: true,
      customData: {
        'currentCityName': cityName,
        'currentAreaCode': areaCode,
        'currentSortBy': contentSortBy,
        'currentTagFilter': contentTagFilter,
      },
    );
    if (sheetResponse != null && sheetResponse.responseData != null) {
      cityName = sheetResponse.responseData['cityName'];
      areaCode = sheetResponse.responseData['areaCode'];
      contentSortBy = sheetResponse.responseData['sortBy'];
      contentTagFilter = sheetResponse.responseData['tagFilter'];
      notifyListeners();
    }
  }

  //bottom sheet for new post, event, or stream
  showAddContentOptions() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.addContent,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "new post") {
        navigateToCreatePostPage(id: null, addPromo: false);
      } else if (res == "new stream") {
        navigateToCreateStreamPage(id: null, addPromo: false);
      } else if (res == "new event") {
        navigateToCreateEventPage();
      }
      notifyListeners();
    }
  }

  //bottom sheet for options one can take with post, event, or stream
  Future showContentOptions({@required dynamic content}) async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: content is WebblenLiveStream
          ? user.id == content.hostID
              ? BottomSheetType.contentAuthorOptions
              : BottomSheetType.contentOptions
          : user.id == content.authorID
              ? BottomSheetType.contentAuthorOptions
              : BottomSheetType.contentOptions,
    );

    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "edit") {
        if (content is WebblenPost) {
          //edit post
          _navigationService.navigateTo(Routes.CreatePostViewRoute(id: content.id, promo: 0));
        } else if (content is WebblenEvent) {
          //edit event
          // _navigationService.navigateTo(Routes.CreateEventViewRoute, arguments: {
          //   'id': content.id,
          // });
        } else if (content is WebblenLiveStream) {
          //edit stream
          _navigationService.navigateTo(Routes.CreateLiveStreamViewRoute(id: content.id, promo: 0));
        }
      } else if (res == "share") {
        if (content is WebblenPost) {
          //share post link
          WebblenUser author = await _userDataService.getWebblenUserByID(content.authorID);
          String url = await _dynamicLinkService.createPostLink(authorUsername: author.username, post: content);
          _shareService.copyContentLink(contentType: "post", url: url);
        } else if (content is WebblenEvent) {
          //share event link
          WebblenUser author = await _userDataService.getWebblenUserByID(content.authorID);
          String url = await _dynamicLinkService.createEventLink(authorUsername: author.username, event: content);
          _shareService.copyContentLink(contentType: "event", url: url);
        } else if (content is WebblenLiveStream) {
          //share stream link
          WebblenUser author = await _userDataService.getWebblenUserByID(content.hostID);
          String url = await _dynamicLinkService.createLiveStreamLink(authorUsername: author.username, stream: content);
          _shareService.copyContentLink(contentType: "stream", url: url);
        }
      } else if (res == "report") {
        if (user == null) {
          displayLoginRequiredDialog(title: "Login Required", desc: "You must be logged in to report content");
        } else {
          if (content is WebblenPost) {
            //report post
            _postDataService.reportPost(postID: content.id, reporterID: user.id);
          } else if (content is WebblenEvent) {
            //report event
            _eventDataService.reportEvent(eventID: content.id, reporterID: user.id);
          } else if (content is WebblenLiveStream) {
            //report stream

            //_liveStreamDataService.reportStream(streamID: content.id, reporterID: user.id);

          }
        }
      } else if (res == "delete") {
        //delete content
        bool deletedContent = await deleteContentConfirmation(content: content);
        if (deletedContent) {
          return "deleted content";
        }
      }
    }
  }

  //bottom sheet for confirming the removal of a post, event, or stream
  Future<bool> deleteContentConfirmation({dynamic content}) async {
    if (content is WebblenPost) {
      var sheetResponse = await _bottomSheetService.showCustomSheet(
        title: "Delete Post",
        description: "Are You Sure You Want to Delete this Post?",
        mainButtonTitle: "Delete Post",
        secondaryButtonTitle: "Cancel",
        barrierDismissible: true,
        variant: BottomSheetType.destructiveConfirmation,
      );
      if (sheetResponse != null) {
        String res = sheetResponse.responseData;
        if (res == "confirmed") {
          _postDataService.deletePost(post: content);
          _dialogService.showDialog(
            title: "Post Deleted",
            description: "Your post has been deleted",
            buttonTitle: "Ok",
          );
          return true;
        }
      }
    } else if (content is WebblenEvent) {
      var sheetResponse = await _bottomSheetService.showCustomSheet(
        title: "Delete Event",
        description: "Are You Sure You Want to Delete this Event?",
        mainButtonTitle: "Delete Event",
        secondaryButtonTitle: "Cancel",
        barrierDismissible: true,
        variant: BottomSheetType.destructiveConfirmation,
      );
      if (sheetResponse != null) {
        String res = sheetResponse.responseData;
        if (res == "confirmed") {
          _eventDataService.deleteEvent(event: content);
          _dialogService.showDialog(
            title: "Event Deleted",
            description: "Your event has been deleted",
            buttonTitle: "Ok",
          );
          return true;
        }
      }
    } else if (content is WebblenLiveStream) {
      var sheetResponse = await _bottomSheetService.showCustomSheet(
        title: "Delete Stream",
        description: "Are You Sure You Want to Delete this Stream?",
        mainButtonTitle: "Delete Post",
        secondaryButtonTitle: "Cancel",
        barrierDismissible: true,
        variant: BottomSheetType.destructiveConfirmation,
      );
      if (sheetResponse != null) {
        String res = sheetResponse.responseData;
        if (res == "confirmed") {
          // _liveStreamDataService.deleteStream(stream: content);
          // _snackbarService.showSnackbar(
          //   title: 'Stream Deleted',
          //   message: "Your stream has been deleted",
          //   duration: Duration(seconds: 5),
          // );
          return true;
        }
      }
    }
    return true;
  }

  displayMobileOnlyDialog() async {
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

  displayLoginRequiredDialog({@required String title, @required desc}) async {
    DialogResponse response = await _dialogService.showDialog(
      title: title,
      description: desc,
      cancelTitle: "Cancel",
      buttonTitle: "Log In",
    );
    if (response.confirmed) {
      navigateToAuthView();
    }
  }

  ///NAVIGATION
  navigateToAuthView({bool signingOut}) {
    if (signingOut == null || signingOut) {
      _navigationService.pushNamedAndRemoveUntil(Routes.AuthViewRoute);
    } else {
      _navigationService.navigateTo(Routes.AuthViewRoute);
    }
  }

  navigateToHomeWithIndex(int index) {
    setNavBarIndex(index);
    _navigationService.navigateTo(Routes.WebblenBaseViewRoute);
  }

  navigateToCreatePostPage({@required String id, @required bool addPromo}) {
    if (user == null) {
      displayLoginRequiredDialog(title: "Log In Required", desc: "You must be logged in to create a post");
      return;
    }
    if (id == null) {
      //generate new id if necessary
      id = getRandomString(20);
    }
    _navigationService.navigateTo(Routes.CreatePostViewRoute(id: id, promo: addPromo ? postPromo : 0));
  }

  navigateToCreateEventPage() {
    if (user == null) {
      displayLoginRequiredDialog(title: "Log In Required", desc: "You must be logged in to create an event");
      return;
    }
    //_navigationService.navigateTo(Routes.CreateEventViewRoute);
  }

  navigateToCreateStreamPage({@required String id, @required bool addPromo}) async {
    if (user == null) {
      displayLoginRequiredDialog(title: "Log In Required", desc: "You must be logged in to create a stream");
      return;
    }

    if (id == null) {
      //generate new id if necessary
      id = getRandomString(20);
    }
    _navigationService.navigateTo(Routes.CreateLiveStreamViewRoute(id: id, promo: addPromo ? streamPromo : 0));
  }

  ///FILE UPLOADER
  setUploadProgress(double progress) {
    uploadProgress = progress;
    notifyListeners();
  }

  setImgToUploadFile(File file) {
    imgToUpload = file;
    notifyListeners();
  }

  setImgToUploadByteMemory(Uint8List byteMemory) {
    imgToUploadByteMemory = byteMemory;
    notifyListeners();
  }

  clearUploaderData() {
    uploadProgress = null;
    //imgToUpload = null;
    imgToUploadByteMemory = null;
    notifyListeners();
  }
}
