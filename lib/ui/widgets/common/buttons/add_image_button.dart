import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';

import '../custom_text.dart';

class ImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isOptional;
  ImageButton({@required this.onTap, @required this.isOptional});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 500,
          minWidth: 500,
        ),
        color: appImageButtonColor(),
        child: Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.camera,
                  color: appIconColorAlt(),
                  size: 24,
                ),
                verticalSpaceTiny,
                CustomText(
                  text: '1:1',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: appIconColorAlt(),
                ),
                verticalSpaceTiny,
                isOptional
                    ? CustomText(
                        text: '(optional)',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: appIconColorAlt(),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    ).showCursorOnHover;
  }
}

class ImagePreviewButton extends StatelessWidget {
  final VoidCallback onTap;
  final File file;
  final String imgURL;

  ImagePreviewButton({@required this.onTap, @required this.file, @required this.imgURL});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 500,
            maxWidth: 500,
          ),
          child: Expanded(
            child: file == null
                ? FadeInImage.memoryNetwork(
                    image: imgURL,
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                  )
                : Image.file(file, fit: BoxFit.contain, filterQuality: FilterQuality.medium),
          ),
        ),
      ),
    ).showCursorOnHover;
  }
}
