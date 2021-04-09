import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/enums/bottom_sheet_type.dart';
import 'package:webblen_web_app/models/webblen_notification.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/models/webblen_post_comment.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/data/comment_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/notification_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';

class PostViewModel extends ReactiveViewModel {
  NavigationService? _navigationService = locator<NavigationService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  UserDataService? _userDataService = locator<UserDataService>();
  PostDataService? _postDataService = locator<PostDataService>();
  CommentDataService? _commentDataService = locator<CommentDataService>();
  NotificationDataService? _notificationDataService = locator<NotificationDataService>();
  CustomDialogService customDialogService = locator<CustomDialogService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///USER DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  ///HELPERS
  FocusNode focusNode = FocusNode();
  ScrollController postScrollController = ScrollController();
  TextEditingController commentTextController = TextEditingController();
  double postScrollPosition = 0.0;
  PageStorageKey commentStorageKey = PageStorageKey('initial');

  ///DATA RESULTS
  bool loadingAdditionalComments = false;
  bool moreCommentsAvailable = true;
  List<DocumentSnapshot> commentResults = [];
  int resultsLimit = 10;

  ///DATA
  WebblenUser? author;
  WebblenPost? post;
  bool isAuthor = false;
  bool isReplying = false;
  bool refreshingComments = true;
  WebblenPostComment? commentToReplyTo;

  ///INITIALIZE
  initialize(String? postID) async {
    setBusy(true);
    // .value will return the raw string value
    String? id = postID;
    var res = await _postDataService!.getPostByID(id);
    if (res is WebblenPost) {
      post = res;
    } else {
      return;
    }

    author = await _userDataService!.getWebblenUserByID(post!.authorID);

    if (webblenBaseViewModel!.uid == post!.authorID) {
      isAuthor = true;
    }

    ///SET SCROLL CONTROLLER
    postScrollController.addListener(() {
      double triggerFetchMoreSize = 0.7 * postScrollController.position.maxScrollExtent;
      if (postScrollController.position.pixels > triggerFetchMoreSize) {
        if (commentResults.isNotEmpty) {
          loadAdditionalComments();
        }
      }
    });
    await loadComments();
    notifyListeners();
    setBusy(false);
  }

  ///LOAD COMMENTS
  Future<void> refreshComments() async {
    await loadComments();
    resetPageStorageKey();
  }

  loadComments() async {
    commentResults = await _commentDataService!.loadComments(postID: post!.id, resultsLimit: resultsLimit);
    refreshingComments = false;
    notifyListeners();
  }

  loadAdditionalComments() async {
    if (loadingAdditionalComments || !moreCommentsAvailable) {
      return;
    }
    loadingAdditionalComments = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _commentDataService!.loadAdditionalComments(
      lastDocSnap: commentResults[commentResults.length - 1],
      resultsLimit: resultsLimit,
      postID: post!.id,
    );
    if (newResults.length == 0) {
      moreCommentsAvailable = false;
    } else {
      commentResults.addAll(newResults);
    }
    loadingAdditionalComments = false;
    notifyListeners();
  }

  ///COMMENTING
  toggleReply(FocusNode focusNode, WebblenPostComment comment) {
    isReplying = true;
    commentToReplyTo = comment;
    focusNode.requestFocus();
  }

  submitComment({BuildContext? context, required Map<String, dynamic> commentData}) async {
    isReplying = false;
    String text = commentData['comment'].trim();
    if (text.isNotEmpty) {
      WebblenPostComment comment = WebblenPostComment(
        postID: post!.id,
        senderUID: user.id,
        username: user.username,
        message: text,
        isReply: false,
        replies: [],
        replyCount: 0,
        timePostedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
      );

      //send comment & notification
      await _commentDataService!.sendComment(post!.id, post!.authorID, comment);
      if (webblenBaseViewModel!.uid != post!.authorID) {
        sendCommentNotification(text);
      }

      //send notification to mentioned users
      if (commentData['mentionedUsers'].isNotEmpty) {
        List<WebblenUser> users = commentData['mentionedUsers'];
        users.forEach((user) {
          sendCommentMentionNotification(user.id, text);
        });
      }

      clearState(context);
    }
    refreshComments();
  }

