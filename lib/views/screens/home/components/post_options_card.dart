import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class PostOptionsCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget? customIcon;
  final Function()? onTap;
  final Color bgColor;
  const PostOptionsCard({Key? key, this.title, this.icon, this.customIcon, this.onTap, this.bgColor = KColor.whiteConst}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      color: bgColor == KColor.whiteConst
          ? AppMode.darkMode
              ? KColor.appBackground
              : KColor.white
          : bgColor,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: onTap,
        child: Ink(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.425,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Row(
            children: [
              customIcon ?? Icon(icon, color: AppMode.darkMode ? KColor.white70 : KColor.black87),
              SizedBox(width: KSize.getWidth(context, 6)),
              Text(title ?? '', style: KTextStyle.bodyText3.copyWith(color: KColor.black)),
            ],
          ),
        ),
      ),
    );
  }
}
