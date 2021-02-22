import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen_web_app/constants/app_colors.dart';

class SearchField extends StatelessWidget {
  final VoidCallback onTap;
  final TextEditingController textEditingController;
  final Function(String) onChanged;
  final Function(String) onFieldSubmitted;

  SearchField({
    @required this.onTap,
    @required this.textEditingController,
    @required this.onChanged,
    @required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 200,
      ),
      padding: EdgeInsets.only(left: 8),
      height: 35,
      decoration: BoxDecoration(
        color: appTextFieldContainerColor(),
        border: Border.all(
          width: 1.0,
          color: appBorderColorAlt(),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            child: Icon(
              FontAwesomeIcons.search,
              color: appFontColorAlt(),
              size: 16,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Material(
                color: Colors.transparent,
                child: TextFormField(
                  controller: textEditingController,
                  cursorColor: appFontColor(),
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (val) => onFieldSubmitted(val),
                  onChanged: (val) => onChanged(val),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 14),
                    hintText: "search",
                    hintStyle: TextStyle(
                      color: appFontColorAlt(),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
