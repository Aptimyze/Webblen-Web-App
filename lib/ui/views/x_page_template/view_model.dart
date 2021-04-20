import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

class ViewModel extends ReactiveViewModel {
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();

  ///USER DATA
  WebblenUser get user => _reactiveWebblenUserService.user;
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];
  initialize() {}
}
