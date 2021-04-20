import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_event_ticket.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class MyTicketsViewModel extends ReactiveViewModel {
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  EventDataService _eventDataService = locator<EventDataService>();
  NavigationService _navigationService = locator<NavigationService>();
  TicketDistroDataService _ticketDistroDataService = locator<TicketDistroDataService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  ShareService shareService = locator<ShareService>();

  ///USER DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  List<WebblenEvent> events = [];
  List loadedEvents = [];
  Map<String, dynamic> ticsPerEvent = {};

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

  initialize() async {
    setBusy(true);
    List<WebblenEventTicket> purchasedTickets = await _ticketDistroDataService.getPurchasedTickets(user.id!);
    print(purchasedTickets);
    organizeNumOfTicketsByEvent(purchasedTickets);
    setBusy(false);
  }

  organizeNumOfTicketsByEvent(List<WebblenEventTicket> eventTickets) {
    eventTickets.forEach((ticket) {
      List filter = loadedEvents.where((event) => event['id'] == ticket.eventID).toList(growable: true);
      if (filter.isEmpty) {
        loadedEvents.add({
          'id': ticket.eventID!,
          'eventTitle': ticket.eventTitle!,
          'eventAddress': ticket.address!,
          'eventStartDate': ticket.startDate!,
          'eventStartTime': ticket.startTime!,
          'eventEndTime': ticket.endTime!,
          'eventTimezone': ticket.timezone!,
        });
        // WebblenEvent event = await EventDataService().getEventByID(ticket.eventID!);
        // if (event.isValid()) {
        //   events.add(event);
        // }
      }
      if (ticsPerEvent[ticket.eventID] == null) {
        ticsPerEvent[ticket.eventID!] = 1;
      } else {
        ticsPerEvent[ticket.eventID!] += 1;
      }
      if (eventTickets.last == ticket) {
        print(ticsPerEvent);
        print(loadedEvents);
        notifyListeners();
      }
    });
  }

  navigateToEventTickets({required String eventID}) {
    _navigationService.navigateTo(Routes.EventTicketsViewRoute(id: eventID));
  }
}
