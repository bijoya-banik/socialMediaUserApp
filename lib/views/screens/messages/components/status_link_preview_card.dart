import 'package:buddyscripts/models/chats/chat_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusLinkPreviewCard extends StatelessWidget {
  final LinkMeta? linkMeta;
  final String msg;
  const StatusLinkPreviewCard(this.linkMeta, this.msg, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (linkMeta?.url != null) {
          launch(linkMeta!.url.toString());
        }
      },
      child: Container(
          decoration: BoxDecoration(
              color: KColor.white,
              border: Border.all(color: KColor.grey350!, width: .6),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(msg == "" ? 15 : 0),
                      topRight: Radius.circular(msg == "" ? 15 : 0),
                      bottomLeft: const Radius.circular(0),
                      bottomRight: const Radius.circular(0),
                    ),
                    child: linkMeta?.image == null
                        ? Container()
                        : Image.network(
                             API.baseUrl+linkMeta?.image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: KSize.getHeight(context, 120),
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const Center(child: CupertinoActivityIndicator());
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.info, color: KColor.black),
                                    Text(
                                      "Something went wrong",
                                      style: KTextStyle.caption.copyWith(color: KColor.black),
                                    )
                                  ],
                                ),
                              );
                            },
                          )),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                    color: KColor.grey100,
                    border: Border.all(color: KColor.grey350!, width: .6),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: linkMeta?.description != null,
                      child: Container(
                        margin: const EdgeInsets.only(top: 7, bottom: 10),
                        child: Text(
                          linkMeta?.description ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: KTextStyle.bodyText1.copyWith(color: KColor.black54, fontWeight: FontWeight.w400, letterSpacing: 0),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30, top: linkMeta?.description == null ? 10 : 0),
                      child: Text(
                        linkMeta?.title ?? "",
                        style: KTextStyle.bodyText1.copyWith(fontSize: 17, color: KColor.blue800, fontWeight: FontWeight.w400, letterSpacing: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
