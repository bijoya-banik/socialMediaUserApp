import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileInfoTile extends StatelessWidget {
  final String? title, value;
  final Icon? icon;
  final Function()? onInlineEdit;
  const ProfileInfoTile({Key? key, this.title, this.value, this.icon, this.onInlineEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: onInlineEdit != null ? 0 : 5),
      child: InkWell(
        onTap: () {
          if (title == 'Website' && (value != null || value != '')) {
            launch(value!);
          }
        },
        child: Row(
          children: [
            icon!,
            SizedBox(width: KSize.getWidth(context, 10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value ?? '', style: KTextStyle.bodyText2.copyWith(color: KColor.black, fontWeight: FontWeight.w500)),
                  SizedBox(height: KSize.getHeight(context, 5)),
                  Text(title ?? '', style: KTextStyle.subtitle2.copyWith(fontWeight: FontWeight.normal, color: KColor.black54)),
                ],
              ),
            ),
            if (onInlineEdit != null) IconButton(onPressed: onInlineEdit, icon: Icon(Feather.edit, size: 20, color: KColor.black54)),
          ],
        ),
      ),
    );
  }
}
