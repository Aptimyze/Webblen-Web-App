import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/firestore/data/event_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/services/reactive/content_filter/reactive_content_filter_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';

class ListDiscoverContentModel extends ReactiveViewModel {
  PostDataService _postDataService = locator<PostDataService>();
  LiveStreamDataService _liveStreamDataService = locator<LiveStreamDataService>();
  EventDataService _eventDataService = locator<EventDataService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  ReactiveContentFilterService _reactiveContentFilterService = locator<ReactiveContentFilterService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();
  String listKey = "initial-home-content-key";

  ///FILTER DATA
  String listAreaCode = "";
  String listTagFilter = "";
  String listSortByFilter = "Latest";

  String get cityName => _reactiveContentFilterService.cityName;
  String get areaCode => _reactiveContentFilterService.areaCode;
  String get tagFilter => _reactiveContentFilterService.tagFilter;
  String get sortByFilter => _reactiveContentFilterService.sortByFilter;

  ///DATA
  List<DocumentSnapshot> dataResults = [];

  bool loadingAdditionalPosts = false;
  bool morePostsAvailable = true;

  bool loadingAdditionalStreams = false;
  bool moreStreamsAvailable = true;

  bool loadingAdditionalEvents = false;
  bool moreEventsAvailable = true;

  bool loadingAdditionalData = false;
  bool moreDataAvailable = true;

