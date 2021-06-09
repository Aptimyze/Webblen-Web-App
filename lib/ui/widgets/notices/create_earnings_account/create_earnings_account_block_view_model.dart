import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/services/stripe/stripe_connect_account_service.dart';

class CreateEarningsAccountBlockViewModel extends ReactiveViewModel {
  StripeConnectAccountService _stripeConnectAccountService = locator<StripeConnectAccountService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();

  ///CURRENT USER
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  createStripeConnectAccount() async {
    _stripeConnectAccountService.createStripeConnectAccount(uid: user.id!);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService];
}