import 'dart:async';

import 'package:js/js.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/enums/bottom_sheet_type.dart';
import 'package:webblen_web_app/enums/init_error_status.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/location_js.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/services/reactive/content_filter/reactive_content_filter_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';

class WebblenBaseViewModel extends StreamViewModel<WebblenUser> with ReactiveServiceMixin {
  ///SERVICES
  ThemeService _themeService = locator<ThemeService>();
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  LocationService _locationService = locator<LocationService>();
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  ReactiveContentFilterService _reactiveContentFilterService = locator<ReactiveContentFilterService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();

  // LiveStreamDataService _liveStreamDataService = locator<LiveStreamDataService>();

  ///INITIAL DATA

  bool loadedUID = false;
  InitErrorStatus initErrorStatus = InitErrorStatus.none;
  late Map<String, dynamic> currentLocation;

  ///CURRENT USER
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;
  String? uid;
  bool isAnonymous = true;

  ///LOCATION DATA
  String get cityName => _reactiveContentFilterService.cityName;
  String get areaCode => _reactiveContentFilterService.areaCode;

  ///PROMOS
  double? postPromo;
  double? streamPromo;
  double? eventPromo;

  ///TAB BAR STATE
  int _navBarIndex = 0;

  int get navBarIndex => _navBarIndex;

  void setNavBarIndex(int index) {
    _navBarIndex = index;
    notifyListeners();
  }

  ///STREAM USER DATA
  @override
  void onData(WebblenUser? data) {
    if (data != null) {
      if (data.id == null) {
        if (_reactiveWebblenUserService.userLoggedIn) {
          _reactiveWebblenUserService.updateUserLoggedIn(false);
          _reactiveWebblenUserService.updateWebblenUser(data);
          notifyListeners();
          setBusy(false);
        }
      } else if (user != data) {
        _reactiveWebblenUserService.updateWebblenUser(data);
        _reactiveWebblenUserService.updateUserLoggedIn(true);
        notifyListeners();
        setBusy(false);
      }
    }
  }

  @override
  Stream<WebblenUser> get stream => streamUser();

  Stream<WebblenUser> streamUser() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      WebblenUser user = WebblenUser();

      //check if logged in
      isAnonymous = await _authService.isAnonymous();
      if (isAnonymous) {
        yield user;
      } else {
        uid = await _authService.getCurrentUserID();
        user = await _userDataService.getWebblenUserByID(uid);

        //get previous location of user
        if (cityName.isEmpty || areaCode.isEmpty) {
          String lastSeenAreaCode = (user.lastSeenZipcode?.isEmpty ?? true) ? "58104" : user.lastSeenZipcode!;
          String? lastSeenCity = await _locationService.getCityFromZip(lastSeenAreaCode);
          _reactiveContentFilterService.updateAreaCode(lastSeenAreaCode);
          _reactiveContentFilterService.updateCityName(lastSeenCity!);
          notifyListeners();
        }
        yield user;
      }
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

  ///INITIALIZE DATA
  initialize() async {
    setBusy(true);
    _themeService.setThemeMode(ThemeManagerMode.light);

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
        uid = (await _authService.getCurrentUserID())!;
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

  ///LOCATION
  FutureOr<bool> getLocationDetails() {
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
    return true;
  }

  acquireLocation(pos) async {
    try {
      print(pos.coords.latitude);
      print(pos.coords.longitude);
      currentLocation['lat'] = pos.coords.latitude;
      currentLocation['lon'] = pos.coords.longitude;
      print(currentLocation['lat']);
      //cityName = await _locationService.getCityNameFromLatLon(pos.coords.latitude, pos.coords.longitude);
      //reaCode = await _locationService.getZipFromLatLon(pos.coords.latitude, pos.coords.longitude);
      _userDataService.updateLastSeenZipcode(id: uid, zip: areaCode);
      notifyListeners();
    } catch (ex) {
      print("Location Error Exception thrown : " + ex.toString());
      //currentLocation = null;
    }
  }

  ///NAVIGATION
  navigateToAuthView({bool? signingOut}) {
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

  navigateToCreatePostPage({String? id, bool? addPromo}) {
    if (!isLoggedIn) {
      _customDialogService.showLoginRequiredDialog(description: "You must be logged in to create a post");
      return;
    }
    if (id == null) {
      //generate new id if necessary
      id = "";
    }
    _navigationService.navigateTo(Routes.CreatePostViewRoute(id: id, promo: addPromo! ? postPromo : 0));
  }

  navigateToCreateEventPage() {
    if (!isLoggedIn) {
      _customDialogService.showLoginRequiredDialog(description: "You must be logged in to create a event");
      return;
    }
    //_navigationService.navigateTo(Routes.CreateEventViewRoute);
  }

  navigateToCreateStreamPage({required String? id, required bool addPromo}) async {
    if (!isLoggedIn) {
      _customDialogService.showLoginRequiredDialog(description: "You must be logged in to create a stream");
      return;
    }

    if (id == null) {
      //generate new id if necessary
      id = getRandomString(20);
    }
    _navigationService.navigateTo(Routes.CreateLiveStreamViewRoute(id: id, promo: addPromo ? streamPromo : 0));
  }

  ///AUTH HANDLER
  logOut() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      title: "Log Out",
      description: "Are You Sure You Want to Log Out?",
      mainButtonTitle: "Log Out",
      secondaryButtonTitle: "Cancel",
      barrierDismissible: true,
      variant: BottomSheetType.destructiveConfirmation,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "confirmed") {
        await _authService.signOut();
        _reactiveWebblenUserService.updateUserLoggedIn(false);
        _reactiveWebblenUserService.updateWebblenUser(WebblenUser());
        notifyListeners();
        navigateToAuthView(signingOut: true);
      }
    }
  }
}
