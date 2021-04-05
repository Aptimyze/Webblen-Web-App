import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/algolia/algolia_search_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class UserFollowingViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  AlgoliaSearchService _algoliaSearchService = locator<AlgoliaSearchService>();
  UserDataService _userDataService = locator<UserDataService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///HELPERS
  TextEditingController searchTextController = TextEditingController();
  ScrollController scrollController = ScrollController();

  ///DATA
  List<DocumentSnapshot> userResults = [];
  DocumentSnapshot lastUserDocSnap;

  bool loadingAdditionalUsers = false;
  bool moreUsersAvailable = true;
  bool reloadingUsers = false;

  int usersResultsLimit = 20;

  //search
  List<WebblenUser> userSearchResults = [];

  initialize() async {
    //set busy status
    setBusy(true);

    //load additional data on scroll
    scrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > triggerFetchMoreSize) {
        if (userSearchResults.length > 10) {
          loadAdditionalUsers();
        }
      }
    });
    notifyListeners();

    //load profile data
    await loadData();
    setBusy(false);
  }

  ///LOAD ALL DATA
  loadData() async {
    await loadUsers();
  }

  ///REFRESH DATA
  Future<void> refreshData() async {
    //set busy status
    setBusy(true);

    //clear previous data
    userResults = [];

    //load all data
    await loadData();
    notifyListeners();

    //set busy status
    setBusy(false);
  }

  Future<void> refreshUsers() async {
    await loadUsers();
    notifyListeners();
  }

  ///USER DATA
  loadUsers() async {
    //load posts with params
    userResults = await _userDataService.loadUserFollowing(id: webblenBaseViewModel.uid, resultsLimit: usersResultsLimit);
  }

  loadAdditionalUsers() async {
    //check if already loading users or no more users available
    if (loadingAdditionalUsers || !moreUsersAvailable) {
      return;
    }

    //set loading additional users status
    loadingAdditionalUsers = true;
    notifyListeners();

    //load additional posts
    List<DocumentSnapshot> newResults = await _userDataService.loadAdditionalUserFollowing(
      lastDocSnap: userResults[userResults.length - 1],
      id: webblenBaseViewModel.uid,
      resultsLimit: usersResultsLimit,
    );

    //notify if no more users available
    if (newResults.length == 0) {
      moreUsersAvailable = false;
    } else {
      userResults.addAll(newResults);
    }

    //set loading additional users status
    loadingAdditionalUsers = false;
    notifyListeners();
  }

  ///SEARCH Query
  clearSearchResults() {
    userSearchResults = [];
    notifyListeners();
  }

  querySearchResults(String searchTerm) async {
    await Future.delayed(Duration(seconds: 1));
    if (searchTextController.text != searchTerm) {
      return;
    }
    setBusy(true);
    if (searchTerm == null || searchTerm.trim().isEmpty) {
      userSearchResults = [];
    } else {
      userSearchResults = await _algoliaSearchService.queryUsersByFollowing(
        searchTerm: searchTerm,
        uid: webblenBaseViewModel.uid,
      );
    }
    notifyListeners();
    setBusy(false);
  }

  ///NAVIGATION
  navigateToUserView(Map<String, dynamic> userData) {
    //_navigationService.navigateTo(Routes.UserProfileView, arguments: {'id': userData['id']});
  }
}