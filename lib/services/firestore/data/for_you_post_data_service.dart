import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/services/firestore/common/firestore_storage_service.dart';

class ForYouPostDataService {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('webblen_users');
  CollectionReference postsRef = FirebaseFirestore.instance.collection('posts');
  CollectionReference eventsRef = FirebaseFirestore.instance.collection('webblen_events');
  CollectionReference streamsRef = FirebaseFirestore.instance.collection('webblen_live_streams');

  int dateTimeInMilliseconds1YearAgo = DateTime.now().millisecondsSinceEpoch - 31500000000;
  FirestoreStorageService _firestoreStorageService = locator<FirestoreStorageService>();

  ///READ & QUERIES
  Future<List<Map<String, dynamic>>> loadSuggestedPosts({
    @required String areaCode,
    @required int resultsLimit,
    @required String tagFilter,
    @required String sortBy,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    List<Map<String, dynamic>> suggestedData = [];
    if (areaCode.isEmpty) {
      query = postsRef
          //.where('suggestedUIDs', arrayContains: uid)
          .where('postDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds1YearAgo)
          .orderBy('postDateTimeInMilliseconds', descending: true)
          .limit(resultsLimit);
    } else {
      query = postsRef
          //.where('suggestedUIDs', arrayContains: uid)
          .where('nearbyZipcodes', arrayContains: areaCode)
          .where('postDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds1YearAgo)
          .orderBy('postDateTimeInMilliseconds', descending: true)
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
      // if (sortBy == "Latest") {
      //   docs.sort((docA, docB) => docB.data()['postDateTimeInMilliseconds'].compareTo(docA.data()['postDateTimeInMilliseconds']));
      // } else {
      //   docs.sort((docA, docB) => docB.data()['commentCount'].compareTo(docA.data()['commentCount']));
      // }
    }

    docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data();
      docData['contentType'] = 'post';
      docData['time'] = docData['postDateTimeInMilliseconds'];
      docData['engagement'] = docData['commentCount'];
      suggestedData.add(docData);
    });

    return suggestedData;
  }

  Future<List<Map<String, dynamic>>> loadAdditionalSuggestedPosts(
      {@required DocumentSnapshot lastDocSnap,
      @required String areaCode,
      @required int resultsLimit,
      @required String tagFilter,
      @required String sortBy}) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    List<Map<String, dynamic>> suggestedData = [];
    if (areaCode.isEmpty) {
      query = postsRef
          //.where('suggestedUIDs', arrayContains: uid)
          .where('postDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds1YearAgo)
          .orderBy('postDateTimeInMilliseconds', descending: true)
          .startAfterDocument(lastDocSnap)
          .limit(resultsLimit);
    } else {
      query = postsRef
          //.where('suggestedUIDs', arrayContains: uid)
          .where('nearbyZipcodes', arrayContains: areaCode)
          .where('postDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds1YearAgo)
          .orderBy('postDateTimeInMilliseconds', descending: true)
          .startAfterDocument(lastDocSnap)
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
      // if (sortBy == "Latest") {
      //   docs.sort((docA, docB) => docB.data()['postDateTimeInMilliseconds'].compareTo(docA.data()['postDateTimeInMilliseconds']));
      // } else {
      //   docs.sort((docA, docB) => docB.data()['commentCount'].compareTo(docA.data()['commentCount']));
      // }
    }

    docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data();
      docData['contentType'] = 'post';
      docData['time'] = docData['postDateTimeInMilliseconds'];
      docData['engagement'] = docData['commentCount'];
      suggestedData.add(docData);
    });

    return suggestedData;
  }

  Future<List<Map<String, dynamic>>> loadFollowingPosts({@required String id, @required int resultsLimit}) async {
    List<DocumentSnapshot> docs = [];
    List<Map<String, dynamic>> suggestedData = [];
    Query query = postsRef.where('followers', arrayContains: id).orderBy('postDateTimeInMilliseconds', descending: true).limit(resultsLimit);
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
      docData['contentType'] = 'post';
      docData['time'] = docData['postDateTimeInMilliseconds'];
      docData['engagement'] = docData['commentCount'];
      suggestedData.add(docData);
    });

    return suggestedData;
  }

  Future<List<Map<String, dynamic>>> loadAdditionalFollowingPosts({
    @required String id,
    @required DocumentSnapshot lastDocSnap,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    List<Map<String, dynamic>> suggested = [];
    Query query = postsRef
        .where('followers', arrayContains: id)
        .orderBy('postDateTimeInMilliseconds', descending: true)
        .startAfterDocument(lastDocSnap)
        .limit(resultsLimit);
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
      docData['contentType'] = 'post';
      docData['time'] = docData['postDateTimeInMilliseconds'];
      docData['engagement'] = docData['commentCount'];
      suggested.add(docData);
    });

    return suggested;
  }
}
