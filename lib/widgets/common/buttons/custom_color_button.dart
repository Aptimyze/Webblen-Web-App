import 'package:flutter/material.dart';

class CustomColorButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final double textSize;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double hPadding;
  final double vPadding;

  CustomColorButton({
    this.text,
    this.textSize,
    this.height,
    this.width,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.hPadding,
    this.vPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(4.0),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: FittedBox(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: textSize != null ? textSize : 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    fit: BoxFit.scaleDown,
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

class CustomColorIconButton extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final String text;
  final double height;
  final double width;
  final double textSize;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double hPadding;
  final double vPadding;

  CustomColorIconButton({
    this.iconData,
    this.iconSize,
    this.text,
    this.textSize,
    this.height,
    this.width,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.hPadding,
    this.vPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                color: Colors.black,
                size: iconSize != null ? iconSize : 16.0,
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: FittedBox(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: textSize != null ? textSize : 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    fit: BoxFit.scaleDown,
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
