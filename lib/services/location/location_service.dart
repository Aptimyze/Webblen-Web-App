import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:js/js.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/location/google_places_service.dart';
import 'package:webblen_web_app/services/location/location_js.dart';

import 'location_js.dart';

class LocationService {
  Map<String, double?>? currentLocation;
  Location currentUserLocation = Location();

  PlatformDataService? _platformDataService = locator<PlatformDataService>();

  Future<Map<String, dynamic>?> getCurrentLocation() async {
    getCurrentPosition(allowInterop((pos) => success(pos)));
    return currentLocation;
  }

  success(pos) async {
    try {
      print(pos.coords.latitude);
      print(pos.coords.longitude);
      currentLocation!['lat'] = pos.coords.latitude;
      currentLocation!['lon'] = pos.coords.longitude;
    } catch (ex) {
      print("Location Error Exception thrown : " + ex.toString());
      //currentLocation = null;
    }
  }

  Future<List?> findNearestZipcodes(String? zipcode) async {
    List? zips;
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'findNearestZipcodes',
    );

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'zipcode': zipcode,
      },
    ).catchError((e) {
      //print(e);
    });
    if (result.data != null) {
      List? areaCodes = result.data['data'];
      if (areaCodes != null && areaCodes.isNotEmpty) {
        zips = areaCodes;
      }
    }
    return zips;
  }

  Future<Map<dynamic, dynamic>?> reverseGeocodeLatLon(double lat, double lon) async {
    Map<dynamic, dynamic>? data;
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'reverseGeocodeLatLon',
    );
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'lat': lat,
        'lon': lon,
      },
    ).catchError((e) {
      //print(e);
    });
    if (result.data != null) {
      data = result.data['data'][0];
    }
    return data;
  }

  Future<Map<String, dynamic>> getLocationDetailsFromLatLon(double lat, double lon) async {
    Map<String, dynamic> details = {};
    String? error;
    GooglePlacesService _googlePlacesService = locator<GooglePlacesService>();
    String? key = await _platformDataService!.getGoogleApiKey().catchError((e) {
      error = e.toString();
    });
    if (error != null) {
      return details;
    }
    details = await _googlePlacesService.getLocationDetailsFromLatLon(key: key, lat: lat, lon: lon);
    return details;
  }

  Future<String?> getCityFromZip(String? zip) async {
    GooglePlacesService _googlePlacesService = locator<GooglePlacesService>();
    String? cityName;
    String? googleAPIKey = await _platformDataService!.getGoogleApiKey().catchError((e) {});
    cityName = await _googlePlacesService.googleGetCityFromZip(key: googleAPIKey, input: zip);
    return cityName;
  }

  Future<String?> getProvinceFromZip(String zip) async {
    GooglePlacesService _googlePlacesService = locator<GooglePlacesService>();
    String? province;
    String? googleAPIKey = await _platformDataService!.getGoogleApiKey().catchError((e) {});
    province = await _googlePlacesService.googleGetProvinceFromZip(key: googleAPIKey, input: zip);
    return province;
  }

  openMaps({required String address}) {
    MapsLauncher.launchQuery(address);
  }
}
