import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_event_ticket.dart';
import 'package:webblen_web_app/models/webblen_ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class EventTicketsViewModel extends ReactiveViewModel {
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  EventDataService _eventDataService = locator<EventDataService>();
  TicketDistroDataService _ticketDistroDataService = locator<TicketDistroDataService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  ShareService shareService = locator<ShareService>();

  ///USER DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  WebblenUser? host;
  WebblenEvent? event;
  WebblenTicketDistro? ticketDistro;
  List<WebblenEventTicket> tickets = [];

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

  initialize({required String eventID}) async {
    setBusy(true);
    event = await _eventDataService.getEventByID(eventID);
    ticketDistro = await _ticketDistroDataService.getTicketDistroByID(event!.id!);
    tickets = await _ticketDistroDataService.getPurchasedTicketsFromEvent(user.id!, event!.id!);
    tickets.sort((ticketA, ticketB) => ticketA.name!.compareTo(ticketB.name!));
    host = await _userDataService.getWebblenUserByID(event!.authorID);
    setBusy(false);
  }

  navigateToHostView() {}

  navigateToEventView() {}

  navigateToTicketView({required String ticketID}) {
    _navigationService.navigateTo(Routes.TicketDetailsViewRoute(id: ticketID));
  }
}
