import 'package:algolia/algolia.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:webblen_web_app/models/webblen_event.dart';

class AlgoliaSearch {
  static final firestore = firebase.firestore();
  DocumentReference algoliaDocRef = firestore.collection("app_release_info").doc("algolia");

  Future<Algolia> initializeAlgolia() async {
    Algolia algolia;
    String appID;
    String apiKey;
    DocumentSnapshot snapshot = await algoliaDocRef.get();
    appID = snapshot.data()['appID'];
    apiKey = snapshot.data()['apiKey'];
    algolia = Algolia.init(applicationId: appID, apiKey: apiKey);
    return algolia;
  }

  Future<List<WebblenEvent>> queryEvents(String searchTerm) async {
    Algolia algolia = await initializeAlgolia();
    List<WebblenEvent> events = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('events').search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        WebblenEvent event = WebblenEvent.fromMap(snapshot.data);
        events.add(event);
      });
    }
    return events;
  }

  Future<List<Map<String, dynamic>>> queryCommunities(String searchTerm) async {
    Algolia algolia = await initializeAlgolia();
    List<Map<String, dynamic>> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('communities').search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        Map<String, dynamic> dataMap = {};
        dataMap['resultType'] = 'community';
        dataMap['resultHeader'] = snapshot.data['name'];
        dataMap['imageData'] = snapshot.data['comImageURL'];
        dataMap['data'] = snapshot.data['areaName'];
        results.add(dataMap);
      });
    }
    return results;
  }

  Future<List<Map<String, dynamic>>> queryUsers(String searchTerm) async {
    Algolia algolia = await initializeAlgolia();
    List<Map<String, dynamic>> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('users').search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        Map<String, dynamic> dataMap = {};
        dataMap['resultType'] = 'people';
        dataMap['resultHeader'] = "@" + snapshot.data['d']['username'];
        dataMap['imageData'] = snapshot.data['d']['profile_pic'];
        dataMap['key'] = snapshot.data['d']['uid'];
        results.add(dataMap);
      });
    }
    return results;
  }
}
