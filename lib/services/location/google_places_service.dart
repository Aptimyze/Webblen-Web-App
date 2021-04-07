import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:webblen_web_app/app/app.locator.dart';

import 'location_service.dart';

class GooglePlacesService {
  LocationService _locationService = locator<LocationService>();

  Future googleSearchAutoComplete({@required String key, @required String input}) async {
    Map<String, dynamic> predictions = {};
    List<dynamic> response = [];

    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'googleSearchAutocompleteWeb',
    );

    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'key': key,
      'input': input,
    });

    if (result.data != null) {
      response = result.data;
      response.forEach((val) {
        predictions[val['description']] = val['place_id'];
      });
    }
    return predictions;
  }

  Future<String> googleGetCityFromZip({@required String key, @required String input}) async {
    String cityName;
    final String requestURL = "https://maps.googleapis.com/maps/api/geocode/json?address=$input&key=$key";
    Response response = await get(Uri.parse(requestURL));
    if (response.statusCode == 200) {
      Map<String, dynamic> val = jsonDecode(response.body);
      if (val['error_message'] != null) {
        print('google search zip error code: ${val['error_message']}');
        return null;
      }
      cityName = val['results'][0]['address_components'][1]['long_name'].toString();
      //print(cityName);
    } else {
      print('google search zip error code: ${response.statusCode}');
    }
    return cityName;
  }

  Future<String> googleGetProvinceFromZip({@required String key, @required String input}) async {
    String cityName;
    final String requestURL = "https://maps.googleapis.com/maps/api/geocode/json?address=$input&key=$key";
    Response response = await get(Uri.parse(requestURL));
    if (response.statusCode == 200) {
      Map<String, dynamic> val = jsonDecode(response.body);
      if (val['error_message'] != null) {
        print('google search zip error code: ${val['error_message']}');
        return null;
      }
      cityName = val['results'][0]['address_components'][2]['long_name'].toString();
      //print(cityName);
    } else {
      print('google search zip error code: ${response.statusCode}');
    }
    return cityName;
  }

  Future<Map<String, dynamic>> getDetailsFromPlaceID({@required String key, @required String placeID}) async {
    Map<String, dynamic> details = {};
    Map<String, dynamic> coordinates = await getLatLonFromGooglePlaceID(key: key, placeID: placeID);
    if (coordinates.isNotEmpty) {
      Map<String, dynamic> locDetails = await getLocationDetailsFromLatLon(key: key, lat: coordinates['lat'], lon: coordinates['lon']);
      details['lat'] = coordinates['lat'];
      details['lon'] = coordinates['lon'];
      details['streetAddress'] = locDetails['formattedAddress'];
      details['cityName'] = locDetails['city'];
      details['areaCode'] = locDetails['zipcode'];
    }
    return details;
  }

  Future<Map<String, dynamic>> getLatLonFromGooglePlaceID({@required String key, @required String placeID}) async {
    Map<String, dynamic> coordinates = {};

    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getLatLonFromGooglePlaceIDWeb',
    );

    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'key': key,
      'placeID': placeID,
    });

    if (result.data != null) {
      coordinates = result.data;
    }
    return coordinates;
  }

  Future<Map<String, dynamic>> getLocationDetailsFromLatLon({@required String key, @required double lat, @required double lon}) async {
    Map<String, dynamic> details = {};

    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getLocationDetailsFromLatLonWeb',
    );

    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'key': key,
      'lat': lat,
      'lon': lon,
    });

    if (result.data != null) {
      details = result.data;
    }
    return details;
  }
}
