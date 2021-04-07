import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/search_result.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class CustomTopNavBarModel extends BaseViewModel {
  AlgoliaSearchService _algoliaSearchService = locator<AlgoliaSearchService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///HELPERS
  TextEditingController searchTextController = TextEditingController();

  ///AUTH STATUS
  bool isLoggedIn;

  ///SEARCH DATA
  List<SearchResult> streamResults = [];
  List<SearchResult> eventResults = [];
  List<SearchResult> userResults = [];

  int streamResultsLimit = 5;
  int eventResultsLimit = 5;
  int userResultsLimit = 5;

  initialize() async {
    setBusy(true);
    isLoggedIn = webblenBaseViewModel.user == null ? false : true;
    notifyListeners();
    setBusy(false);
  }

  querySearchResults(String searchTerm) async {
    await Future.delayed(Duration(seconds: 1));
    if (searchTextController.text != searchTerm) {
      return;
    }
    setBusy(true);
    if (searchTerm == null || searchTerm.trim().isEmpty) {
      streamResults = [];
      eventResults = [];
      userResults = [];
    } else {
      streamResults = await _algoliaSearchService.searchStreams(searchTerm: searchTerm, resultsLimit: streamResultsLimit);
      eventResults = await _algoliaSearchService.searchEvents(searchTerm: searchTerm, resultsLimit: eventResultsLimit);
      userResults = await _algoliaSearchService.searchUsers(searchTerm: searchTerm, resultsLimit: userResultsLimit);
    }
    notifyListeners();
    setBusy(false);
  }
}
