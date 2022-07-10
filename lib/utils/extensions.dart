import 'package:flutter/widgets.dart';

extension KeyExtensions on GlobalKey {
  Offset get widgetOffset {
    final renderBox = currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size get widgetSize {
    final renderBox = currentContext!.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  Offset get widgetPositionOffset {
    final renderBox = currentContext?.findRenderObject();
    var translation = renderBox?.getTransformTo(null).getTranslation();
    if (renderBox != null && translation != null) {
      return renderBox.paintBounds.shift(Offset(translation.x, translation.y)).center;
    } else {
      return widgetOffset;
    }
  }

  Rect? get widgetPositionRect {
    final renderBox = currentContext?.findRenderObject();
    var translation = renderBox?.getTransformTo(null).getTranslation();

    return renderBox?.paintBounds.shift(Offset(translation?.x ?? 0, translation?.y ?? 0));
  }
}

extension ContextExtensions on BuildContext {
  Size get screenSize {
    return MediaQuery.of(this).size;
  }

  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }
}
