import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/enums/bottom_sheet_type.dart';
import 'package:webblen_web_app/models/webblen_notification.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/dynamic_links/dynamic_link_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/services/share/share_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class UserProfileViewModel extends StreamViewModel<WebblenUser> {
  UserDataService _userDataService = locator<UserDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ShareService _shareService = locator<ShareService>();
  NotificationDataService _notificationDataService = locator<NotificationDataService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();

  ///DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get currentUser => _reactiveWebblenUserService.user;

  ///UI HELPERS
  ScrollController scrollController = ScrollController();

  ///USER DATA
  String? uid;
  WebblenUser? user;
  bool? isFollowingUser;
  bool sendNotification = false;

  ///STREAM USER DATA
  @override
  void onData(WebblenUser? data) {
    if (data != null) {
      user = data;
      if (isFollowingUser == null) {
        if (user!.followers!.contains(currentUser.id)) {
          isFollowingUser = true;
        } else {
          isFollowingUser = false;
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
      if (uid != null) {
        await Future.delayed(Duration(seconds: 1));
        var res = await _userDataService.getWebblenUserByID(uid);
        if (res is String) {
        } else {
          yield res;
        }
      }
    }
  }

  ///INITIALIZE
  initialize({String? id, TabController? tabController}) async {
    setBusy(true);
    uid = id;
    notifyListeners();
  }

  ///FOLLOW UNFOLLOW USER
  followUnfollowUser() async {
    if (user!.id == currentUser.id) {
      _customDialogService.showErrorDialog(description: "You cannot follow yourself");
    } else if (isFollowingUser!) {
      isFollowingUser = false;
      notifyListeners();
      await _userDataService.unFollowUser(currentUser.id!, user!.id!);
    } else {
      isFollowingUser = true;
      notifyListeners();
      bool followedUser = await _userDataService.followUser(currentUser.id!, user!.id!);
      if (followedUser) {
        WebblenNotification notification = WebblenNotification().generateNewFollowerNotification(
          receiverUID: user!.id,
          senderUID: currentUser.id,
          followerUsername: "@${currentUser.username}",
        );
        _notificationDataService.sendNotification(notif: notification);
        notifyListeners();
      }
    }
  }

  viewWebsite() {
    UrlHandler().launchInWebViewOrVC(user!.website!);
  }

  ///BOTTOM SHEETS
  showUserOptions() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.userOptions,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "share profile") {
        //share profile
        String? url = await _dynamicLinkService.createProfileLink(user: user!);
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

}
