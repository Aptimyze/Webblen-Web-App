import 'dart:js';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';

import 'location_services_js.dart';

class LocationService {
  static final firestore = firebase.firestore();
  CollectionReference eventsRef = firestore.collection("events");

  success(pos) {
    try {
      print(pos.coords.latitude);
      print(pos.coords.longitude);
    } catch (ex) {
      print("Exception thrown : " + ex.toString());
    }
  }

  Future<Map<String, dynamic>> getCurrentLocation() async {
    Map<String, dynamic> coords = {};
    await getCurrentPosition(allowInterop((pos) {
      try {
        coords['lat'] = pos.coords.latitude;
        coords['lon'] = pos.coords.longitude;
        print(pos.coords.latitude);
        print(pos.coords.longitude);
      } catch (ex) {
        print("Exception thrown : " + ex.toString());
      }
      return;
    }));
    return coords;
  }

  Future<List> findNearestZipcodes(String zipcode) async {
    List zips = [];
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'findNearestZipcodes',
    );

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'zipcode': zipcode,
      },
    ).catchError((e) {
      print(e);
    });
    if (result != null) {
      List areaCodes = result.data['data'];
      if (areaCodes.isNotEmpty) {
        zips = areaCodes;
      }
    }
    return zips;
  }
}
