import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/models/webblen_user.dart';

class ReactiveWebblenUserService with ReactiveServiceMixin {
  final _userLoggedIn = ReactiveValue<bool>(false);
  final _user = ReactiveValue<WebblenUser>(WebblenUser());

  bool get userLoggedIn => _userLoggedIn.value;
  WebblenUser get user => _user.value;

  void updateUserLoggedIn(bool val) => _userLoggedIn.value = val;
  void updateWebblenUser(WebblenUser val) => _user.value = val;

  ReactiveWebblenUserService() {
    listenToReactiveValues([_userLoggedIn, _user]);
  }
}
