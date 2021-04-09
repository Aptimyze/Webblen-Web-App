import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';

class NewContentConfirmationBottomSheetModel extends ReactiveViewModel {
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();

  WebblenUser get user => _reactiveWebblenUserService.user;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];
}
