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
import 'package:webblen_web_app/pages/wallet/wallet_earnings_guide_page.dart';
import 'package:webblen_web_app/pages/wallet/wallet_event_tickets_page.dart';
import 'package:webblen_web_app/pages/wallet/wallet_page.dart';
import 'package:webblen_web_app/pages/wallet/wallet_payment_history_page.dart';
import 'package:webblen_web_app/pages/wallet/wallet_payout_methods_page.dart';
import 'package:webblen_web_app/pages/wallet/wallet_setup_direct_deposit_page.dart';
import 'package:webblen_web_app/pages/wallet/wallet_setup_instant_deposit_page.dart';

import 'route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData;
  switch (routingData.route) {
    case HomeRoute:
      return _getPageRoute(HomePage(), settings);
    case EventsRoute:
      return _getPageRoute(EventsPage(), settings);
    case CreateEventRoute:
      var eventID = routingData['id'];
      return _getPageRoute(CreateEventPage(eventID: eventID), settings);
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
    case WalletEarningsGuideRoute:
      return _getPageRoute(WalletEarningsGuidePage(), settings);
    case WalletPaymentsHistoryRoute:
      return _getPageRoute(WalletPaymentHistoryPage(), settings);
    case WalletPayoutMethodsRoute:
      return _getPageRoute(WalletPayoutMethodsPage(), settings);
    case WalletDirectDepositSetupRoute:
      return _getPageRoute(WalletSetupDirectDepositPage(), settings);
    case WalletInstantDepositSetupRoute:
      return _getPageRoute(WalletSetupInstantDepositPage(), settings);
    default:
      return _getPageRoute(HomePage(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
