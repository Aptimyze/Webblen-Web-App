import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ForYouEventDataService {
  CollectionReference eventsRef = FirebaseFirestore.instance.collection('webblen_events');

  int dateTimeInMilliseconds2hrsAgog = DateTime.now().millisecondsSinceEpoch - 7200000;

  ///READ & QUERIES
  Future<List<Map<String, dynamic>>> loadSuggestedEvents({
    @required String areaCode,
    @required int resultsLimit,
    @required String tagFilter,
    @required String sortBy,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    List<Map<String, dynamic>> suggested = [];
    if (areaCode.isEmpty) {
      query = eventsRef
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: false)
          .limit(resultsLimit);
    } else {
      query = eventsRef
          .where('nearbyZipcodes', arrayContains: areaCode)
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: false)
          .limit(resultsLimit);
    }
    QuerySnapshot snapshot = await query.get().catchError((e) {
      print(e);
      if (!e.message.contains("insufficient permissions")) {}
      return null;
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
      if (tagFilter.isNotEmpty) {
        docs.removeWhere((doc) => !doc.data()['tags'].contains(tagFilter));
      }
    }

    docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data();
      docData['contentType'] = 'event';
      docData['time'] = docData['startDateTimeInMilliseconds'];
      docData['engagement'] = docData['savedBy'].length;
      suggested.add(docData);
    });

    return suggested;
  }

  Future<List<Map<String, dynamic>>> loadAdditionalSuggestedEvents({
    @required int lastStartDate,
    @required String areaCode,
    @required int resultsLimit,
    @required String tagFilter,
    @required String sortBy,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    List<Map<String, dynamic>> suggested = [];
    if (areaCode.isEmpty) {
      query = eventsRef
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: true)
          .startAfter([lastStartDate]).limit(resultsLimit);
    } else {
      query = eventsRef
          .where('nearbyZipcodes', arrayContains: areaCode)
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: true)
          .startAfter([lastStartDate]).limit(resultsLimit);
    }
    QuerySnapshot snapshot = await query.get().catchError((e) {
      print(e);
      if (!e.message.contains("insufficient permissions")) {}
      return null;
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
      if (tagFilter.isNotEmpty) {
        docs.removeWhere((doc) => !doc.data()['tags'].contains(tagFilter));
      }
    }

    docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data();
      docData['contentType'] = 'event';
      docData['time'] = docData['startDateTimeInMilliseconds'];
      docData['engagement'] = docData['savedBy'].length;
      suggested.add(docData);
    });

    return suggested;
  }

  Future<List<Map<String, dynamic>>> loadFollowingEvents({@required String id, @required int resultsLimit}) async {
    List<DocumentSnapshot> docs = [];
    List<Map<String, dynamic>> suggested = [];
    Query query = eventsRef.where('followers', arrayContains: id).orderBy('startDateTimeInMilliseconds', descending: true).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      print(e);
      if (!e.message.contains("insufficient permissions")) {}
      return null;
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }

    docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data();
      docData['contentType'] = 'event';
      docData['time'] = docData['startDateTimeInMilliseconds'];
      docData['engagement'] = docData['savedBy'].length;
      suggested.add(docData);
    });

    return suggested;
  }

  Future<List<Map<String, dynamic>>> loadAdditionalFollowingEvents({
    @required int lastStartDate,
    @required String id,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    List<Map<String, dynamic>> suggested = [];
    Query query = eventsRef
        .where('followers', arrayContains: id)
        .orderBy('startDateTimeInMilliseconds', descending: true)
        .startAfter([lastStartDate]).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      print(e);
      if (!e.message.contains("insufficient permissions")) {}
      return null;
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }

    docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data();
      docData['contentType'] = 'event';
      docData['time'] = docData['startDateTimeInMilliseconds'];
      docData['engagement'] = docData['savedBy'].length;
      suggested.add(docData);
    });

    return suggested;
  }
}
