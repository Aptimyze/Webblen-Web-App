import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/copy_shareable_link.dart';

class AddContentSuccessfulBottomSheetModel extends BaseViewModel {
  SnackbarService _snackbarService = locator<SnackbarService>();
  UserDataService _userDataService = locator<UserDataService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ShareService _shareService = locator<ShareService>();
  WebblenBaseViewModel _webblenBaseViewModel = locator<WebblenBaseViewModel>();

  shareContentLink(dynamic content) async {
    String url;
    String contentType;
    if (content is WebblenPost) {
      url = await _dynamicLinkService.createPostLink(authorUsername: "@${_webblenBaseViewModel.user.username}", post: content);
      contentType = "post";
    } else if (content is WebblenEvent) {
      url = await _dynamicLinkService.createEventLink(authorUsername: "@${_webblenBaseViewModel.user.username}", event: content);
      contentType = "event";
    } else if (content is WebblenLiveStream) {
      url = await _dynamicLinkService.createLiveStreamLink(authorUsername: "@${_webblenBaseViewModel.user.username}", stream: content);
      contentType = "stream";
    }
    _shareService.copyContentLink(contentType: contentType, url: url);
  }

  copyContentLink(dynamic content) async {
    String url;
    if (content is WebblenPost) {
      url = await _dynamicLinkService.createPostLink(authorUsername: "@${_webblenBaseViewModel.user.username}", post: content);
    } else if (content is WebblenEvent) {
      url = await _dynamicLinkService.createEventLink(authorUsername: "@${_webblenBaseViewModel.user.username}", event: content);
    } else if (content is WebblenLiveStream) {
      url = await _dynamicLinkService.createLiveStreamLink(authorUsername: "@${_webblenBaseViewModel.user.username}", stream: content);
    }
    copyShareableLink(link: url);
  }
}
