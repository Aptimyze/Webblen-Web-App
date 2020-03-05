import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundPic extends StatelessWidget {
  final String picURL;
  final double size;
  final bool isUserPic;

  RoundPic({
    this.picURL,
    this.size,
    this.isUserPic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      color: Colors.black38,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: picURL == null
            ? isUserPic ? Icon(FontAwesomeIcons.user, color: Colors.black) : Icon(FontAwesomeIcons.question, color: Colors.black)
            : Image.network(picURL, fit: BoxFit.contain),
      ),
    );
  }
}
