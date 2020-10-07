import 'dart:html';

import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:webblen_web_app/firebase/services/image_upload.dart';
import 'package:webblen_web_app/models/event_ticket.dart';
import 'package:webblen_web_app/models/ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/services/location/location_service.dart';

class EventDataService {
  static final firestore = firebase.firestore();
  CollectionReference eventsRef = firestore.collection("events");
  CollectionReference ticketsRef = firestore.collection("purchased_tickets");
  CollectionReference ticketDistroRef = firestore.collection("ticket_distros");
  //Geoflutterfire geo = Geoflutterfire();

  //CREATE
  Future<String> uploadEvent(WebblenEvent newEvent, String zipPostalCode, File eventImageFile, TicketDistro ticketDistro) async {
    String error;
    List nearbyZipcodes = [];
    String newEventID;
    if (newEvent.id == null || newEvent.id.isEmpty) {
      newEventID = randomAlphaNumeric(12);
      newEvent.id = newEventID;
    } else {
      newEventID = newEvent.id;
    }
    if (eventImageFile != null) {
      String eventImageURL = await ImageUploadService().uploadImageToFirebaseStorage(eventImageFile, EventImgFile, newEventID);
      newEvent.imageURL = eventImageURL;
    }
    newEvent.webAppLink = 'https://app.webblen.io/event?id=$newEventID';
    if (!newEvent.isDigitalEvent && zipPostalCode != null) {
      List listOfAreaCodes = await LocationService().findNearestZipcodes(zipPostalCode);
      if (listOfAreaCodes != null) {
        nearbyZipcodes = listOfAreaCodes;
      } else {
        nearbyZipcodes.add(zipPostalCode);
      }
      newEvent.nearbyZipcodes = nearbyZipcodes;
    }
    if (ticketDistro.tickets.isNotEmpty) {
      newEvent.hasTickets = true;
    }
    await eventsRef.doc(newEventID).set({'d': newEvent.toMap(), 'g': null, 'l': null}).catchError((e) => print(e));
    if (ticketDistro.tickets.isNotEmpty) {
      await uploadEventTickets(newEventID, ticketDistro);
    }
    return error;
  }

  Future<String> uploadEventTickets(String eventID, TicketDistro ticketDistro) async {
    String error;
    await ticketDistroRef.doc(eventID).set(ticketDistro.toMap()).catchError((e) {
      error = e.details;
    }).catchError((e) => print(e));
    return error;
  }

  //READ
  Future<List<WebblenEvent>> getEvents({String cityFilter, String stateFilter, String categoryFilter, String typeFilter}) async {
    List<WebblenEvent> events = [];
    QuerySnapshot querySnapshot = await eventsRef.get();
    querySnapshot.docs.forEach((snapshot) {
      WebblenEvent event = WebblenEvent.fromMap(snapshot.data()['d']);
      events.add(event);
    });
    events.sort((eventA, eventB) => eventA.startDateTimeInMilliseconds.compareTo(eventB.startDateTimeInMilliseconds));
    return events;
  }

  Future<WebblenEvent> getEvent(String eventID) async {
    WebblenEvent event;
    await eventsRef.doc(eventID).get().then((res) {
      if (res.exists) {
        event = WebblenEvent.fromMap(res.data()['d']);
      }
    }).catchError((e) {
      print(e.details);
    });
    return event;
  }

  Future<List<WebblenEvent>> getTrendingEvents() async {
    List<WebblenEvent> events = [];
    QuerySnapshot querySnapshot = await eventsRef.orderBy('d.clicks').limit(3).get();
    querySnapshot.docs.forEach((snapshot) {
      WebblenEvent event = WebblenEvent.fromMap(snapshot.data()['d']);
      events.add(event);
    });
    events.sort((eventA, eventB) => eventA.startDateTimeInMilliseconds.compareTo(eventB.startDateTimeInMilliseconds));
    return events;
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

  Future<List<WebblenEvent>> getMyEvents(String uid) async {
    List<WebblenEvent> events = [];
    QuerySnapshot snapshot = await eventsRef.where("d.authorID", "==", uid).orderBy('d.startDateTimeInMilliseconds').get();
    snapshot.docs.forEach((doc) {
      WebblenEvent event = WebblenEvent.fromMap(doc.data()['d']);
      events.add(event);
    });
    return events;
  }
}
