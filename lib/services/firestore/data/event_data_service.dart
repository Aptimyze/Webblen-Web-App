import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/services/firestore/common/firestore_storage_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';

class EventDataService {
  final CollectionReference eventsRef = FirebaseFirestore.instance.collection("webblen_events");
  PostDataService _postDataService = locator<PostDataService>();

  SnackbarService _snackbarService = locator<SnackbarService>();
  FirestoreStorageService _firestoreStorageService = locator<FirestoreStorageService>();

  int dateTimeInMilliseconds2hrsAgog = DateTime.now().millisecondsSinceEpoch - 7200000;

  Future<bool> checkIfEventExists(String id) async {
    bool exists = false;
    try {
      DocumentSnapshot snapshot = await eventsRef.doc(id).get();
      if (snapshot.exists) {
        exists = true;
      }
    } catch (e) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
      return null;
    }
    return exists;
  }

  Future<bool> checkIfEventSaved({@required String uid, @required String eventID}) async {
    bool saved = false;
    try {
      DocumentSnapshot snapshot = await eventsRef.doc(eventID).get();
      if (snapshot.exists) {
        List savedBy = snapshot.data()['savedBy'] == null ? [] : snapshot.data()['savedBy'].toList(growable: true);
        if (!savedBy.contains(uid)) {
          saved = false;
        } else {
          saved = true;
        }
      }
    } catch (e) {
      return null;
    }
    return saved;
  }

  Future saveUnsaveEvent({@required String uid, @required String eventID, @required bool savedEvent}) async {
    List savedBy = [];
    DocumentSnapshot snapshot = await eventsRef.doc(eventID).get().catchError((e) {
      _snackbarService.showSnackbar(
        title: 'Event Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
      return false;
    });
    if (snapshot.exists) {
      savedBy = snapshot.data()['savedBy'] == null ? [] : snapshot.data()['savedBy'].toList(growable: true);
      if (savedEvent) {
        if (!savedBy.contains(uid)) {
          savedBy.add(uid);
        }
      } else {
        if (savedBy.contains(uid)) {
          savedBy.remove(uid);
        }
      }
      await eventsRef.doc(eventID).update({'savedBy': savedBy});
    }
    return savedBy.contains(uid);
  }

  Future reportEvent({@required String eventID, @required String reporterID}) async {
    DocumentSnapshot snapshot = await eventsRef.doc(eventID).get().catchError((e) {
      _snackbarService.showSnackbar(
        title: 'Event Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
      return null;
    });
    if (snapshot.exists) {
      List reportedBy = snapshot.data()['reportedBy'] == null ? [] : snapshot.data()['reportedBy'].toList(growable: true);
      if (reportedBy.contains(reporterID)) {
        return _snackbarService.showSnackbar(
          title: 'Report Error',
          message: "You've already reported this event. This event is currently pending review.",
          duration: Duration(seconds: 5),
        );
      } else {
        reportedBy.add(reporterID);
        eventsRef.doc(eventID).update({"reportedBy": reportedBy});
        return _snackbarService.showSnackbar(
          title: 'Event Reported',
          message: "This event is now pending review.",
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  Future createEvent({@required WebblenEvent event}) async {
    await eventsRef.doc(event.id).set(event.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future updateEvent({@required WebblenEvent event}) async {
    await eventsRef.doc(event.id).update(event.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future deleteEvent({@required WebblenEvent event}) async {
    await eventsRef.doc(event.id).delete();
    if (event.imageURL != null) {
      await _firestoreStorageService.deleteImage(storageBucket: 'images', folderName: 'events', fileName: event.id);
    }
    await _postDataService.deleteEventOrStreamPost(eventOrStreamID: event.id, postType: 'event');
  }

  Future getEventByID(String id) async {
    WebblenEvent event;
    DocumentSnapshot snapshot = await eventsRef.doc(id).get().catchError((e) {
      print(e.message);
      _snackbarService.showSnackbar(
        title: 'Event Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
      return null;
    });
    if (snapshot.exists) {
      event = WebblenEvent.fromMap(snapshot.data());
    } else if (!snapshot.exists) {
      _snackbarService.showSnackbar(
        title: 'This Event No Longer Exists',
        message: 'This event has been deleted',
        duration: Duration(seconds: 5),
      );
      return null;
    }
    return event;
  }

  Future getEventForEditingByID(String id) async {
    WebblenEvent event;
    DocumentSnapshot snapshot = await eventsRef.doc(id).get().catchError((e) {
      return null;
    });
    if (snapshot.exists) {
      event = WebblenEvent.fromMap(snapshot.data());
    } else if (!snapshot.exists) {
      return null;
    }
    return event;
  }

  ///READ & QUERIES
  Future<List<DocumentSnapshot>> loadEvents({
    @required String areaCode,
    @required int resultsLimit,
    @required String tagFilter,
    @required String sortBy,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
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
      if (!e.message.contains("insufficient permissions")) {
        _snackbarService.showSnackbar(
          title: 'Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
      if (tagFilter.isNotEmpty) {
        docs.removeWhere((doc) => !doc.data()['tags'].contains(tagFilter));
      }
      if (sortBy == "Latest") {
        docs.sort((docA, docB) => docB.data()['startDateTimeInMilliseconds'].compareTo(docA.data()['startDateTimeInMilliseconds']));
      } else {
        docs.sort((docA, docB) => docB.data()['savedBy'].length.compareTo(docA.data()['savedBy'].length));
      }
    }
    return docs;
  }

  Future<List<DocumentSnapshot>> loadAdditionalEvents(
      {@required DocumentSnapshot lastDocSnap,
      @required String areaCode,
      @required int resultsLimit,
      @required String tagFilter,
      @required String sortBy}) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    if (areaCode.isEmpty) {
      query = eventsRef
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: true)
          .startAfterDocument(lastDocSnap)
          .limit(resultsLimit);
    } else {
      query = eventsRef
          .where('nearbyZipcodes', arrayContains: areaCode)
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: true)
          .startAfterDocument(lastDocSnap)
          .limit(resultsLimit);
    }
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        _snackbarService.showSnackbar(
          title: 'Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
      if (tagFilter.isNotEmpty) {
        docs.removeWhere((doc) => !doc.data()['tags'].contains(tagFilter));
      }
      if (sortBy == "Latest") {
        docs.sort((docA, docB) => docB.data()['startDateTimeInMilliseconds'].compareTo(docA.data()['startDateTimeInMilliseconds']));
      } else {
        docs.sort((docA, docB) => docB.data()['savedBy'].length.compareTo(docA.data()['savedBy'].length));
      }
    }
    return docs;
  }

  Future<List<DocumentSnapshot>> loadEventsByUserID({@required String id, @required int resultsLimit}) async {
    List<DocumentSnapshot> docs = [];
    Query query = eventsRef.where('authorID', isEqualTo: id).orderBy('startDateTimeInMilliseconds', descending: true).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        _snackbarService.showSnackbar(
          title: 'Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }

  Future<List<DocumentSnapshot>> loadAdditionalEventsByUserID({
    @required String id,
    @required DocumentSnapshot lastDocSnap,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query =
        eventsRef.where('authorID', isEqualTo: id).orderBy('startDateTimeInMilliseconds', descending: true).startAfterDocument(lastDocSnap).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        _snackbarService.showSnackbar(
          title: 'Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }
}
