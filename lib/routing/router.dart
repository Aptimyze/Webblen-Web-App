import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webblen_web_app/extensions/string_extensions.dart';
import 'package:webblen_web_app/pages/account/account_login_page.dart';
import 'package:webblen_web_app/pages/account/account_page.dart';
import 'package:webblen_web_app/pages/account/account_registration_page.dart';
import 'package:webblen_web_app/pages/account/account_setup_page.dart';
import 'package:webblen_web_app/pages/events/create_event_page.dart';
import 'package:webblen_web_app/pages/events/event_details_page.dart';
import 'package:webblen_web_app/pages/events/events_page.dart';
import 'package:webblen_web_app/pages/home/home_page.dart';
import 'package:webblen_web_app/pages/tickets/purchase_tickets_page.dart';
import 'package:webblen_web_app/pages/tickets/ticket_selection_page.dart';
import 'package:webblen_web_app/pages/wallet/wallet_event_tickets_page.dart';
import 'package:webblen_web_app/pages/wallet/wallet_page.dart';

import 'route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData;
  switch (routingData.route) {
    case HomeRoute:
      return _getPageRoute(HomePage(), settings);
    case EventsRoute:
      return _getPageRoute(EventsPage(), settings);
    case CreateEventRoute:
      return _getPageRoute(CreateEventPage(), settings);
    case EventsDetailsRoute:
      var eventID = routingData['id'];
      return _getPageRoute(EventDetailsPage(eventID: eventID), settings);
    case EventTicketsRoute:
      return _getPageRoute(Container(), settings);
    case EventTicketsSelectionRoute:
      var eventID = routingData['id'];
      return _getPageRoute(TicketSelectionPage(eventID: eventID), settings);
    case EventTicketsPurchaseRoute:
      var eventID = routingData['id'];
      var ticketsToPurchase = routingData['ticketsToPurchase'];
      return _getPageRoute(PurchaseTicketsPage(eventID: eventID, ticketsToPurchase: ticketsToPurchase), settings);
    case AccountLoginRoute:
      return _getPageRoute(AccountLoginPage(), settings);
    case AccountRegistrationRoute:
      return _getPageRoute(AccountRegistrationPage(), settings);
    case AccountSetupRoute:
      return _getPageRoute(AccountSetupPage(), settings);
    case AccountRoute:
      return _getPageRoute(AccountPage(), settings);
    case WalletRoute:
      return _getPageRoute(WalletPage(), settings);
    case WalletEventTicketsRoute:
      var eventID = routingData['id'];
      return _getPageRoute(WalletEventTicketsPage(eventID: eventID), settings);
    default:
      return _getPageRoute(HomePage(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return MaterialPageRoute(builder: (context) => child, settings: RouteSettings(name: settings.name));
}