  replyToComment({BuildContext? context, required Map<String, dynamic> commentData}) async {
    String text = commentData['comment'].trim();
    if (text.isNotEmpty) {
      WebblenPostComment comment = WebblenPostComment(
        postID: post!.id,
        senderUID: user.id,
        username: user.id,
        message: text,
        isReply: true,
        replies: [],
        replyCount: 0,
        replyReceiverUsername: commentToReplyTo!.username,
        originalReplyCommentID: commentToReplyTo!.timePostedInMilliseconds.toString(),
        timePostedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
      );
      await _commentDataService!.replyToComment(
        post!.id,
        commentToReplyTo!.senderUID,
        commentToReplyTo!.timePostedInMilliseconds.toString(),
        comment,
      );
    }

    sendCommentReplyNotification(commentToReplyTo!.senderUID, text);

    //send notification to mentioned users
    if (commentData['mentionedUsers'].isNotEmpty) {
      List<WebblenUser> users = commentData['mentionedUsers'];
      users.forEach((user) {
        sendCommentMentionNotification(user.id, text);
      });
    }

    clearState(context);
    refreshComments();
  }

  deleteComment({BuildContext? context, required WebblenPostComment comment}) async {
    isReplying = false;
    if (comment.isReply!) {
      await CommentDataService().deleteReply(post!.id, comment);
    } else {
      await CommentDataService().deleteComment(post!.id, comment);
    }
    clearState(context);
    if (comment.isReply!) {
      commentResults = [];
    }
    refreshComments();
  }

  unFocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (isReplying) {
      clearState(context);
    }
  }

  clearState(BuildContext? context) {
    isReplying = false;
    commentToReplyTo = null;
    commentTextController.clear();
    notifyListeners();
  }

  resetPageStorageKey() {
    String val = getRandomString(10);
    commentStorageKey = PageStorageKey(val);
    notifyListeners();
  }

  ///NOTIFICATIONS
  sendCommentNotification(String comment) {
    WebblenNotification notification = WebblenNotification().generatePostCommentNotification(
      postID: post!.id,
      receiverUID: post!.authorID,
      senderUID: webblenBaseViewModel!.uid,
      commenterUsername: "@${webblenBaseViewModel!.user!.username}",
      comment: comment,
    );
    _notificationDataService!.sendNotification(notif: notification);
  }

  sendCommentReplyNotification(String? receiverUID, String comment) {
    WebblenNotification notification = WebblenNotification().generatePostCommentNotification(
      postID: post!.id,
      receiverUID: receiverUID,
      senderUID: webblenBaseViewModel!.uid,
      commenterUsername: "@${webblenBaseViewModel!.user!.username}",
      comment: comment,
    );
    _notificationDataService!.sendNotification(notif: notification);
  }

  sendCommentMentionNotification(String? receiverUID, String comment) {
    WebblenNotification notification = WebblenNotification().generateWebblenCommentMentionNotification(
      postID: post!.id,
      receiverUID: receiverUID,
      senderUID: webblenBaseViewModel!.uid,
      commenterUsername: "@${webblenBaseViewModel!.user!.username}",
      comment: comment,
    );
    _notificationDataService!.sendNotification(notif: notification);
  }

  showDeleteCommentConfirmation({BuildContext? context, WebblenPostComment? comment}) async {
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
      title: "Delete Comment",
      description: "Are You Sure You Want to Delete this Comment?",
      mainButtonTitle: "Delete",
      secondaryButtonTitle: "Cancel",
      barrierDismissible: true,
      variant: BottomSheetType.destructiveConfirmation,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "confirmed") {
        deleteComment(context: context, comment: comment!);
      }
    }
  }

  ///NAVIGATION
  navigateToUserView(String? id) {
    //_navigationService.navigateTo(Routes.UserProfileView, arguments: {'id': id});
  }

  @override
  // TODO: implement reactiveServices
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];
}
