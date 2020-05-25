import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class URLService {
  openURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        //forceWebView: true,
        //statusBarBrightness: Brightness.light,
      );
    } else {
//      ShowAlertDialogService().showFailureDialog(
//        context,
//        "URL Error",
//        "There was an issue launching this url",
//      );
    }
  }
}
