import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedLinkPreviewWidget extends StatelessWidget {
  final LinkMeta? linkMetaData;
  const FeedLinkPreviewWidget(this.linkMetaData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  linkMetaData==null?
    Container():
     InkWell(
      onTap: () async => await launch(linkMetaData!.url!),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(color: KColor.grey100, border: Border.all(color: KColor.grey350!, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: linkMetaData?.image == null || linkMetaData?.image == "" || !(linkMetaData?.image.contains('https://'))
                        ? Container()
                        : Image.network(
                           API.baseUrl+ linkMetaData?.image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width / 4,
                            height: KSize.getHeight(context, 120),
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CupertinoActivityIndicator());
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info, color: KColor.black),
                                  Text("Something went wrong", style: KTextStyle.caption.copyWith(color: KColor.black))
                                ],
                              );
                            },
                          )),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          linkMetaData?.url??"",
                          style: KTextStyle.bodyText2.copyWith(color: KColor.black54),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Text(linkMetaData?.title == null ? "" : linkMetaData!.title!, style: KTextStyle.subtitle1.copyWith(color: KColor.black)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          linkMetaData!.description == null ? "" : linkMetaData!.description!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: KTextStyle.bodyText2.copyWith(color: KColor.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
