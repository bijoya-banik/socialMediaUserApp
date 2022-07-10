import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class KCupertinoNavBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final bool hasBorder;
  final String? title;
  final Widget? customMiddle;
  final bool hasLeading;
  final Widget? customLeading;
  final Color backgroundColor;
  final Color arrowIconColor;
  final bool automaticallyImplyLeading;
  final Widget? trailing;

  // ignore: prefer_const_constructors_in_immutables
  KCupertinoNavBar({
    this.hasBorder = true,
    this.title,
    this.customMiddle,
    this.hasLeading = true,
    this.customLeading,
    this.backgroundColor = KColor.whiteConst,
    this.arrowIconColor = KColor.blackConst,
    this.automaticallyImplyLeading = true,
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      border: Border(bottom: BorderSide(color: KColor.black26, width: 0.0, style: hasBorder ? BorderStyle.solid : BorderStyle.none)),
      middle: customMiddle ??
          Text(
            title ?? '',
            overflow: TextOverflow.ellipsis,
            style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.black),
          ),
      backgroundColor: backgroundColor == KColor.whiteConst && AppMode.darkMode ? KColor.appBackground : backgroundColor,
      leading: hasLeading
          ? customLeading ??
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 18, color: arrowIconColor == KColor.blackConst ? KColor.black : arrowIconColor),
                onPressed: () => Navigator.pop(context),
              )
          : null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      trailing: trailing,
    );
  }
}
