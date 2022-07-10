import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';

class KContentUnvailableComponent extends StatelessWidget {
  final String message;
  final bool isSearch;
  final bool isUnavailablePost;
  final bool isUnavailablePage;

  const KContentUnvailableComponent({Key? key, this.message="", this.isSearch = false, this.isUnavailablePost = false, this.isUnavailablePage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isUnavailablePost
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 5), vertical: KSize.getHeight(context, 7)),
            decoration: BoxDecoration(
              color: KColor.white,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(color: KColor.black38, width: 0.4),
            ),
            child: Row(
              children: [
                Icon(Icons.lock, color: KColor.black87),
                SizedBox(width: KSize.getWidth(context, 7)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This content isn\'t avaliable at the moment',
                        style: KTextStyle.subtitle2.copyWith(fontSize: 16, color: KColor.black),
                      ),
                      SizedBox(height: KSize.getHeight(context, 3)),
                      Text(
                        'When this happens, it\'s usually because the owner only shared it with a small group of people or changed who can see it, or it\'s been deleted.',
                        style: KTextStyle.bodyText2.copyWith(color: KColor.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : isUnavailablePage
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline_rounded, color: KColor.grey350, size: 100),
                    SizedBox(width: KSize.getHeight(context, 10)),
                    Text(
                      message,
                      style: KTextStyle.headline5.copyWith(color: KColor.black.withOpacity(0.65)),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSearch)
                      Image.asset(
                        AssetPath.searchIcon,
                        color: KColor.black,
                        height: KSize.getHeight(context, 125),
                        width: KSize.getWidth(context, 100),
                      ),
                    if (isSearch) SizedBox(height: KSize.getHeight(context, 5)),
                    Text(message, style: KTextStyle.subtitle2.copyWith(color: KColor.black), textAlign: TextAlign.center),
                  ],
                ),
              );
  }
}
