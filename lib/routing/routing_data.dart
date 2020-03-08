class RoutingData {
  final String route;
  final Map<String, String> _queryParams;

  RoutingData({this.route, Map<String, String> queryParams}) : _queryParams = queryParams;

  operator [](String key) => _queryParams[key];
}
