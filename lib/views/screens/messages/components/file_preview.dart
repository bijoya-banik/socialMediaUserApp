import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';

class FilePreview extends StatelessWidget {
  final String title, url;
  final bool isSelf, isGroup, isFeed;
  final String? firstName;
  const FilePreview(this.title, this.url, this.isSelf, this.firstName, {Key? key, this.isGroup = false, this.isFeed = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: EdgeInsets.only(left: isFeed ? 5 : 8, right: isFeed ? 5 : 8, top: isFeed ? 5 : 8, bottom: isFeed ? 5 : 25),
          decoration: BoxDecoration(
              color: KColor.feedActionCircle,
              borderRadius: isFeed
                  ? BorderRadius.circular(15)
                  : BorderRadius.only(
                      topLeft: Radius.circular(!isSelf ? 0 : 15),
                      topRight: Radius.circular(!isSelf ? 15 : 0),
                      bottomLeft: const Radius.circular(15),
                      bottomRight: const Radius.circular(15),
                    )),
          child: Column(
            children: [
              if (!isSelf && isGroup)
                Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 7),
                    child: Text(firstName!, style: KTextStyle.bodyText3.copyWith(color: KColor.primary, fontWeight: FontWeight.bold))),
              Material(
                color: KColor.white54,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    AssetService.downloadFile(url);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: isFeed ? 8 : 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_copy,
                          size: 20,
                          color: KColor.linkedinLogoColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(title, overflow: TextOverflow.ellipsis, style: KTextStyle.caption.copyWith(color: KColor.black)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
