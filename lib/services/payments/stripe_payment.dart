import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:webblen_web_app/models/event_ticket.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';

class StripePaymentService {
  static final firestore = firebase.firestore();
  CollectionReference eventsRef = firestore.collection("events");
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

    print('purchasing tickets...');
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
}
