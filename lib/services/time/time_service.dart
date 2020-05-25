import 'package:timezone/browser.dart' as tz;

class TimeZoneService {
  Future<void> setup() async {
    await tz.initializeTimeZone();
    var detroit = tz.getLocation('America/Detroit');
    var now = tz.TZDateTime.now(detroit);
  }
}
