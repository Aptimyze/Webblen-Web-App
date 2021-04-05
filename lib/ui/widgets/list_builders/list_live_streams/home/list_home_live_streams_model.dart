import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/services/firestore/data/live_stream_data_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

@lazySingleton
class ListHomeLiveStreamsModel extends BaseViewModel {
  LiveStreamDataService _liveStreamDataService = locator<LiveStreamDataService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///HELPERS
  ScrollController scrollController = ScrollController();

  ///FILTER DATA
  String cityName;
  String areaCode;
  String contentTagFilter;
  String contentSortBy;

  ///DATA
  List<DocumentSnapshot> dataResults = [];

  bool loadingAdditionalData = false;
  bool moreDataAvailable = true;

  int resultsLimit = 10;

  initialize() async {
    // load additional data on scroll
    scrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalData();
      }
    });

    // get content filter
    cityName = webblenBaseViewModel.cityName;
    areaCode = webblenBaseViewModel.areaCode;
    contentTagFilter = webblenBaseViewModel.contentTagFilter;
    contentSortBy = webblenBaseViewModel.contentSortBy;

    // listener for changed filter
    webblenBaseViewModel.addListener(() {
      bool filterChanged = false;
      if (cityName != webblenBaseViewModel.cityName) {
        filterChanged = true;
        cityName = webblenBaseViewModel.cityName;
      }
      if (areaCode != webblenBaseViewModel.areaCode) {
        filterChanged = true;
        areaCode = webblenBaseViewModel.areaCode;
      }
      if (contentTagFilter != webblenBaseViewModel.contentTagFilter) {
        filterChanged = true;
        contentTagFilter = webblenBaseViewModel.contentTagFilter;
      }
      if (contentSortBy != webblenBaseViewModel.contentSortBy) {
        filterChanged = true;
        contentSortBy = webblenBaseViewModel.contentSortBy;
      }
      if (filterChanged) {
        refreshData();
      }
    });

    await loadData();
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
    setBusy(true);

    //load data with params
    dataResults = await _liveStreamDataService.loadStreams(
      areaCode: webblenBaseViewModel.areaCode,
      resultsLimit: resultsLimit,
      tagFilter: webblenBaseViewModel.contentTagFilter,
      sortBy: webblenBaseViewModel.contentSortBy,
    );

    notifyListeners();

    setBusy(false);
  }

  loadAdditionalData() async {
    //check if already loading data or no more data available
    if (loadingAdditionalData || !moreDataAvailable) {
      return;
    }

    //set loading additional data status
    loadingAdditionalData = true;
    notifyListeners();

    //load additional posts
    List<DocumentSnapshot> newResults = await _liveStreamDataService.loadAdditionalStreams(
      lastDocSnap: dataResults[dataResults.length - 1],
      areaCode: webblenBaseViewModel.areaCode,
      resultsLimit: resultsLimit,
      tagFilter: webblenBaseViewModel.contentTagFilter,
      sortBy: webblenBaseViewModel.contentSortBy,
    );

    //notify if no more posts available
    if (newResults.length == 0) {
      moreDataAvailable = false;
    } else {
      dataResults.addAll(newResults);
    }

    //set loading additional posts status
    loadingAdditionalData = false;
    notifyListeners();
  }
}
