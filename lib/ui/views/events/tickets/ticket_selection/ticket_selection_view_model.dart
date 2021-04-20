import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_ticket_distro.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/ticket_distro_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class TicketSelectionViewModel extends ReactiveViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  EventDataService _eventDataService = locator<EventDataService>();
  TicketDistroDataService _ticketDistroDataService = locator<TicketDistroDataService>();
  CustomDialogService customDialogService = locator<CustomDialogService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///USER DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  ///HOST
  WebblenUser? host;

  ///TICKET DATA
  WebblenEvent? event;
  DateFormat formatter = DateFormat('MMM dd, yyyy h:mm a');
  WebblenTicketDistro? ticketDistro;

  //payments
  List<String> ticketPurchaseAmounts = ['0', '1', '2', '3', '4'];
  List<Map<String, dynamic>> ticketsToPurchase = [];
  double chargeAmount = 0.00;
  List<String> ticketEmails = [];

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

  ///INITIALIZE
  initialize(String eventID) async {
    setBusy(true);

    // .value will return the raw string value
    String id = eventID;

    //get event data
    var res = await _eventDataService.getEventByID(id);
    if (!res.isValid()) {
      _navigationService.back();
      return;
    } else {
      event = res;
    }

    //get tickets if they exist
    if (event!.hasTickets!) {
      ticketDistro = await _ticketDistroDataService.getTicketDistroByID(event!.id);
      ticketDistro!.tickets!.forEach((ticket) {
        Map<String, dynamic> tData = Map<String, dynamic>.from(ticket);
        tData['purchaseQty'] = 0;
        ticketsToPurchase.add(tData);
      });
    }

    //get author info
    host = await _userDataService.getWebblenUserByID(event!.authorID);

    notifyListeners();
    setBusy(false);
  }

  didSelectTicketQty(String selectedValue, int index) {
    chargeAmount = 0.00;
    int qtyAmount = int.parse(selectedValue);
    ticketsToPurchase[index]['purchaseQty'] = qtyAmount;
    ticketsToPurchase.forEach((ticket) {
      double ticketPrice = double.parse(ticket['ticketPrice'].toString().substring(1));
      double ticketCharge = ticketPrice * ticket['purchaseQty'];
      chargeAmount += ticketCharge;
    });
    notifyListeners();
  }

  List<String> getListOfTicketsAvailableForPurchase(int ticketIndex) {
    List<String> purchaseAmounts = ['0'];
    Map<String, dynamic> ticket = ticketsToPurchase[ticketIndex];
    int qtyAmount = int.parse(ticket['ticketQuantity']);
    if (qtyAmount >= 4) {
      purchaseAmounts = ['0', '1', '2', '3', '4'];
    } else if (qtyAmount >= 3) {
      purchaseAmounts = ['0', '1', '2', '3'];
    } else if (qtyAmount >= 2) {
      purchaseAmounts = ['0', '1', '2'];
    } else if (qtyAmount >= 1) {
      purchaseAmounts = ['0', '1'];
    }
    return purchaseAmounts;
  }

  proceedToCheckout() {
    String ticketsToPurchaseJSON = json.encode(ticketsToPurchase);
    _navigationService.navigateTo(Routes.TicketPurchaseViewRoute(id: event!.id, ticketsToPurchase: ticketsToPurchaseJSON));
  }
}
