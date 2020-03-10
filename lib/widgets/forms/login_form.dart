import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/styles/custom_colors.dart';
import 'package:webblen_web_app/styles/custom_text.dart';
import 'package:webblen_web_app/widgets/common/buttons/custom_color_button.dart';
import 'package:webblen_web_app/widgets/common/containers/text_field_container.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey formKey;
  final VoidCallback navigateToRegistrationPage;
  LoginForm({this.formKey, this.navigateToRegistrationPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Form(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomText(
              context: context,
              text: "Login",
              textColor: Colors.black,
              textAlign: TextAlign.left,
              fontSize: 40.0,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 16.0),
            TextFieldContainer(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Email",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TextFieldContainer(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            CustomColorButton(
              onPressed: null,
              text: "Login",
              textColor: Colors.black,
              backgroundColor: Colors.white,
              textSize: 18.0,
              height: 40.0,
              width: 200.0,
              hPadding: 8.0,
              vPadding: 8.0,
            ).showCursorOnHover,
            SizedBox(height: 8.0),
            Container(
              height: 1,
              width: 300,
              color: Colors.black38,
            ).showCursorOnHover,
            SizedBox(height: 8.0),
            SignInButton(
              Buttons.Facebook,
              onPressed: () {},
            ).showCursorOnHover,
            SignInButton(
              Buttons.Google,
              onPressed: () {},
            ).showCursorOnHover,
            SizedBox(height: 16.0),
            Container(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomText(
                    context: context,
                    text: "Don't Have an Account? ",
                    textColor: Colors.black,
                    textAlign: TextAlign.left,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  GestureDetector(
                    onTap: navigateToRegistrationPage,
                    child: CustomText(
                      context: context,
                      text: "Sign Up",
                      textColor: CustomColors.webblenRed,
                      textAlign: TextAlign.left,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ).showCursorOnHover,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
