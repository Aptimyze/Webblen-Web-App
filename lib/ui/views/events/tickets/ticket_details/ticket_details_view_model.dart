import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_event_ticket.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class TicketDetailsViewModel extends BaseViewModel {
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  TicketDistroDataService _ticketDistroDataService = locator<TicketDistroDataService>();
  ShareService shareService = locator<ShareService>();

  WebblenEventTicket? ticket;

  initialize({required String id}) async {
    setBusy(true);
    ticket = await _ticketDistroDataService.getTicketByID(id);
    notifyListeners();
    setBusy(false);
  }
}
