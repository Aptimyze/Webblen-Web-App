import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/google_places_service.dart';
import 'package:webblen_web_app/services/reactive/content_filter/reactive_content_filter_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class HomeFilterBottomSheetModel extends BaseViewModel {
  ///SERVICES
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  ReactiveContentFilterService _reactiveContentFilterService = locator<ReactiveContentFilterService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  UserDataService _userDataService = locator<UserDataService>();
  GooglePlacesService googlePlacesService = locator<GooglePlacesService>();
  AlgoliaSearchService algoliaSearchService = locator<AlgoliaSearchService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();

  bool updatingData = false;

  ///DATA
  String get cityName => _reactiveContentFilterService.cityName;
  String get areaCode => _reactiveContentFilterService.areaCode;
  String get tagFilter => _reactiveContentFilterService.tagFilter;
  String get sortByFilter => _reactiveContentFilterService.sortByFilter;
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  ///TEMPORARY DATA
  String tempCityName = "";
  String tempAreaCode = "";
  String tempTagFilter = "";
  String tempSortByFilter = "Latest";

  ///FILTERS
  List<String> sortByList = ["Latest", "Most Popular"];
  Map<String, dynamic> placeSearchResults = {};

  ///API KEYS
  String? googleAPIKey;

  ///INITIALIZE
  initialize() async {
    tempCityName = cityName;
    tempAreaCode = areaCode;
    tempTagFilter = tagFilter;
    tempSortByFilter = sortByFilter;
    googleAPIKey = await _platformDataService.getGoogleApiKey();
    notifyListeners();
  }

  updateSortByFilter(String val) {
    tempSortByFilter = val;
    notifyListeners();
  }

  setPlacesSearchResults(Map<String, dynamic> val) {
    placeSearchResults = val;
    notifyListeners();
  }

  setTagFilter(String val) async {
    tempTagFilter = val;
    notifyListeners();
  }

  ///CLEAR FILTERS
  clearLocationFilter() {
    tempCityName = "Worldwide";
    tempAreaCode = "";
    notifyListeners();
  }

  clearTagFilter() {
    tempTagFilter = "";
    notifyListeners();
  }

  ///GET LOCATION DETAILS
  getPlaceDetails(String place) async {
    updatingData = true;
    notifyListeners();
    String placeID = placeSearchResults[place];
    await googlePlacesService.getDetailsFromPlaceID(key: googleAPIKey, placeID: placeID).then((details) {
      if (details.isNotEmpty) {
        setPlacesSearchResults(details);
        tempCityName = details['cityName'];
        tempAreaCode = details['areaCode'];
        updatingData = false;
        notifyListeners();
      } else {
        _customDialogService.showErrorDialog(description: "There was an issue getting the details of this location. Please try again.");
      }
    });
  }

  ///UPDATE PREFERENCES
  updatePreferences() {
    _reactiveContentFilterService.updateCityName(tempCityName);
    _reactiveContentFilterService.updateAreaCode(tempAreaCode);
    _reactiveContentFilterService.updateSortByFilter(tempSortByFilter);
    _reactiveContentFilterService.updateTagFilter(tempTagFilter);
    notifyListeners();
    updateUserData();
  }

  updateUserData() async {
    if (isLoggedIn) {
      if (tempAreaCode.isNotEmpty) {
        _userDataService.updateLastSeenZipcode(id: user.id, zip: tempAreaCode);
      }
    }
  }
}
