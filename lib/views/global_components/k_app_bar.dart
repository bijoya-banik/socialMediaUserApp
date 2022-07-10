import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double elevation;
  final bool automaticallyImplyLeading;
  final double titleSpacing;
  final bool centerTitle;
  final bool isCustomLeading;
  final bool isCustomLeadingFunction;
  final Function()? customLeadingFunction;
  final IconData? customIcon;
  final Widget? customTitle;
  final List<Widget>? customAction;

  const KAppBar({
    this.title,
    this.elevation = 0,
    this.centerTitle = false,
    this.titleSpacing = 0,
    this.automaticallyImplyLeading = true,
    this.isCustomLeading = false,
    this.isCustomLeadingFunction = false,
    this.customLeadingFunction,
    this.customIcon,
    this.customTitle,
    this.customAction,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: KColor.secondary,
      elevation: elevation,
      titleSpacing: !automaticallyImplyLeading ? 0 : titleSpacing,
      automaticallyImplyLeading: automaticallyImplyLeading,
      iconTheme: IconThemeData(color: KColor.white),
      leadingWidth: 35,
      leading: isCustomLeading
          ? IconButton(
              icon: Icon(
                customIcon,
                size: 18,
                color: KColor.black,
              ),
              onPressed: () {
                if (isCustomLeadingFunction) customLeadingFunction!();
                Navigator.of(context).pop();
              },
            )
          : null,
      centerTitle: centerTitle,
      title: customTitle ??
          (title != null ? Text(title!, style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.appBarTitle)) : null),
      actions: customAction,
    );
  }
}
