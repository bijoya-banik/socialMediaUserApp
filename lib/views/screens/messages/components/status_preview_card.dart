import 'package:buddyscripts/controller/feed/feed_details_controller.dart';
import 'package:buddyscripts/custom_plugin/video_thumbnail_generator.dart';
import 'package:buddyscripts/models/chats/chat_model.dart';
import 'package:buddyscripts/views/screens/home/feed_details_screen.dart';
import 'package:buddyscripts/views/screens/messages/components/file_preview.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusPreviewCard extends ConsumerWidget {
  final ChatMetaData chatMetaData;
  final String msg;
  const StatusPreviewCard(this.chatMetaData, this.msg, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref
            .read(feedDetailsProvider.notifier)
            .fetchFeedDetails(chatMetaData.feedMeta!.id!);
        Navigator.of(context, rootNavigator: true).push((CupertinoPageRoute(
            builder: (context) => const FeedDetailsScreen())));
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
                    child:
                        //  Image.asset(
                        //   AssetPath.appLogo,
                        //   fit: BoxFit.cover,
                        //   width: MediaQuery.of(context).size.width * 0.6,
                        //   height: KSize.getHeight(context, 120),
                        // )
                        chatMetaData.feedMeta?.type == "image"
                            ? Image.network(
                                chatMetaData.feedMeta?.fileLoc ?? "",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: KSize.getHeight(context, 120),
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                      child: CupertinoActivityIndicator());
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Icon(Icons.info, color: KColor.black),
                                        Text(
                                          "Something went wrong",
                                          style: KTextStyle.caption
                                              .copyWith(color: KColor.black),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              )
                            : chatMetaData.feedMeta?.type == "video"
                                ? ThumbnailImage(
                                    videoUrl: chatMetaData.feedMeta?.fileLoc,
                                    // videoUrl: "https://divine9.b-cdn.net/filestore/ckxzw7nw600105vh2aydk7yju.mp4",
                                    // videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: KSize.getHeight(context, 120),
                                  )
                                : chatMetaData.feedMeta?.type == 'application'
                                    ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FilePreview(
                                          // TODO :: Check why we don't get file name here
                                          // chatMetaData.feedMeta?.originalName ?? "",
                                          chatMetaData.feedMeta?.title ?? "",
                                          //"",
                                          chatMetaData.feedMeta?.fileLoc ?? "",
                                          true,
                                          '',
                                          isFeed: true,
                                        ),
                                      )
                                    : Container()),
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
                      visible: chatMetaData.feedMeta?.desc != null,
                      child: Container(
                        margin: const EdgeInsets.only(top: 7, bottom: 10),
                        child: Text(
                          chatMetaData.feedMeta?.desc ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: KTextStyle.bodyText1.copyWith(
                              color: KColor.black54,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 30,
                          top: chatMetaData.feedMeta?.desc == null ? 10 : 0),
                      child: Text(
                        chatMetaData.feedMeta?.title ?? "",
                        style: KTextStyle.bodyText1.copyWith(
                            fontSize: 17,
                            color: KColor.black54,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0),
                      ),
                    ),
                  ],
                ),
              ),

              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         margin: EdgeInsets.only(top: 7, bottom: 10),
              //         child: Text(
              //           "description hfidus hfiudh uifh duih udfh uidf udfh duif hdui d fdui uid fdui di  duif hduih duih fduih dui hudfh dui hduighfu idhgiufd hduighudf ",
              //           overflow: TextOverflow.ellipsis,
              //           maxLines: 3,
              //           style: KTextStyle.bodyText1.copyWith( color: KColor.black54, fontWeight: FontWeight.w400, letterSpacing: 0),
              //         ),
              //       ),
              //       Container(
              //         margin: EdgeInsets.only(bottom: 10),
              //         child: Text(
              //           "name",
              //           style: KTextStyle.bodyText1.copyWith(fontSize: 17,color: KColor.black54, fontWeight: FontWeight.w400, letterSpacing: 0),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          )),
    );
  }
}