  int resultsLimit = 10;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveContentFilterService];

  initialize() async {
    setBusy(true);
    // get content filter
    syncContentFilter();

    _reactiveContentFilterService.addListener(() {
      if (areaCode != listAreaCode || listTagFilter != tagFilter || listSortByFilter != sortByFilter) {
        syncContentFilter();
        refreshData();
      }
    });

    await loadData();
  }

  syncContentFilter() {
    listAreaCode = areaCode;
    listTagFilter = listTagFilter;
    listSortByFilter = sortByFilter;
    notifyListeners();
  }

  Future<void> refreshData() async {
    //clear previous data
    dataResults = [];
    loadingAdditionalPosts = false;
    morePostsAvailable = true;

    loadingAdditionalStreams = false;
    moreStreamsAvailable = true;

    loadingAdditionalEvents = false;
    moreEventsAvailable = true;

    loadingAdditionalData = false;
    moreDataAvailable = true;

    notifyListeners();
    //load all data
    await loadData();
  }

  loadData() async {
    setBusy(true);

    dataResults = [];
    List<DocumentSnapshot> postResults = [];
    List<DocumentSnapshot> streamResults = [];
    List<DocumentSnapshot> eventResults = [];

    //load data with params
    await _postDataService
        .loadPosts(
      areaCode: areaCode,
      resultsLimit: resultsLimit,
      sortBy: sortByFilter,
      tagFilter: tagFilter,
    )
        .then((val) {
      postResults.addAll(val);
    });

    await _liveStreamDataService
        .loadStreams(
      areaCode: areaCode,
      resultsLimit: resultsLimit,
      sortBy: sortByFilter,
      tagFilter: tagFilter,
    )
        .then((val) {
      streamResults.addAll(val);
    });

    await _eventDataService
        .loadEvents(
      areaCode: areaCode,
      resultsLimit: resultsLimit,
      sortBy: sortByFilter,
      tagFilter: tagFilter,
    )
        .then((val) {
      eventResults.addAll(val);
    });

    sortDataResults(postResults: postResults, streamResults: streamResults, eventResults: eventResults);

    loadingAdditionalData = false;

    notifyListeners();
    setBusy(false);
  }

  loadAdditionalData() async {
    loadingAdditionalData = true;
    notifyListeners();

    List<DocumentSnapshot> postResults = [];
    List<DocumentSnapshot> streamResults = [];
    List<DocumentSnapshot> eventResults = [];
    if (!loadingAdditionalPosts && morePostsAvailable) {
      postResults = await loadAdditionalPosts();
    }
    if (!loadingAdditionalStreams && moreStreamsAvailable) {
      streamResults = await loadAdditionalStreams();
    }
    if (!loadingAdditionalEvents && moreEventsAvailable) {
      eventResults = await loadAdditionalEvents();
    }

    sortDataResults(postResults: postResults, streamResults: streamResults, eventResults: eventResults);

    loadingAdditionalData = false;
    notifyListeners();
  }

  Future<List<DocumentSnapshot>> loadAdditionalPosts() async {
    List<DocumentSnapshot> results = [];

    //set loading additional data status
    loadingAdditionalPosts = true;
    notifyListeners();

    //load additional posts
    try {
      DocumentSnapshot lastDoc = dataResults.lastWhere((doc) => doc.data()!['postDateTimeInMilliseconds'] != null);

      results = await _postDataService.loadAdditionalPosts(
        lastDocSnap: lastDoc,
        areaCode: areaCode,
        resultsLimit: resultsLimit,
        sortBy: sortByFilter,
        tagFilter: tagFilter,
      );
    } catch (e) {
      //print(e);
    }

    //notify if no more data available
    if (results.length == 0 || results.length < 10) {
      morePostsAvailable = false;
    }

    //set loading additional data status
    loadingAdditionalPosts = false;
    notifyListeners();

    return results;
  }

  Future<List<DocumentSnapshot>> loadAdditionalStreams() async {
    List<DocumentSnapshot> results = [];

    //set loading additional data status
    loadingAdditionalStreams = true;
    notifyListeners();

    //load additional data
    try {
      DocumentSnapshot lastDoc = dataResults.lastWhere((doc) => doc.data()!['hostID'] != null);
      results = await _liveStreamDataService.loadAdditionalStreams(
        lastDocSnap: lastDoc,
        areaCode: areaCode,
        resultsLimit: resultsLimit,
        tagFilter: tagFilter,
        sortBy: sortByFilter,
      );
    } catch (e) {
      //print(e);
    }

    //notify if no more data available
    if (results.length == 0 || results.length < 10) {
      moreStreamsAvailable = false;
    }

    //set loading additional posts status
    loadingAdditionalStreams = false;
    notifyListeners();

    return results;
  }

  Future<List<DocumentSnapshot>> loadAdditionalEvents() async {
    List<DocumentSnapshot> results = [];

    //set loading additional data status
    loadingAdditionalEvents = true;
    notifyListeners();

    //load additional data
    try {
      DocumentSnapshot lastDoc = dataResults.lastWhere((doc) => doc.data()!['venueName'] != null);
      results = await _eventDataService.loadAdditionalEvents(
        lastDocSnap: lastDoc,
        areaCode: areaCode,
        resultsLimit: resultsLimit,
        sortBy: sortByFilter,
        tagFilter: tagFilter,
      );
    } catch (e) {
      //print(e);
    }

    //notify if no more data available
    if (results.length == 0 || results.length < 10) {
      moreEventsAvailable = false;
    }

    //set loading additional posts status
    loadingAdditionalEvents = false;
    notifyListeners();

    return results;
  }

  sortDataResults({required List<DocumentSnapshot> postResults, required List<DocumentSnapshot> streamResults, required List<DocumentSnapshot> eventResults}) {
    int contentCount = postResults.length + streamResults.length + eventResults.length;

    for (int i = contentCount; i >= 1; i--) {
      DocumentSnapshot? doc;
      if (i % 3 == 0) {
        doc = streamResults.length > 0 ? streamResults.removeAt(0) : null;
      } else if (i % 7 == 0) {
        doc = eventResults.length > 0 ? eventResults.removeAt(0) : null;
      } else if (postResults.length > 0) {
        doc = postResults.removeAt(0);
      } else {
        //load from streams and events if no more posts
        if (streamResults.length > 0 && eventResults.length > 0) {
          if (streamResults[0].data()!['startDateTimeInMilliseconds'] < eventResults[0].data()!['startDateTimeInMilliseconds']) {
            doc = streamResults.removeAt(0);
          } else {
            doc = eventResults.removeAt(0);
          }
        } else if (streamResults.length > 0) {
          doc = streamResults.removeAt(0);
        } else if (eventResults.length > 0) {
          doc = eventResults.removeAt(0);
        }
      }
      if (doc != null) {
        dataResults.add(doc);
      }
    }

    notifyListeners();
  }

  showContentOptions(dynamic content) async {
    String val = await customBottomSheetService.showContentOptions(content: content);
    if (val == "deleted content") {
      dataResults.removeWhere((doc) => doc.id == content.id);
      listKey = getRandomString(5);
      notifyListeners();
    }
  }
}
