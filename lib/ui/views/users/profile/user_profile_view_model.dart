import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/enums/bottom_sheet_type.dart';
import 'package:webblen_web_app/models/webblen_notification.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class UserProfileViewModel extends StreamViewModel<WebblenUser> {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  PostDataService _postDataService = locator<PostDataService>();
  ShareService _shareService = locator<ShareService>();
  NotificationDataService _notificationDataService = locator<NotificationDataService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///UI HELPERS
  ScrollController scrollController = ScrollController();

  ///DATA
  List<DocumentSnapshot> postResults = [];
  DocumentSnapshot lastPostDocSnap;

  bool loadingAdditionalPosts = false;
  bool morePostsAvailable = true;
  bool reloadingPosts = false;

  int resultsLimit = 20;

  ///USER DATA
  String uid;
  WebblenUser currentUser;
  WebblenUser user;
  bool isFollowingUser;
  bool sendNotification = false;

  ///STREAM USER DATA
  @override
  void onData(WebblenUser data) {
    if (data != null) {
      user = data;
      if (isFollowingUser == null) {
        if (webblenBaseViewModel.user != null) {
          if (user.followers.contains(currentUser.id)) {
            isFollowingUser = true;
          } else {
            isFollowingUser = false;
          }
        }
      }
      notifyListeners();
      setBusy(false);
      //loadData();
    }
  }

  @override
  Stream<WebblenUser> get stream => streamUser();

  Stream<WebblenUser> streamUser() async* {
    while (true) {
      if (uid == null) {
        yield null;
      }
      await Future.delayed(Duration(seconds: 1));
      var res = await _userDataService.getWebblenUserByID(uid);
      if (res is String) {
        yield null;
      } else {
        yield res;
      }
    }
  }

  ///INITIALIZE
  initialize({BuildContext context, TabController tabController}) async {
    //set busy status
    setBusy(true);

    //get user
    var routeData = RouteData.of(context);
    // .value will return the raw string value
    uid = routeData.pathParams['id'].value;
    notifyListeners();

    //load additional data on scroll
    scrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > triggerFetchMoreSize) {
        if (tabController.index == 0) {
          // loadAdditionalPosts();
        }
      }
    });
    notifyListeners();

    //setBusy(false);
    //load profile data
  }

  loadData() async {
    await loadPosts();
    notifyListeners();
    setBusy(false);
  }

  Future<void> refreshPosts() async {
    await loadPosts();
    notifyListeners();
  }

  ///Load Data
  loadPosts() async {
    //load posts with params
    postResults = await _postDataService.loadPostsByUserID(id: user.id, resultsLimit: resultsLimit);
  }

  loadAdditionalPosts() async {
    //check if already loading posts or no more posts available
    if (loadingAdditionalPosts || !morePostsAvailable) {
      return;
    }

    //set loading additional posts status
    loadingAdditionalPosts = true;
    notifyListeners();

    //load additional posts
    List<DocumentSnapshot> newResults = await _postDataService.loadAdditionalPostsByUserID(
      lastDocSnap: postResults[postResults.length - 1],
      id: user.id,
      resultsLimit: resultsLimit,
    );

    //notify if no more posts available
    if (newResults.length == 0) {
      morePostsAvailable = false;
    } else {
      postResults.addAll(newResults);
    }

    //set loading additional posts status
    loadingAdditionalPosts = false;
    notifyListeners();
  }

  ///FOLLOW UNFOLLOW USER
  followUnfollowUser() async {
    if (isFollowingUser) {
      isFollowingUser = false;
      notifyListeners();
      bool followedUser = await _userDataService.unFollowUser(currentUser.id, user.id);
      if (followedUser) {
        WebblenNotification notification = WebblenNotification().generateNewFollowerNotification(
          receiverUID: user.id,
          senderUID: currentUser.id,
          followerUsername: "@${currentUser.username}",
        );
        _notificationDataService.sendNotification(notif: notification);
        followedUser = true;
        notifyListeners();
      }
    } else {
      isFollowingUser = true;
      notifyListeners();
      _userDataService.followUser(currentUser.id, user.id);
    }
  }

  ///BOTTOM SHEETS
  showUserOptions() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.userOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "share profile") {
        //share profile
        String url = await _dynamicLinkService.createProfileLink(user: user);
        _shareService.copyContentLink(contentType: "profile", url: url);
      } else if (res == "message") {
        //message user
      } else if (res == "block") {
        //block user
      } else if (res == "report") {
        //report user
      }
      notifyListeners();
    }
  }

  ///NAVIGATION
  navigateToCreatePostPage({dynamic args}) {
    if (args == null) {
      //_navigationService.navigateTo(Routes.CreatePostViewRoute, arguments: args);
    } else {
      //_navigationService.navigateTo(Routes.CreatePostViewRoute);
    }
  }

  navigateToEditProfileView() {
    //_navigationService.navigateTo(Routes.EditProfileViewRoute, arguments: {'id': user.id});
  }

  navigateToSettingsView() {
    //_navigationService.navigateTo(Routes.SettingsViewRoute);
  }
}
