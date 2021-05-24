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
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
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
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  ///INITIAL DATA
  InitErrorStatus initErrorStatus = InitErrorStatus.none;
  late Map<String, dynamic> currentLocation;

  ///CURRENT USER
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  ///LOCATION DATA
  String get cityName => _reactiveContentFilterService.cityName;
  String get areaCode => _reactiveContentFilterService.areaCode;
  bool? errorGettingLocation;

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
      if (!data.isValid()) {
        _reactiveWebblenUserService.updateUserLoggedIn(false);
        _reactiveWebblenUserService.updateWebblenUser(data);
        notifyListeners();
        setBusy(false);
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
      WebblenUser streamedUser = WebblenUser();
      if (!isLoggedIn) {
        yield streamedUser;
      } else {
        String? uid = await _authService.getCurrentUserID();
        streamedUser = await _userDataService.getWebblenUserByID(uid);

        if ((errorGettingLocation != null && errorGettingLocation!) && cityName.isEmpty || areaCode.isEmpty) {
          String lastSeenAreaCode = (user.lastSeenZipcode?.isEmpty ?? true) ? "58104" : user.lastSeenZipcode!;
          String? lastSeenCity = await _locationService.getCityFromZip(lastSeenAreaCode);
          _reactiveContentFilterService.updateAreaCode(lastSeenAreaCode);
          _reactiveContentFilterService.updateCityName(lastSeenCity!);
        }
        yield streamedUser;
      }
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

  ///INITIALIZE DATA
  initialize() async {
    setBusy(true);
    _themeService.setThemeMode(ThemeManagerMode.light);
    postPromo = await _platformDataService.getPostPromo();
    streamPromo = await _platformDataService.getStreamPromo();
    eventPromo = await _platformDataService.getEventPromo();
    await _dynamicLinkService.handleDynamicLinks();
    getLocationDetails();
  }

  ///LOCATION
  getLocationDetails() {
    getCurrentPosition(allowInterop((pos) => acquireLocation(pos)));
  }

  acquireLocation(pos) async {
    try {
      Map<String, dynamic> locDetails = await _locationService.getLocationDetailsFromLatLon(pos.coords.latitude, pos.coords.longitude);
      if (locDetails.isNotEmpty) {
        _reactiveContentFilterService.updateAreaCode(locDetails['zipcode']);
        _reactiveContentFilterService.updateCityName(locDetails['city']);
        errorGettingLocation = false;
      } else {
        errorGettingLocation = true;
      }
      notifyListeners();
    } catch (ex) {
      errorGettingLocation = true;
      notifyListeners();
      print("Location Error Exception thrown : " + ex.toString());
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
      id = "new";
    }
    _navigationService.navigateTo(Routes.CreatePostViewRoute(id: id, promo: addPromo! ? postPromo : 0));
  }

  navigateToCreateEventPage({required String? id, required bool addPromo}) {
    if (!isLoggedIn) {
      _customDialogService.showLoginRequiredDialog(description: "You must be logged in to create a event");
      return;
    }
    if (id == null) {
      id = "new";
    }
    _navigationService.navigateTo(Routes.CreateEventViewRoute(id: id, promo: addPromo ? eventPromo : 0));
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
