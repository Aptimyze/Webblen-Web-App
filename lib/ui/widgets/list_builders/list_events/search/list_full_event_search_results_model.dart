import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_event_ticket.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/services/reactive/content_filter/reactive_content_filter_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';

class ListFullEventSearchResultsModel extends BaseViewModel {
  AlgoliaSearchService _algoliaSearchService = locator<AlgoliaSearchService>();
  WebblenBaseViewModel? webblenBaseViewModel = locator<WebblenBaseViewModel>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();
  String listKey = "initial-search-events-key";
  String id = "";

  String? searchTerm;
  List<WebblenEvent> dataResults = [];
  bool loadingAdditionalData = false;
  bool moreDataAvailable = true;
  int resultsPageNum = 1;
  int resultsLimit = 20;

  initialize(String? term) async {
    searchTerm = term;
    notifyListeners();
    await loadData();
    setBusy(false);
  }

  Future<void> refreshData() async {
    scrollController.jumpTo(scrollController.position.minScrollExtent);

    //clear previous data
    dataResults = [];
    loadingAdditionalData = false;
    moreDataAvailable = true;

    notifyListeners();
    //load all data
    await loadData();
  }

  loadData() async {
    dataResults = await _algoliaSearchService.queryEvents(searchTerm: searchTerm, resultsLimit: resultsLimit);
    resultsPageNum += 1;
    notifyListeners();
  }

  loadAdditionalData() async {
    if (loadingAdditionalData || !moreDataAvailable) {
      return;
    }
    loadingAdditionalData = true;
    notifyListeners();
    List<WebblenEvent> newResults = await _algoliaSearchService.queryAdditionalEvents(
      searchTerm: searchTerm,
      resultsLimit: resultsLimit,
      pageNum: resultsPageNum,
    );
    if (newResults.length == 0) {
      moreDataAvailable = false;
    } else {
      dataResults.addAll(newResults);
    }
    loadingAdditionalData = false;
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
