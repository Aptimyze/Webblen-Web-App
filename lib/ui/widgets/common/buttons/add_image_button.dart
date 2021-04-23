import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/user/user_profile_pic.dart';

import '../custom_text.dart';

class ImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isOptional;
  final double? uploadProgress;
  ImageButton({required this.onTap, required this.isOptional, required this.uploadProgress});

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
              uploadProgress == 0
                  ? Column(
                      children: [
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
                    )
                  : CustomText(
                      text: (uploadProgress! * 100).toStringAsFixed(0) + "%",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: appIconColorAlt(),
                    ),
            ],
          ),
        ),
      ),
    ).showCursorOnHover;
  }
}

class ImagePreviewButton extends StatelessWidget {
  final VoidCallback onTap;
  final Uint8List? imgByteMemory;
  final String? imgURL;

  ImagePreviewButton({required this.onTap, required this.imgByteMemory, required this.imgURL});

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
          child: imgByteMemory == null
              ? FadeInImage.memoryNetwork(
                  image: imgURL!,
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,
                )
              : Image.memory(imgByteMemory!, fit: BoxFit.contain, filterQuality: FilterQuality.medium),
        ),
      ),
    ).showCursorOnHover;
  }
}

class UserProfilePicButtonPreview extends StatelessWidget {
  final VoidCallback onTap;
  final Uint8List? imgByteMemory;
  final String? imgURL;

  UserProfilePicButtonPreview({required this.onTap, required this.imgByteMemory, required this.imgURL});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 100,
          maxWidth: 100,
        ),
        child: imgByteMemory == null
            ? UserProfilePic(
                isBusy: false,
                userPicUrl: imgURL,
                size: 100,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.memory(imgByteMemory!, fit: BoxFit.contain, filterQuality: FilterQuality.medium),
              ),
      ),
    ).showCursorOnHover;
  }
}
