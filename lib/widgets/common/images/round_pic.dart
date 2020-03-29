import 'package:flutter/material.dart';

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
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: NetworkImage(picURL),
      backgroundColor: Colors.grey,
    );
  }
}
