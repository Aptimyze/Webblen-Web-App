import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';

class CustomAlerts {
  showInfoAlert(BuildContext context, String title, String desc) {
    Alert(
      context: context,
      type: AlertType.info,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            "Dismiss",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  showSuccessAlert(BuildContext context, String title, String desc) {
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  showSuccessActionAlert(BuildContext context, String title, String desc, VoidCallback action, String actionText) {
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            actionText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            action;
          },
          width: 120,
        )
      ],
    ).show();
  }

  showErrorAlert(BuildContext context, String title, String desc) {
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          color: Colors.black,
          child: Text(
            "Dismiss",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  ShowLoadingAlert(BuildContext context, String alertDescription) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
    Alert(
      context: context,
      type: AlertType.none,
      style: alertStyle,
      title: alertDescription,
      content: Container(
        margin: EdgeInsets.only(top: 8.0),
        child: CustomCircleProgress(50, 50, 50, 50, Colors.red),
      ),
      buttons: [],
    ).show();
  }
}
