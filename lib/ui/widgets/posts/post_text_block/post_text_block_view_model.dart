import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/app/router.gr.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class PostTextBlockViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  PostDataService _postDataService = locator<PostDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  WebblenBaseViewModel _webblenBaseViewModel = locator<WebblenBaseViewModel>();
  DialogService _dialogService = locator<DialogService>();

  bool savedPost = false;
  String authorImageURL;
  String authorUsername;

  initialize({@required WebblenPost post}) async {
    setBusy(true);

    savedPost = await _postDataService.checkIfPostSaved(userID: _webblenBaseViewModel.uid, postID: post.id);
    //Get Post Author Data
    _userDataService.getWebblenUserByID(post.authorID).then((res) {
      if (res is String) {
        //print(String);
      } else {
        authorImageURL = res.profilePicURL;
        authorUsername = res.username;
      }
      notifyListeners();
      setBusy(false);
    });
  }

  saveUnsavePost({String postID}) async {
    if (_webblenBaseViewModel.user == null) {
      DialogResponse response = await _dialogService.showDialog(
        title: "Cannot Save Post",
        description: "You Must Be Logged in to Save Posts",
        barrierDismissible: true,
        cancelTitle: "Cancel",
        buttonTitle: "Log In",
      );
      if (response.confirmed) {
        _webblenBaseViewModel.navigateToAuthView();
      }
    } else {
      if (savedPost) {
        savedPost = false;
      } else {
        savedPost = true;
      }
      HapticFeedback.lightImpact();
      notifyListeners();
      await _postDataService.saveUnsavePost(userID: _webblenBaseViewModel.uid, postID: postID, savedPost: savedPost);
    }
  }

  ///NAVIGATION
  navigateToPostView(String id) async {
    _navigationService.navigateTo(Routes.PostViewRoute(id: id));
  }

  navigateToUserView(String id) {
    _navigationService.navigateTo(Routes.UserProfileView(id: id));
  }
}
