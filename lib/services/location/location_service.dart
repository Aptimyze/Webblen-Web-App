import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:js/js.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/location/google_places_service.dart';
import 'package:webblen_web_app/services/location/location_js.dart';

import 'location_js.dart';

class LocationService {
  Map<String, double> currentLocation;
  Location currentUserLocation = Location();
  DialogService _dialogService = locator<DialogService>();

  PlatformDataService _platformDataService = locator<PlatformDataService>();

  Future<Map<String, dynamic>> getCurrentLocation() async {
    await getCurrentPosition(allowInterop((pos) => success(pos)));
    return currentLocation;
  }

  success(pos) async {
    try {
      print(pos.coords.latitude);
      print(pos.coords.longitude);
      currentLocation['lat'] = pos.coords.latitude;
      currentLocation['lon'] = pos.coords.longitude;
    } catch (ex) {
      print("Location Error Exception thrown : " + ex.toString());
      //currentLocation = null;
    }
  }

  Future<List> findNearestZipcodes(String zipcode) async {
    List zips;
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
    if (result != null) {
      List areaCodes = result.data['data'];
      if (areaCodes != null && areaCodes.isNotEmpty) {
        zips = areaCodes;
      }
    }
    return zips;
  }

  Future<Map<dynamic, dynamic>> reverseGeocodeLatLon(double lat, double lon) async {
    Map<dynamic, dynamic> data;
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
    if (result != null) {
      data = result.data['data'][0];
    }
    return data;
  }

  Future<String> getCurrentZipcode() async {
    currentLocation = await getCurrentLocation();
    if (currentLocation == null) {
      return null;
    }
    double lat = currentLocation['lat'];
    double lon = currentLocation['lon'];
    String zip = await getZipFromLatLon(lat, lon);
    return zip;
  }

  Future<String> getCurrentCity() async {
    currentLocation = await getCurrentLocation();
    if (currentLocation == null) {
      return null;
    }
    double lat = currentLocation['lat'];
    double lon = currentLocation['lon'];
    String city = await getCityNameFromLatLon(lat, lon);
    return city;
  }

  Future<String> getCurrentProvince() async {
    currentLocation = await getCurrentLocation();
    if (currentLocation == null) {
      return null;
    }
    double lat = currentLocation['lat'];
    double lon = currentLocation['lon'];
    String province = await getProvinceFromLatLon(lat, lon);
    return province;
  }

  Future<String> getAddressFromLatLon(double lat, double lon) async {
    String foundAddress;
    Coordinates coordinates = Coordinates(lat, lon);
    String googleAPIKey = await _platformDataService.getGoogleApiKey().catchError((e) {});
    var addresses = await Geocoder.google(googleAPIKey).findAddressesFromCoordinates(coordinates);
    var address = addresses.first;
    foundAddress = address.addressLine;
    return foundAddress;
  }

  Future<String> getZipFromLatLon(double lat, double lon) async {
    String zip;
    Coordinates coordinates = Coordinates(lat, lon);
    String googleAPIKey = await _platformDataService.getGoogleApiKey().catchError((e) {});
    var addresses = await Geocoder.google(googleAPIKey).findAddressesFromCoordinates(coordinates).catchError((e) {});
    var address = addresses.first;
    zip = address.postalCode;
    return zip;
  }

  Future<String> getCityNameFromLatLon(double lat, double lon) async {
    String cityName;
    Coordinates coordinates = Coordinates(lat, lon);
    String googleAPIKey = await _platformDataService.getGoogleApiKey().catchError((e) {});
    var addresses = await Geocoder.google(googleAPIKey).findAddressesFromCoordinates(coordinates);
    var address = addresses.first;
    cityName = address.locality;
    return cityName;
  }

  Future<String> getProvinceFromLatLon(double lat, double lon) async {
    String province;
    Coordinates coordinates = Coordinates(lat, lon);
    String googleAPIKey = await _platformDataService.getGoogleApiKey().catchError((e) {});
    var addresses = await Geocoder.google(googleAPIKey).findAddressesFromCoordinates(coordinates);
    var address = addresses.first;
    province = address.adminArea;
    return province;
  }

  Future<String> getCityFromZip(String zip) async {
    GooglePlacesService _googlePlacesService = locator<GooglePlacesService>();
    String cityName;
    String googleAPIKey = await _platformDataService.getGoogleApiKey().catchError((e) {});
    cityName = await _googlePlacesService.googleSearchZip(key: googleAPIKey, input: zip);
    return cityName;
  }

  openMaps({@required String address}) {
    MapsLauncher.launchQuery(address);
  }
}
