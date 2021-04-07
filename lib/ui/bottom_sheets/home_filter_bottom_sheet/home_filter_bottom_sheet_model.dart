import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/location/google_places_service.dart';

class HomeFilterBottomSheetModel extends BaseViewModel {
  ///SERVICES
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  GooglePlacesService googlePlacesService = locator<GooglePlacesService>();
  AlgoliaSearchService algoliaSearchService = locator<AlgoliaSearchService>();

  ///HELPERS
  TextEditingController locationTextController = TextEditingController();
  TextEditingController tagTextController = TextEditingController();

  ///FILTERS
  String sortBy;
  List<String> sortByList = ["Latest", "Most Popular"];
  String tagFilter;
  Map<String, dynamic> placeSearchResults = {};
  String cityName;
  String areaCode;

  ///API KEYS
  String googleAPIKey;

  ///INITIALIZE
  initialize(String currentSortBy, String currentCity, String currentAreaCode, String currentTagFilter) async {
    sortBy = currentSortBy;
    cityName = currentCity;
    areaCode = currentAreaCode;
    tagFilter = currentTagFilter;
    tagTextController.text = tagFilter;
    locationTextController.text = cityName;
    notifyListeners();
    googleAPIKey = await _platformDataService.getGoogleApiKey();
    notifyListeners();
  }

  ///SET FILTERS
  setSortByFilter(String val) {
    sortBy = val;
    notifyListeners();
  }

  setPlacesSearchResults(Map<String, dynamic> val) {
    placeSearchResults = val;
    notifyListeners();
  }

  setTagFilter(String val) async {
    tagFilter = val;
    tagTextController.text = val;
    notifyListeners();
  }

  ///CLEAR FILTERS
  clearLocationFilter() {
    cityName = "Worldwide";
    areaCode = "";
    locationTextController.text = cityName;
    notifyListeners();
  }

  clearTagFilter() {
    tagFilter = "";
    notifyListeners();
  }

  ///GET LOCATION DETAILS
  getPlaceDetails(String place) async {
    String placeID = placeSearchResults[place];
    locationTextController.text = place;
    googlePlacesService.getDetailsFromPlaceID(key: googleAPIKey, placeID: placeID);
    Map<String, dynamic> details = await googlePlacesService.getDetailsFromPlaceID(key: googleAPIKey, placeID: placeID);
    setPlacesSearchResults(details);
    if (details.isNotEmpty) {
      cityName = details['cityName'];
      areaCode = details['areaCode'];
      notifyListeners();
    } else {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: "There was an issue getting the details of this location. Please Try Again.",
        duration: Duration(seconds: 5),
      );
    }
  }

  ///RETURN PREFERENCES
  Map<String, dynamic> returnPreferences() {
    return {
      "sortBy": sortBy,
      "cityName": cityName,
      "areaCode": areaCode,
      "tagFilter": tagFilter,
    };
  }
}
