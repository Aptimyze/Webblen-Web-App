import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Icon icon;
  final double size;
  final Color color;
  final VoidCallback onTap;

  CustomIconButton({
    this.icon,
    this.size,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        // boxShadow: [new BoxShadow(
        //   color: Colors.black12,
        //   blurRadius: 1.5,
        //   offset: Offset(0.0, 3.0),
        // )],
      ),
      child: Center(child: icon),
    );
  }
}
