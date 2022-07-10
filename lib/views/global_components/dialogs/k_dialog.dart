import 'package:flutter/material.dart';

class KDialog {
  static kShowDialog(context, Widget widget, {bool barrierDismissible = true, useRootNavigator = true}) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) => widget,
    );
  }
}
