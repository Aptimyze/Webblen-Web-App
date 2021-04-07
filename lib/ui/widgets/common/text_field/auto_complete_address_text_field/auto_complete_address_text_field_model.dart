import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/location/google_places_service.dart';

class AutoCompleteAddressTextFieldModel extends BaseViewModel {
  ///SERVICES
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  DialogService _dialogService = locator<DialogService>();
  GooglePlacesService googlePlacesService = locator<GooglePlacesService>();

  ///HELPERS
  TextEditingController locationTextController = TextEditingController();

  ///RESULTS
  Map<String, dynamic> placeSearchResults = {};

  ///API KEYS
  String googleAPIKey;

  ///INITIALIZE
  initialize({@required String initialValue}) async {
    locationTextController.text = initialValue;
    notifyListeners();
    googleAPIKey = await _platformDataService.getGoogleApiKey();
    notifyListeners();
  }

  ///SET RESULTS
  setPlacesSearchResults(Map<String, dynamic> val) {
    placeSearchResults = val;
    notifyListeners();
  }

  ///GET LOCATION DETAILS
  Future<Map<String, dynamic>> getPlaceDetails(String place) async {
    Map<String, dynamic> details = {};
    String placeID = placeSearchResults[place];
    locationTextController.text = place;
    notifyListeners();
    details = await googlePlacesService.getDetailsFromPlaceID(key: googleAPIKey, placeID: placeID);
    setPlacesSearchResults(details);
    notifyListeners();
    if (details.isEmpty) {
      _dialogService.showDialog(
        title: 'Error',
        description: "There was an issue getting the details of this location. Please Try Again.",
      );
    }
    return details;
  }
}
