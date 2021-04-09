import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

class CustomDialogService {
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PlatformDataService _platformDataService = locator<PlatformDataService>();

  showErrorDialog({required String description}) async {
    _dialogService.showDialog(
      title: "Error",
      description: description,
      buttonTitle: "Ok",
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

  showAppOnlyDialog({required String description}) async {
    String? url = await _platformDataService.getWebblenDownloadLink();
    DialogResponse? response = await _dialogService.showDialog(
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
      title: "Post Deleted",
      description: "Your post has been deleted",
      buttonTitle: "Ok",
    );
  }

  showStreamDeletedDialog() {
    _dialogService.showDialog(
      title: "Stream Deleted",
      description: "Your stream has been deleted",
      buttonTitle: "Ok",
    );
  }

  showEventDeletedDialog() {
    _dialogService.showDialog(
      title: "Event Deleted",
      description: "Your event has been deleted",
      buttonTitle: "Ok",
    );
  }
}
