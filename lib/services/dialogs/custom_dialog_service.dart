import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/enums/dialog_type.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class CustomDialogService {
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PlatformDataService _platformDataService = locator<PlatformDataService>();

  showErrorDialog({required String description}) async {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: "Error",
      description: description,
      buttonTitle: "Ok",
    );
  }

  showSuccessDialog({required String title, required String description}) async {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: title,
      description: description,
      buttonTitle: "Ok",
    );
  }

  showAuthDialog() async {
    var response = await _dialogService.showCustomDialog(
      barrierDismissible: false,
      variant: DialogType.loginDialog,
    );
  }

  showLoginRequiredDialog({required String description}) async {
    DialogResponse? response = await _dialogService.showDialog(
      title: "Login Required",
      description: description,
      barrierDismissible: true,
      buttonTitle: "Log In",
      cancelTitle: "Cancel",
    );
    if (response != null) {
      if (response.confirmed) {
        _navigationService.navigateTo(Routes.AuthViewRoute);
      }
    }
  }

  showLoginExplanationDialog() async {
    await _dialogService.showDialog(
      title: "Why is Login Required?",
      description: "Logging in allows you to easily access your tickets and earn rewards for the events you attend",
      barrierDismissible: true,
      buttonTitle: "Ok",
    );
  }

  showAppOnlyDialog({required String description}) async {
    String? url = await _platformDataService.getWebblenDownloadLink();
    DialogResponse? response = await _dialogService.showDialog(
      barrierDismissible: true,
      title: "Mobile App Required",
      description: description,
      cancelTitle: "Cancel",
      buttonTitle: "Download Webblen",
    );
    if (response != null) {
      if (response.confirmed) {
        if (url?.isNotEmpty ?? true) {
          UrlHandler().launchInWebViewOrVC(url!);
        }
      }
    }
  }

  showPostDeletedDialog() {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: "Post Deleted",
      description: "Your post has been deleted",
      buttonTitle: "Ok",
    );
  }

  showStreamDeletedDialog() {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: "Stream Deleted",
      description: "Your stream has been deleted",
      buttonTitle: "Ok",
    );
  }

  showEventDeletedDialog() {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: "Event Deleted",
      description: "Your event has been deleted",
      buttonTitle: "Ok",
    );
  }

  showCancelContentDialog({required bool isEditing, required String contentType}) async {
    DialogResponse? response = await _dialogService.showDialog(
      title: isEditing ? "Cancel Editing ${contentType}?" : "Cancel Creating ${contentType}?",
      description:
          isEditing ? "Changes to this ${contentType.toLowerCase()} will not be saved" : "The details for this  ${contentType.toLowerCase()} will not be saved",
      cancelTitle: "Cancel",
      cancelTitleColor: appDestructiveColor(),
      buttonTitle: isEditing ? "Discard Changes" : "Discard Stream",
      buttonTitleColor: appTextButtonColor(),
      barrierDismissible: true,
    );
    if (response != null && !response.confirmed) {
      _navigationService.back();
    }
  }

  Future<bool> showNavigateToEarningsAccountDialog({required bool isEditing, required String contentType}) async {
    DialogResponse? response = await _dialogService.showDialog(
      title: "Create an Earnings Account?",
      description:
          isEditing ? "Changes to this ${contentType.toLowerCase()} will not be saved" : "The details for this ${contentType.toLowerCase()} will not be saved",
      cancelTitle: "Continue Editing",
      cancelTitleColor: appTextButtonColor(),
      buttonTitle: "Create Earnings Account",
      buttonTitleColor: appTextButtonColor(),
      barrierDismissible: true,
    );
    if (response != null && response.confirmed) {
      return true;
    }
    return false;
  }

  showEarningsAccountPendingAlert() {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: "Account Under Review",
      description: "Review can take up 24 hours\nPlease check back later",
      buttonTitle: "Ok",
    );
  }

  showFailedToSetupPaymentAccountDialog() {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: "Account Setup Error",
      description: "There was an Issue Adding Your Account\nPlease Verify Your Info and Try Again",
      buttonTitle: "Ok",
    );
  }
}
