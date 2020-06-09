import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:webblen_web_app/models/event_ticket.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';

class StripePaymentService {
  static final firestore = firebase.firestore();
  CollectionReference stripeRef = firestore.collection("stripe");
  CollectionReference stripeActivityRef = firestore.collection("stripe_connect_activity");
  CollectionReference ticketDistroRef = firestore.collection("event_ticket_distros");
  CollectionReference purchasedTicketsRef = firestore.collection("purchased_tickets");

  Future<String> purchaseTickets(
    String eventTitle,
    String purchaserID,
    String eventHostID,
    String eventHostName,
    double totalCharge,
    double ticketCharge,
    int numberOfTickets,
    String cardNumber,
    int expMonth,
    int expYear,
    String cvcNumber,
    String cardHolderName,
    String email,
  ) async {
    String status;
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'testWebPurchaseTickets',
    );

    int ticketChargeInCents = int.parse((ticketCharge.toStringAsFixed(2)).replaceAll(".", ""));
    int totalChargeInCents = int.parse((totalCharge.toStringAsFixed(2)).replaceAll(".", ""));

    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'eventTitle': eventTitle,
        'purchaserID': purchaserID,
        'eventHostID': eventHostID,
        'eventHostName': eventHostName,
        'totalCharge': totalChargeInCents,
        'ticketCharge': ticketChargeInCents,
        'numberOfTickets': numberOfTickets,
        'cardNumber': cardNumber,
        'expMonth': expMonth,
        'expYear': expYear,
        'cvcNumber': cvcNumber,
        'cardHolderName': cardHolderName,
        'email': email,
      },
    ).catchError((e) {
      print(e);
    });
    if (result.data != null) {
      status = result.data['status'];
      print(status);
    }
    return status;
  }

  Future<String> completeTicketPurchase(String uid, List ticketsToPurchase, WebblenEvent event) async {
    String error = "";
    print('completing purchase...');
    DocumentSnapshot snapshot = await ticketDistroRef.doc(event.id).get();
    print(snapshot);
    TicketDistro ticketDistro = TicketDistro.fromMap(snapshot.data());
    print(ticketDistro);
    List validTicketIDs = ticketDistro.validTicketIDs.toList(growable: true);
    ticketsToPurchase.forEach((purchasedTicket) async {
      String ticketName = purchasedTicket['ticketName'];
      int ticketIndex = ticketDistro.tickets.indexWhere((ticket) => ticket["ticketName"] == ticketName);
      int ticketPurchaseQty = purchasedTicket['qty'];
      int ticketAvailableQty = int.parse(purchasedTicket['ticketQuantity']);
      String newTicketAvailableQty = (ticketAvailableQty - ticketPurchaseQty).toString();
      ticketDistro.tickets[ticketIndex]['ticketQuantity'] = newTicketAvailableQty;
      for (int i = ticketPurchaseQty; i >= 1; i--) {
        String ticketID = randomAlphaNumeric(32);
        validTicketIDs.add(ticketID);
        EventTicket newTicket = EventTicket(
          ticketID: ticketID,
          ticketName: ticketName,
          purchaserUID: uid,
          eventID: event.id,
          eventImageURL: event.imageURL,
          eventTitle: event.title,
          address: event.streetAddress,
          startDate: event.startDate,
          endDate: event.endDate,
          startTime: event.startTime,
          endTime: event.endTime,
          timezone: event.timezone,
        );
        await purchasedTicketsRef.doc(ticketID).set(newTicket.toMap()).catchError((e) {
          error = e;
        });
      }
      await ticketDistroRef.doc(event.id).update(data: {
        "tickets": ticketDistro.tickets,
        "validTicketIDs": validTicketIDs,
      }).catchError((e) {
        error = e;
      });
    });
    return error;
  }

//  Future<bool> checkIfStripeSetup(String uid) async {
//    bool stripeIsSetup = false;
//    DocumentSnapshot documentSnapshot = await stripeRef.doc(uid).get();
//    if (documentSnapshot.exists) {
//      stripeIsSetup = true;
//    }
//    return stripeIsSetup;
//  }

  Future<String> getStripeUID(String uid) async {
    String stripeUID;
    DocumentSnapshot snapshot = await stripeRef.doc(uid).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data();
      stripeUID = data['stripeUID'];
    }
    return stripeUID;
  }

  Future<Map<String, dynamic>> checkAccountVerificationStatus(String uid) async {
    Map<String, dynamic> res;
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'checkAccountVerificationStatus',
    );
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'uid': uid,
      },
    );
    if (result.data != null) {
      res = Map<String, dynamic>.from(result.data);
    }
    return res;
  }

  Future<String> updateAccountVerificationStatus(String uid) async {
    String status = "pending";
    Map<String, dynamic> accountVerificationStatus = await checkAccountVerificationStatus(uid);
    List currentlyDue = accountVerificationStatus['currently_due'];
    List pending = accountVerificationStatus['pending_verification'];
    if (currentlyDue.length > 1 || pending.isNotEmpty) {
      await stripeRef.doc(uid).update(data: {"verified": "pending"});
    } else {
      await stripeRef.doc(uid).update(data: {"verified": "verified"});
      status = "verified";
    }
    return status;
  }

  Future<Map<String, dynamic>> getStripeAccountBalance(String uid, String stripeUID) async {
    Map<String, dynamic> res;
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'getStripeAccountBalance',
    );
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'uid': uid,
        'stripeUID': stripeUID,
      },
    );
    if (result.data != null) {
      res = Map<String, dynamic>.from(result.data);
    }
    return res;
  }

  Future<String> performInstantStripePayout(String uid, String stripeUID) async {
    String status;
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'performInstantStripePayout',
    );
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'uid': uid,
        'stripeUID': stripeUID,
      },
    );
    if (result.data != null) {
      status = result.data;
    }
    return status;
  }

  Future<String> submitBankingInfoToStripe(
      String uid, String stripeUID, String accountHolderName, String accountHolderType, String routingNumber, String accountNumber) async {
    String status;
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'submitBankingInfoWeb',
    );
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'uid': uid,
        'stripeUID': stripeUID,
        'accountHolderName': accountHolderName,
        'accountHolderType': accountHolderType,
        'routingNumber': routingNumber,
        'accountNumber': accountNumber,
      },
    );
    if (result.data != null) {
      status = result.data['status'];
    }
    return status;
  }

  Future<String> submitCardInfoToStripe(
      String uid, String stripeUID, String cardNumber, int expMonth, int expYear, String cvcNumber, String cardHolderName) async {
    String status;
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'submitCardInfoWeb',
    );
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'uid': uid,
        'stripeUID': stripeUID,
        "cardNumber": cardNumber,
        "expMonth": expMonth,
        "expYear": expYear,
        "cvcNumber": cvcNumber,
        "cardHolderName": cardHolderName,
      },
    );
    if (result.data != null) {
      status = result.data['status'];
    }
    return status;
  }

//  Stream<List<DocumentSnapshot>> streamPaymentHistory(String uid, DocumentSnapshot lastDocumentSnapshot) {
//    var pagePaymentsQuery = stripeActivityRef.where("uid", "==", uid).orderBy("timePosted").limit(5);
//    if (lastDocumentSnapshot != null){
//      pagePaymentsQuery.startAfter(snapshot: lastDocumentSnapshot)
//    }
//    return pagePaymentsQuery.onSnapshot.map((querySnapshot) => List<DocumentSnapshot>.from(querySnapshot.docs));
//  }

}
