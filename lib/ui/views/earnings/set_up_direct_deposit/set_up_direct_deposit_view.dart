import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/views/earnings/set_up_direct_deposit/set_up_direct_deposit_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar.dart';
import 'package:webblen_web_app/ui/widgets/common/navigation/nav_bar/custom_top_nav_bar/custom_top_nav_bar_item.dart';
import 'package:webblen_web_app/ui/widgets/common/text_field/text_field_container.dart';

class SetupDirectDepositView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SetUpDirectDepositViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => SetUpDirectDepositViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: CustomTopNavBar(
            navBarItems: [
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(0),
                iconData: FontAwesomeIcons.home,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(1),
                iconData: FontAwesomeIcons.search,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(2),
                iconData: FontAwesomeIcons.wallet,
                isActive: false,
              ),
              CustomTopNavBarItem(
                onTap: () => model.webblenBaseViewModel.navigateToHomeWithIndex(3),
                iconData: FontAwesomeIcons.user,
                isActive: false,
              ),
            ],
          ),
        ),
        body: Container(
          height: screenHeight(context),
          color: appBackgroundColor,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  constraints: BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 32.0),
                      CustomText(
                        text: "Set Up Direct Deposit",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: appFontColor(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      CustomText(
                        text: "Add your bank details to receive your earnings directly into your bank account.",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appFontColor(),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.0),
                      CustomText(
                        text:
                            "To keep your earnings secure, payments from Webblen will be placed on hold for 24 hours. Once your bank account has been verified, any earnings from Webblen during this time will be paid out to your account on the following Monday. This is to ensure your earnings go to your bank account.",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: appFontColor(),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 16.0),
                      CustomText(
                        text: "NAME ON BANK ACCOUNT",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: appFontColor(),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 4.0),
                      _AccountHolderNameField(),
                      SizedBox(height: 16.0),
                      CustomText(
                        text: "ACCOUNT TYPE",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: appFontColor(),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 4.0),
                      _AccountHolderTypeField(),
                      SizedBox(height: 16.0),
                      CustomText(
                        text: "ROUTING NUMBER",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: appFontColor(),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 4.0),
                      _RoutingNumField(),
                      SizedBox(height: 16.0),
                      CustomText(
                        text: "ACCOUNT NUMBER",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: appFontColor(),
                        textAlign: TextAlign.left,
                      ),
                      _AccountNumField(),
                      SizedBox(height: 32.0),
                      CustomText(
                        text: "Please confirm your bank details before submission. \n Incorrect details may lead to delayed payments.",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: appFontColor(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      CustomButton(
                        text: "Submit",
                        textSize: 16,
                        textColor: appFontColor(),
                        backgroundColor: appButtonColor(),
                        height: 45.0,
                        width: screenWidth(context),
                        onPressed: () => model.submit(),
                        elevation: 1,
                        isBusy: model.isBusy,
                      ),
                      SizedBox(height: 16.0),
                      CustomText(
                        text: "All data is sent via 256-bit encrypted connection to keep your information secure.",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: appFontColor(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountHolderNameField extends HookViewModelWidget<SetUpDirectDepositViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, SetUpDirectDepositViewModel model) {
    var accountHolderName = useTextEditingController();
    return TextFieldContainer(
      child: TextFormField(
        controller: accountHolderName,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: model.updateAccountHolderName,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }
}

class _AccountHolderTypeField extends HookViewModelWidget<SetUpDirectDepositViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, SetUpDirectDepositViewModel model) {
    return TextFieldContainer(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          underline: Container(),
          isDense: true,
          isExpanded: true,
          value: model.accountHolderType,
          items: model.accountTypes.map((val) {
            return DropdownMenuItem(
              child: CustomText(
                text: val,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: appFontColor(),
              ),
              value: val,
            );
          }).toList(),
          onChanged: (val) => model.updateAccountHolderType(val!),
        ),
      ),
    );
  }
}

class _RoutingNumField extends HookViewModelWidget<SetUpDirectDepositViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, SetUpDirectDepositViewModel model) {
    var routingNum = useTextEditingController();
    return TextFieldContainer(
      child: TextFormField(
        controller: routingNum,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: model.updateRoutingNum,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(9),
        ],
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }
}

class _AccountNumField extends HookViewModelWidget<SetUpDirectDepositViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, SetUpDirectDepositViewModel model) {
    var accountNum = useTextEditingController();
    return TextFieldContainer(
      child: TextFormField(
        controller: accountNum,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
          ),
          border: InputBorder.none,
        ),
        onChanged: model.updateAccountNum,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        textInputAction: TextInputAction.done,
        autocorrect: false,
      ),
    );
  }
}
