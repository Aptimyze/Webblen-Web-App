import 'package:intl/intl.dart';
import 'package:timezone/browser.dart' as tz;

class TimeService {
  DateTime currentDateTime = DateTime.now();

  Future<void> setup() async {
    await tz.initializeTimeZone();
    var detroit = tz.getLocation('America/Detroit');
    var now = tz.TZDateTime.now(detroit);
  }

  String getPastTimeFromMilliseconds(int timeInMilliseconds) {
    String timeDetail;
    int hours = 0;
    DateTime givenTime = DateTime.fromMillisecondsSinceEpoch(timeInMilliseconds);
    int timeDifferenceInMinutes = currentDateTime.difference(givenTime).inMinutes;
    if (timeDifferenceInMinutes >= 60) {
      hours = (timeDifferenceInMinutes / 60).round();
    }
    if (hours >= 1) {
      if (hours >= 24 && hours < 48) {
        timeDetail = "yesterday";
      } else if (hours >= 48) {
        int days = (hours / 24).round();
        timeDetail = "$days days ago";
        if (days > 3) {
          timeDetail = DateFormat('MMM dd, h:mm a').format(givenTime);
        }
      } else {
        timeDetail = "$hours hours ago";
      }
    } else {
      timeDetail = "$timeDifferenceInMinutes minutes ago";
    }
    return timeDetail;
  }
}
