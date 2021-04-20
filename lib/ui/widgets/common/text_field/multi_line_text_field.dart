import 'package:flutter/material.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/widgets/common/text_field/text_field_container.dart';

class MultiLineTextField extends StatelessWidget {
  final bool enabled;
  final TextEditingController controller;
  final String hintText;
  final String? initialValue;
  final int? maxLines;
  final Function(String)? onChanged;
  MultiLineTextField({
    required this.enabled,
    required this.controller,
    required this.hintText,
    required this.initialValue,
    required this.maxLines,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        enabled: enabled,
        initialValue: initialValue,
        controller: controller,
        maxLines: maxLines,
        cursorColor: appFontColorAlt(),
        onChanged: onChanged == null ? null : (val) => onChanged!(val),
        style: TextStyle(color: appFontColor()),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: appFontColorAlt(),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
