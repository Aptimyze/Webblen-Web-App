import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension WidgetHoverExtensions on Widget {
  Widget get showCursorOnHover {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: this,
    );
  }

  Widget get showTextSelectorOnHover {
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: this,
    );
  }
}
