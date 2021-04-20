import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class CommentTextFieldViewModel extends ReactiveViewModel {
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();

  ///USER DATA
  WebblenUser get user => _reactiveWebblenUserService.user;
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;

  List<WebblenUser> mentionedUsers = [];

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];

  addUserToMentions(WebblenUser user) {
    mentionedUsers.add(user);
    notifyListeners();
  }

  List<WebblenUser> getMentionedUsers({String? commentText}) {
    mentionedUsers.forEach((user) {
      if (!commentText!.contains(user.username!)) {
        mentionedUsers.remove(user);
      }
    });
    notifyListeners();
    return mentionedUsers;
  }

  clearMentionedUsers() {
    mentionedUsers = [];
    notifyListeners();
  }
}
