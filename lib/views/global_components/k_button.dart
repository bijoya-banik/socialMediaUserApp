import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class KButton extends StatefulWidget {
  final String? title;
  final Function()? onPressedCallback;
  final double innerPadding;
  final Color color;
  final Color textColor;
  final bool isOutlineButton;
  final bool hasTrailngTitleIcon;
  final Icon? leadingTitleIcon;
  final Icon? trailingTitleIcon;
  final TextOverflow textOverflow;

  const KButton({
    this.title,
    this.onPressedCallback,
    this.innerPadding = 12,
    this.color = KColor.buttonBackgroundConst,
    this.textColor = KColor.whiteConst,
    this.isOutlineButton = false,
    this.hasTrailngTitleIcon = false,
    this.leadingTitleIcon,
    this.trailingTitleIcon,
    this.textOverflow = TextOverflow.visible,
    Key? key,
  }) : super(key: key);

  @override
  _KButtonState createState() => _KButtonState();
}

class _KButtonState extends State<KButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: KColor.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all( Radius.circular(6)),
        onTap: widget.onPressedCallback,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: widget.innerPadding, bottom: widget.leadingTitleIcon != null ? widget.innerPadding : widget.innerPadding + 3),
          decoration: widget.isOutlineButton
              ? BoxDecoration(
                  border: Border.all(color: AppMode.darkMode ? KColor.white54Const : KColor.primary.withOpacity(0.4)),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                )
              : BoxDecoration(
                  color: widget.color,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.leadingTitleIcon != null) widget.leadingTitleIcon!,
              if (widget.leadingTitleIcon != null) SizedBox(width: KSize.getWidth(context, 8)),
              Expanded(
                flex: widget.textOverflow == TextOverflow.ellipsis ? 1 : 0,
                child: Text(
                  widget.title ?? '',
                  textAlign: TextAlign.center,
                  overflow: widget.textOverflow,
                  style: KTextStyle.button.copyWith(color: !widget.isOutlineButton ? widget.textColor : KColor.black),
                ),
              ),
              if (widget.trailingTitleIcon != null) SizedBox(width: KSize.getWidth(context, 5)),
              if (widget.trailingTitleIcon != null) widget.trailingTitleIcon!,
            ],
          ),
        ),
      ),
    );
  }
}
