import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webblen_web_app/constants/strings.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/alerts/custom_alerts.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/round_container.dart';
import 'package:webblen_web_app/widgets/common/containers/text_field_container.dart';
import 'package:webblen_web_app/widgets/common/state/progress_indicator.dart';
import 'package:webblen_web_app/widgets/common/state/zero_state_view.dart';
import 'package:webblen_web_app/widgets/common/text/custom_text.dart';
import 'package:webblen_web_app/widgets/layout/centered_view.dart';

class AccountSetupPage extends StatefulWidget {
  final String referral;
  AccountSetupPage({this.referral});
  @override
  _AccountSetupPageState createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends State<AccountSetupPage> {
  String formSubmitError;
  GlobalKey formKey = GlobalKey<FormState>();
  File userImgFile;
  Uint8List userImageByteMemory;
  String username;
  bool isLoading = false;

  formIsValid() {
    FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  validateAndSubmitForm(String uid) async {
    if (formIsValid()) {
      completeAccountSetup(uid);
    }
  }

  uploadImage() async {
    File file;
    FileReader fileReader = FileReader();
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      file = uploadInput.files.first;
      fileReader.readAsDataUrl(file);
      fileReader.onLoadEnd.listen((event) {
        print(file.size);
        if (file.size > 5000000) {
          CustomAlerts().showErrorAlert(context, "File Size Error", "File Size Cannot Exceed 5MB");
        } else if (file.type == "image/jpg" || file.type == "image/jpeg" || file.type == "image/png") {
          String base64FileString = fileReader.result.toString().split(',')[1];

          //COMPRESS FILE HERE

          setState(() {
            userImgFile = file;
            userImageByteMemory = base64Decode(base64FileString);
          });
        } else {
          CustomAlerts().showErrorAlert(context, "Image Upload Error", "Please Upload a Valid Image");
        }
      });
    });
  }

  completeAccountSetup(String uid) async {
    bool usernameIsValid = Strings().isUsernameValid(username);
    if (usernameIsValid) {
      if (userImgFile != null) {
        setState(() {
          isLoading = true;
          formSubmitError = null;
        });
        WebblenUserData().completeAccountSetup(userImgFile, uid, username).then((error) {
          if (error.isEmpty) {
            setState(() {
              isLoading = false;
            });
            if (widget.referral != null && widget.referral == "earningsSetup") {
              locator<NavigationService>().navigateTo(WalletSetupEarningsRoute);
            } else {
              locator<NavigationService>().navigateTo(AccountRoute);
            }
          } else {
            setState(() {
              formSubmitError = error;
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          formSubmitError = "Profile Image is Required";
        });
      }
    } else {
      setState(() {
        formSubmitError = "Username Can Only Container Numbers & Letters";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return CenteredView(
      child: user == null
          ? Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: CustomLinearProgress(progressBarColor: Colors.red),
            )
          : user.isAnonymous
              ? ZeroStateView(
                  title: "Account Login Required",
                  desc: "Please Sign Into Your Account to Continue",
                  buttonTitle: "Login",
                  buttonAction: () => locator<NavigationService>().navigateTo(AccountLoginRoute),
                )
              : StreamBuilder<WebblenUser>(
                  stream: WebblenUserData().streamCurrentUser(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return ZeroStateView(
                        title: "Account Setup Complete",
                        desc: "Your Account is Setup. Have Fun Getting Involved!",
                        buttonTitle: "My Account",
                        buttonAction: () => locator<NavigationService>().navigateTo(AccountRoute),
                      );
                    return Form(
                      key: formKey,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 500,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: isLoading
                                  ? CustomLinearProgress(progressBarColor: Colors.red)
                                  : formSubmitError != null
                                      ? CustomText(
                                          context: context,
                                          text: formSubmitError,
                                          textColor: Colors.red,
                                          textAlign: TextAlign.center,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        )
                                      : Container(),
                            ),
                            SizedBox(height: 64),
                            CustomText(
                              context: context,
                              text: "Set Profile Pic & Username",
                              textColor: Colors.black,
                              textAlign: TextAlign.center,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: 16),
                            userImageByteMemory == null
                                ? GestureDetector(
                                    onTap: () => uploadImage(),
                                    child: RoundContainer(
                                      size: 150,
                                      color: Colors.black12,
                                      child: Icon(
                                        FontAwesomeIcons.camera,
                                        size: 35,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ).showCursorOnHover
                                : GestureDetector(
                                    onTap: () => uploadImage(),
                                    child: CircleAvatar(
                                      radius: 75,
                                      backgroundImage: MemoryImage(userImageByteMemory),
                                    ),
                                  ).showCursorOnHover,
                            SizedBox(height: 16),
                            TextFieldContainer(
                              width: 300,
                              child: TextFormField(
                                cursorColor: Colors.black,
                                validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
                                onSaved: (value) => username = value,
                                onFieldSubmitted: (val) => validateAndSubmitForm(user.uid),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            CustomColorButton(
                              onPressed: () => validateAndSubmitForm(user.uid),
                              text: widget.referral == "earningsSetup" ? "Continue" : "Complete Setup",
                              textColor: Colors.black,
                              backgroundColor: Colors.white,
                              textSize: 18.0,
                              height: 40.0,
                              width: 200.0,
                            ).showCursorOnHover,
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
