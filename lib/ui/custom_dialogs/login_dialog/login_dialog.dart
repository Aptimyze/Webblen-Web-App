import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/apple_auth_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/email_auth_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/fb_auth_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/google_auth_button.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/phone_auth_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/text_field/phone_text_field.dart';
import 'package:webblen_web_app/ui/widgets/common/text_field/single_line_text_field.dart';
import 'package:webblen_web_app/utils/url_handler.dart';

import 'login_dialog_model.dart';

class LoginDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const LoginDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  Widget orTextLabel() {
    return Text(
      'or sign in with',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget authButtons(LoginDialogModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FacebookAuthButton(
          action: () => model.signInWithFacebook(),
        ),
        AppleAuthButton(
          action: () => model.signInWithApple(),
        ),
        GoogleAuthButton(
          action: () => model.signInWithGoogle(),
        ),
        model.signInViaPhone
            ? EmailAuthButton(
                action: () => model.togglePhoneEmailAuth(),
              )
            : PhoneAuthButton(
                action: () => model.togglePhoneEmailAuth(),
              )
      ],
    );
  }

  Widget serviceAgreement(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'By Registering, You agree to the ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'Terms and Conditions ',
              mouseCursor: MaterialStateMouseCursor.clickable,
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()..onTap = () => UrlHandler().launchInWebViewOrVC("https://webblen.io/terms-and-conditions"),
            ),
            TextSpan(
              text: 'and ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'Privacy Policy. ',
              mouseCursor: MaterialStateMouseCursor.clickable,
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()..onTap = () => UrlHandler().launchInWebViewOrVC("https://webblen.io/privacy-policy"),
            ),
          ],
        ),
      ),
    );
  }

  displayBottomActionSheet(BuildContext context, LoginDialogModel model) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'Enter SMS Code',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16),
              SingleLineTextField(
                controller: model.smsController,
                hintText: 'SMS Code',
                textLimit: null,
                isPassword: false,
              ),
              SizedBox(height: 24),
              CustomButton(
                elevation: 1,
                text: 'Submit',
                textColor: Colors.black,
                backgroundColor: Colors.white,
                isBusy: model.isBusy,
                height: 50,
                width: screenWidth(context),
                onPressed: () => model.signInWithSMSCode(
                  context: context,
                  smsCode: model.smsController.text,
                ),
                textSize: 14,
              ),
            ],
          ),
        );
      },
    );
  }

  sendSMSCode(BuildContext context, LoginDialogModel model) async {
    bool receivedVerificationID = await model.sendSMSCode(phoneNo: model.phoneNo);
    if (receivedVerificationID) {
      displayBottomActionSheet(context, model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginDialogModel>.reactive(
      viewModelBuilder: () => LoginDialogModel(),
      builder: (context, model, child) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: appBackgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    verticalSpaceMedium,
                    CustomText(
                      text: "Please Login/Register to Continue",
                      textAlign: TextAlign.left,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: appFontColor(),
                    ),
                    CustomTextButton(
                      onTap: () => model.showLoginExplanationDialog(),
                      text: "Why do I have to login?",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: appTextButtonColor(),
                    ).showCursorOnHover,

                    ///AUTH FORM
                    verticalSpaceMedium,
                    model.signInViaPhone
                        ? PhoneTextField(
                            controller: model.phoneMaskController,
                            hintText: "701-120-3000",
                            onChanged: (phoneNo) => model.setPhoneNo(phoneNo),
                            onFieldSubmitted: () => sendSMSCode(context, model),
                          )
                        : SingleLineTextField(
                            controller: model.emailController,
                            hintText: "Email Address",
                            textLimit: null,
                            isPassword: false,
                            onFieldSubmitted: () => model.signInWithEmail(email: model.emailController.text, password: model.passwordController.text),
                          ),
                    verticalSpaceSmall,
                    model.signInViaPhone
                        ? Container()
                        : SingleLineTextField(
                            controller: model.passwordController,
                            hintText: "Password",
                            textLimit: null,
                            isPassword: true,
                            onFieldSubmitted: () => model.signInWithEmail(email: model.emailController.text, password: model.passwordController.text),
                          ),
                    model.signInViaPhone ? Container() : verticalSpaceMedium,
                    CustomButton(
                      elevation: 1,
                      text: model.signInViaPhone ? 'Send SMS Code' : 'Login',
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      isBusy: model.isBusy,
                      height: 50,
                      width: screenWidth(context),
                      onPressed: model.signInViaPhone
                          ? () => sendSMSCode(context, model)
                          : () => model.signInWithEmail(email: model.emailController.text, password: model.passwordController.text),
                      textSize: 14,
                    ),
                    verticalSpaceMedium,
                    orTextLabel(),
                    verticalSpaceSmall,
                    authButtons(model),
                    verticalSpaceLarge,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: serviceAgreement(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
