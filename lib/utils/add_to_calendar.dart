import 'package:flutter/cupertino.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';

UserDataService _userDataService = locator<UserDataService>();
DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

addEventToCalendar({@required WebblenEvent webblenEvent}) async {
  // WebblenUser author = await _userDataService.getWebblenUserByID(webblenEvent.authorID);
  // String url = await _dynamicLinkService.createEventLink(authorUsername: author.username, event: webblenEvent);
  // Event calendarEvent = Event(
  //   title: "Webblen Event: " + webblenEvent.title,
  //   description: "View details for this event here: " + url,
  //   startDate: DateTime.fromMillisecondsSinceEpoch(webblenEvent.startDateTimeInMilliseconds),
  //   endDate: DateTime.fromMillisecondsSinceEpoch(webblenEvent.endDateTimeInMilliseconds),
  // );
  // Add2Calendar.addEvent2Cal(calendarEvent);
}

addStreamToCalendar({@required WebblenLiveStream webblenStream}) async {
  // WebblenUser author = await _userDataService.getWebblenUserByID(webblenStream.hostID);
  // String url = await _dynamicLinkService.createLiveStreamLink(authorUsername: author.username, stream: webblenStream);
  // Event calendarEvent = Event(
  //   title: "Webblen Stream: " + webblenStream.title,
  //   description: "View details for this stream here: " + url,
  //   startDate: DateTime.fromMillisecondsSinceEpoch(webblenStream.startDateTimeInMilliseconds),
  //   endDate: DateTime.fromMillisecondsSinceEpoch(webblenStream.endDateTimeInMilliseconds),
  // );
  // Add2Calendar.addEvent2Cal(calendarEvent);
}
