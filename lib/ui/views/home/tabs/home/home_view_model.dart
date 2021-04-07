import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  ///SERVICES
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  PostDataService _postDataService = locator<PostDataService>();
  LiveStreamDataService _liveStreamDataService = locator<LiveStreamDataService>();
  EventDataService _eventDataService = locator<EventDataService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  LocationService _locationService = locator<LocationService>();

  ///CURRENT USER
  WebblenUser user;

  ///FILTERS
  String cityName;
  String areaCode;
  String sortBy = "Latest";
  String tagFilter = "";

  ///FOR YOU DATA
  List<dynamic> forYouResults = [];
  bool loadingForYou = true;
  bool loadingAdditionalForYou = false;
  bool moreForYouAvailable = true;

  ///POST DATA
  List<DocumentSnapshot> postResults = [];
  DocumentSnapshot lastPostDocSnap;

  bool loadingPosts = true;
  bool loadingAdditionalPosts = false;
  bool morePostsAvailable = true;

  ///EVENT DATA
  List<DocumentSnapshot> eventResults = [];
  DocumentSnapshot lastEventDocSnap;

  bool loadingEvents = true;
  bool loadingAdditionalEvents = false;
  bool moreEventsAvailable = true;

  ///STREAM DATA
  List<DocumentSnapshot> streamResults = [];
  DocumentSnapshot lastStreamDocSnap;

  bool loadingStreams = false;
  bool loadingAdditionalStreams = false;
  bool moreStreamsAvailable = true;

  int resultsLimit = 30;

  ///INITIALIZE

  initialize() async {
    //get location data
    cityName = webblenBaseViewModel.cityName == null ? null : webblenBaseViewModel.cityName;

    areaCode = webblenBaseViewModel.areaCode == null
        ? webblenBaseViewModel.isAnonymous
            ? null
            : webblenBaseViewModel.user.lastSeenZipcode == null || webblenBaseViewModel.user.lastSeenZipcode.isEmpty
                ? "58104"
                : webblenBaseViewModel.user.lastSeenZipcode
        : webblenBaseViewModel.areaCode;

    if (cityName == null && areaCode != null) {
      cityName = await _locationService.getCityFromZip(areaCode);
    }

    notifyListeners();
    setBusy(false);
  }

  ///BOTTOM SHEETS
  //bottom sheet for new post, stream, or event
  showAddContentOptions() async {
    webblenBaseViewModel.showAddContentOptions();
  }

  //show content options
  showContentOptions({@required dynamic content}) async {
    var actionPerformed = await webblenBaseViewModel.showContentOptions(content: content);
    if (actionPerformed == "deleted content") {
      if (content is WebblenPost) {
        //deleted post
        postResults.removeWhere((doc) => doc.id == content.id);
        notifyListeners();
      } else if (content is WebblenEvent) {
        //deleted event
        eventResults.removeWhere((doc) => doc.id == content.id);
        notifyListeners();
      } else if (content is WebblenLiveStream) {
        //deleted stream
        streamResults.removeWhere((doc) => doc.id == content.id);
        notifyListeners();
      }
    }
  }
}
