import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class CommentTextFieldViewModel extends BaseViewModel {
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  List<WebblenUser> mentionedUsers = [];

  addUserToMentions(WebblenUser user) {
    mentionedUsers.add(user);
    notifyListeners();
  }

  List<WebblenUser> getMentionedUsers({String commentText}) {
    mentionedUsers.forEach((user) {
      if (!commentText.contains(user.username)) {
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