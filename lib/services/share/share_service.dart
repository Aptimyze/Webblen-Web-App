import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';

class ShareService {
  DialogService _dialogService = locator<DialogService>();

  copyContentLink({@required String contentType, @required String url}) {
    String dialogTitle;
    String dialogDesc;

    Clipboard.setData(ClipboardData(text: url));

    if (contentType == "post") {
      dialogTitle = "Post Link Copied";
      dialogDesc = "The link to this post has been copied to your clipboard";
    } else if (contentType == "event") {
      dialogTitle = "Event Link Copied";
      dialogDesc = "The link to this event has been copied to your clipboard";
    } else if (contentType == "stream") {
      dialogTitle = "Stream Link Copied";
      dialogDesc = "The link to this stream has been copied to your clipboard";
    } else {
      dialogTitle = "Profile Link Copied";
      dialogDesc = "The link to this profile has been copied to your clipboard";
    }

    _dialogService.showDialog(
      title: dialogTitle,
      description: dialogDesc,
      barrierDismissible: true,
      buttonTitle: "Ok",
    );
  }
}
