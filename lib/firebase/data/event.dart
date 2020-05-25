import 'dart:html';

import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:random_string/random_string.dart';
import 'package:webblen_web_app/firebase/services/image_upload.dart';
import 'package:webblen_web_app/models/event_ticket.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';

class EventDataService {
  static final firestore = firebase.firestore();
  CollectionReference eventsRef = firestore.collection("events");
  CollectionReference ticketsRef = firestore.collection("purchased_tickets");
  CollectionReference ticketDistroRef = firestore.collection("event_ticket_distros");
  Geoflutterfire geo = Geoflutterfire();

  //CREATE
  Future<String> uploadEvent(WebblenEvent newEvent, File eventImageFile, TicketDistro ticketDistro) async {
    String error;
    String newEventID = randomAlphaNumeric(12);
    String eventImageURL = await ImageUploadService().uploadImageToFirebaseStorage(eventImageFile, EventImgFile, newEventID);
    newEvent.id = newEventID;
    newEvent.imageURL = eventImageURL;
    if (!newEvent.isDigitalEvent) {
      GeoFirePoint geoFirePoint = geo.point(
        latitude: newEvent.lat,
        longitude: newEvent.lon,
      );
      await eventsRef.doc(newEventID).set({'d': newEvent.toMap(), 'g': geoFirePoint.hash, 'l': geoFirePoint.geoPoint});
    } else {
      await eventsRef.doc(newEventID).set({'d': newEvent.toMap(), 'g': null, 'l': null});
    }
    if (ticketDistro.tickets.isNotEmpty) {
      print('uploading tickets');
      await uploadEventTickets(newEventID, ticketDistro);
    }
    return error;
  }

  Future<String> uploadEventTickets(String eventID, TicketDistro ticketDistro) async {
    String error;
    await ticketDistroRef.doc(eventID).set(ticketDistro.toMap()).catchError((e) {
      error = e.details;
    });
    return error;
  }

  //READ
  Future<List<WebblenEvent>> getEvents({String cityFilter, String stateFilter, String categoryFilter, String typeFilter}) async {
    List<WebblenEvent> events = [];
    QuerySnapshot querySnapshot = await eventsRef.get();
    querySnapshot.docs.forEach((snapshot) {
      WebblenEvent event = WebblenEvent.fromMap(snapshot.data());
      events.add(event);
    });
    events.sort((eventA, eventB) => eventA.startDateTimeInMilliseconds.compareTo(eventB.startDateTimeInMilliseconds));
    return events;
  }

  Future<WebblenEvent> getEvent(String eventID) async {
    WebblenEvent event;
    await eventsRef.doc(eventID).get().then((res) {
      if (res.exists) {
        print(res);
        event = WebblenEvent.fromMap(res.data());
      }
    }).catchError((e) {
      print(e.details);
    });
    return event;
  }

  Future<TicketDistro> getEventTicketDistro(String eventID) async {
    TicketDistro ticketDistro;
    DocumentSnapshot snapshot = await ticketDistroRef.doc(eventID).get();
    if (snapshot.exists) {
      ticketDistro = TicketDistro.fromMap(snapshot.data());
    }
    return ticketDistro;
  }

  Future<List<EventTicket>> getPurchasedTickets(String uid) async {
    List<EventTicket> eventTickets = [];
    QuerySnapshot snapshot = await ticketsRef.where("purchaserUID", "==", uid).get();
    snapshot.docs.forEach((doc) {
      EventTicket ticket = EventTicket.fromMap(doc.data());
      eventTickets.add(ticket);
    });
    return eventTickets;
  }

  Future<List<EventTicket>> getPurchasedTicketsFromEvent(String uid, String eventID) async {
    List<EventTicket> eventTickets = [];
    QuerySnapshot snapshot = await ticketsRef.where("purchaserUID", "==", uid).where("eventID", "==", eventID).get();
    snapshot.docs.forEach((doc) {
      EventTicket ticket = EventTicket.fromMap(doc.data());
      eventTickets.add(ticket);
    });
    return eventTickets;
  }
}
