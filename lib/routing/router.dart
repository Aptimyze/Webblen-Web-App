import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webblen_web_app/extensions/string_extensions.dart';
import 'package:webblen_web_app/pages/events/index/events_page.dart';
import 'package:webblen_web_app/pages/home/home_page.dart';

import 'route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData;
  switch (routingData.route) {
    case HomeRoute:
      return _getPageRoute(HomePage(), settings);
    case EventsRoute:
      return _getPageRoute(EventsPage(), settings);
    case EventTicketsRoute:
      return _getPageRoute(Container(), settings);
    case AccountRoute:
      return _getPageRoute(Container(), settings);
    default:
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return MaterialPageRoute(builder: (context) => child, settings: RouteSettings(name: settings.name));
}
