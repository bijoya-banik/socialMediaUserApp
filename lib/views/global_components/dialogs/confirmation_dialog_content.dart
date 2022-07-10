import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ConfirmationDialogContent extends StatefulWidget {
  final Function()? onPressedCallback;
  final String? title;
  final bool titleShow;
  final String? titleContent;
  final String buttonTextYes;
  final String buttonTextNo;
  final Color titleColor;
  final Widget? customBody;

  const ConfirmationDialogContent({
    Key? key,
    this.title,
    this.titleShow = false,
    this.titleContent,
    this.onPressedCallback,
    this.buttonTextYes = "Yes",
    this.buttonTextNo = "No",
    this.titleColor = Colors.black54,
    this.customBody,
  }) : super(key: key);

  @override
  _ConfirmationDialogContentState createState() => _ConfirmationDialogContentState();
}

class _ConfirmationDialogContentState extends State<ConfirmationDialogContent> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KColor.appBackground,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.titleShow)
            Column(
              children: [
                Text(widget.title ?? '',
                    textAlign: TextAlign.center,
                    style: KTextStyle.bodyText1
                        .copyWith(color: widget.titleColor == Colors.black54 ? KColor.black : widget.titleColor, fontWeight: FontWeight.bold)),
                Divider(color: KColor.black54, thickness: 0.5),
                SizedBox(width: KSize.getHeight(context, 14)),
              ],
            ),
          if (widget.customBody != null) widget.customBody!,
          if (widget.titleContent != null && widget.titleContent!.isNotEmpty)
            Text(
              widget.titleContent!,
              style: KTextStyle.subtitle2.copyWith(color: KColor.black87),
            ),
        ],
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: TextButton(
            onPressed: widget.onPressedCallback,
            style: TextButton.styleFrom(primary: KColor.appThemeColor),
            child: Text(widget.buttonTextYes),
          ),
        ),
        PlatformDialogAction(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(primary: KColor.grey),
            child: Text(widget.buttonTextNo),
          ),
        ),
      ],
    );
  }
}
