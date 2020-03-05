import 'package:firebase/firebase.dart' as firebase;

class EventDataService {
  var firestore = firebase.firestore();

  getEvents() async {
    var querySnapshot = await firestore.collection("upcoming_events").get();
    print(querySnapshot.docs.length);
  }
}
