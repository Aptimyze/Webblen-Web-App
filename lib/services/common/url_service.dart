import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';

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
      CustomAlerts().showErrorAlert(context, "URL Error", "There was an issue opening this url");
    }
  }
}
