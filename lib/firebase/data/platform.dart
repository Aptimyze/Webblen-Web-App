import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';

class PlatformDataService {
  static final firestore = firebase.firestore();
  CollectionReference appReleaseRef = firestore.collection("app_release_info");

  //READ
  Future<double> getEventTicketFee() async {
    double eventTicketFee;
    DocumentSnapshot snapshot = await appReleaseRef.doc('general').get();
    eventTicketFee = snapshot.data()['ticketFee'];
    return eventTicketFee;
  }

  Future<double> getTaxRate() async {
    double taxRate;
    DocumentSnapshot snapshot = await appReleaseRef.doc('general').get();
    taxRate = snapshot.data()['taxRate'];
    return taxRate;
  }
}
