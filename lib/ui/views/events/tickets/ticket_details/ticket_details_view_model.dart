import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_event_ticket.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class TicketDetailsViewModel extends ReactiveViewModel {
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  EventDataService _eventDataService = locator<EventDataService>();
  NavigationService _navigationService = locator<NavigationService>();
  TicketDistroDataService _ticketDistroDataService = locator<TicketDistroDataService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  ShareService shareService = locator<ShareService>();

  WebblenEventTicket? ticket;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

  initialize({required String id}) async {
    setBusy(true);
    ticket = await _ticketDistroDataService.getTicketByID(id);
    notifyListeners();
    setBusy(false);
  }
}
