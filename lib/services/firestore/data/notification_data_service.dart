import 'package:auto_route/auto_route.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/models/webblen_notification.dart';

class NotificationDataService {
  SnackbarService _snackbarService = locator<SnackbarService>();
  CollectionReference notifsRef = fb.firestore().collection("webblen_notifications");

  Future<int> getNumberOfUnreadNotifications(String uid) async {
    int num = 0;
    QuerySnapshot snapshot = await notifsRef.where('receiverUID', '==', uid).where('read', '==', false).get();
    if (snapshot.docs.isNotEmpty) {
      num = snapshot.docs.length;
    }
    return num;
  }

  changeUnreadNotificationStatus(String uid) async {
    QuerySnapshot snapshot = await notifsRef.where('receiverUID', '==', uid).where('read', '==', false).get();
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) async {
        await notifsRef.doc(doc.id).update(data: {'read': true}).catchError((e) {
          return e.message;
        });
      });
    }
  }

  Future sendNotification({
    @required WebblenNotification notif,
  }) async {
    String notifID = notif.receiverUID + "-" + notif.timePostedInMilliseconds.toString();
    await notifsRef.doc(notifID).set(notif.toMap()).catchError((e) {
      return e.message;
    });
  }

  ///QUERY DATA
  //Load Comments Created
  Future<List<DocumentSnapshot>> loadNotifications({
    @required String uid,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    QuerySnapshot snapshot = await notifsRef.where('receiverUID', '==', uid).orderBy('expDateInMilliseconds', 'desc').limit(15).get().catchError((e) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }

  //Load Additional Causes by Follower Count
  Future<List<DocumentSnapshot>> loadAdditionalNotifications({
    @required String uid,
    @required DocumentSnapshot lastDocSnap,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    QuerySnapshot snapshot = await notifsRef
        .where('receiverUID', '==', uid)
        .orderBy('expDateInMilliseconds', 'desc')
        .startAfter(snapshot: lastDocSnap)
        .limit(15)
        .get()
        .catchError((e) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }
}
