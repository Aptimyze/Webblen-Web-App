import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class OpenAppBlockViewModel extends BaseViewModel {
  UserDataService _userDataService = locator<UserDataService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  ///LINK
  String? appLink;

  ///NOTICE DISMISSAL
  bool dismissedNotice = false;

  initialize(dynamic content) async {
    setBusy(true);
    if (content is WebblenEvent) {
      WebblenUser author = await _userDataService.getWebblenUserByID(content.authorID);
      if (author.isValid()) {
        appLink = await _dynamicLinkService.createEventAppLink(authorUsername: author.username, event: content);
      }
    } else if (content is WebblenPost) {
      WebblenUser author = await _userDataService.getWebblenUserByID(content.authorID);
      if (author.isValid()) {
        appLink = await _dynamicLinkService.createPostAppLink(authorUsername: author.username, post: content);
      }
    } else if (content is WebblenLiveStream) {
      WebblenUser author = await _userDataService.getWebblenUserByID(content.hostID);
      if (author.isValid()) {
        appLink = await _dynamicLinkService.createLiveStreamAppLink(authorUsername: author.username, stream: content);
      }
    } else if (content is WebblenUser) {
      appLink = await _dynamicLinkService.createProfileAppLink(user: content);
    }
    notifyListeners();
    setBusy(false);
  }

  openApp() {
    UrlHandler().launchInWebViewOrVC(appLink!);
  }

  dismissNotice() {
    dismissedNotice = true;
    notifyListeners();
  }
}
