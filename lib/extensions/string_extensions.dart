import 'package:webblen_web_app/routing/routing_data.dart';

extension StringExtensions on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    print("queryParams: ${uriData.queryParameters} path: ${uriData.path}");
    return RoutingData(queryParams: uriData.queryParameters, route: uriData.path);
  }
}
