import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class CommentBlockViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  WebblenBaseViewModel? webblenBaseViewModel = locator<WebblenBaseViewModel>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();

  ///ERROR STATUS
  bool errorLoadingData = false;

  ///USER DATA
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  ///DATA
  bool isAuthor = false;
  String? authorUID;
  String? username;
  String? authorProfilePicURL;

  ///VIEW STATUS
  bool showingReplies = false;

  ///Loading User
  bool loadingUser = false;

  ///INITIALIZE
  initialize(String? uid) async {
    //set busy status
    setBusy(true);

    //get comment author data
    var res = await _userDataService.getWebblenUserByID(uid);

    if (res is String) {
      errorLoadingData = true;
    } else {
      //set author data
      authorUID = res.id;
      username = res.username;
      authorProfilePicURL = res.profilePicURL;

      //check if author is current user
      if (authorUID == user.id) {
        isAuthor = true;
      }
    }
    notifyListeners();
    setBusy(false);
  }

  ///Toggle Replies
  toggleShowReplies() {
    if (showingReplies) {
      showingReplies = false;
    } else {
      showingReplies = true;
    }
    notifyListeners();
  }

  navigateToMentionedUser(String username) async {
    if (!loadingUser) {
      loadingUser = true;
      notifyListeners();
      WebblenUser user = await _userDataService.getWebblenUserByUsername(username);
      loadingUser = false;
      notifyListeners();
      if (user.isValid()) {
        navigateToUserPage(user.id);
      }
    }
  }

  ///NAVIGATION
  navigateToUserPage(String? id) {
    _navigationService.navigateTo(Routes.UserProfileView(id: id));
  }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
