import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_notification.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class PostImgBlockViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  PostDataService _postDataService = locator<PostDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  NotificationDataService _notificationDataService = locator<NotificationDataService>();

  WebblenUser get user => _reactiveWebblenUserService.user;

  bool savedPost = false;
  List savedBy = [];
  String? authorImageURL;
  String? authorUsername;

  initialize({required WebblenPost post}) async {
    setBusy(true);
    //check if user saved content
    if (post.savedBy != null) {
      if (_reactiveWebblenUserService.userLoggedIn) {
        if (post.savedBy!.contains(_reactiveWebblenUserService.user.id)) {
          savedPost = true;
        }
      }
      savedBy = post.savedBy!;
    } else {
      savedBy = [];
    }

    WebblenUser author = await _userDataService.getWebblenUserByID(post.authorID);
    if (author.isValid()) {
      authorImageURL = author.profilePicURL;
      authorUsername = author.username;
    }

    notifyListeners();
    setBusy(false);
  }

  saveUnsavePost({required WebblenPost post}) async {
    if (!_reactiveWebblenUserService.user.isValid()) {
      _customDialogService.showLoginRequiredDialog(description: "You Must Be Logged in to Save Posts");
      return;
    }
    if (savedPost) {
      savedPost = false;
      savedBy.remove(user.id);
    } else {
      savedPost = true;
      savedBy.add(user.id);
      WebblenNotification notification = WebblenNotification().generateContentSavedNotification(
        receiverUID: post.authorID!,
        senderUID: user.id!,
        username: user.username!,
        content: post,
      );
      _notificationDataService.sendNotification(notif: notification);
    }
    HapticFeedback.lightImpact();
    notifyListeners();
    await _postDataService.saveUnsavePost(userID: _reactiveWebblenUserService.user.id, postID: post.id!, savedPost: savedPost);
  }

  ///NAVIGATION
  navigateToPostView(String? id) async {
    _navigationService.navigateTo(Routes.PostViewRoute(id: id));
  }

  navigateToUserView(String? id) {
    _navigationService.navigateTo(Routes.UserProfileView(id: id));
  }
}
