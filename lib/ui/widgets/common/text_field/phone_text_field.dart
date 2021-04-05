import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:webblen_web_app/constants/app_colors.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final Function() onFieldSubmitted;
  PhoneTextField({@required this.controller, @required this.hintText, @required this.onChanged, @required this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return //TextFieldContainer(child: Container()
        IntlPhoneField(
      countryCodeTextColor: appFontColor(),
      dropDownArrowColor: appFontColor(),
      style: TextStyle(color: appFontColor()),
      controller: controller,
      showDropdownIcon: false,
      onChanged: (phone) => onChanged(phone.completeNumber),
      onSubmitted: (phoneNum) => onFieldSubmitted(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: appFontColorAlt()),
        border: InputBorder.none,
      ),
    );
  }
}
