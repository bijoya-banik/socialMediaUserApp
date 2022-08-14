import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/custom_plugin/video_thumbnail_generator.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/global_components/feed_link_preview.dart';
import 'package:buddyscripts/views/global_components/k_image_slider.dart';
import 'package:buddyscripts/views/global_components/k_video_player.dart';
import 'package:buddyscripts/views/screens/home/components/poll_card.dart';
import 'package:buddyscripts/views/screens/messages/components/file_preview.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_image_view.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SharedFeedCard extends ConsumerStatefulWidget {
  final FeedModel? feedData;
  final FeedType? feedType;
  final int? feedId;
  final bool isShare;
  const SharedFeedCard({Key? key, this.feedData, this.feedType, this.feedId, this.isShare = false}) : super(key: key);

  @override
  _SharedFeedCardState createState() => _SharedFeedCardState();
}

class _SharedFeedCardState extends ConsumerState<SharedFeedCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.feedData?.isBackground == 1 ? 0 : 10),
      padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, widget.feedData?.isBackground == 1 ? 0 : 10)),
      decoration: BoxDecoration(
        color: KColor.textBackground,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        border: Border.all(color: KColor.black38, width: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: KSize.getHeight(context, 5)),
          /*
            * Feed assets - images/videos/files 
          */
          if (widget.feedData?.fileType == 'application')
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  alignment: WrapAlignment.start,
                  children: List.generate(widget.feedData!.files!.length, (index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: FilePreview(
                        widget.feedData!.files![index].originalName ?? "",
                        widget.feedData!.files![index].fileLoc ?? "",
                        true,
                        '',
                        isFeed: true,
                      ),
                    );
                  })),
            ),
          widget.feedData == null
              ? Container()
              : widget.feedData!.fileType == 'video'
                  ? widget.feedType == FeedType.DETAILS
                      ? KVideoPlayer(widget.feedData!.files![0].fileLoc)
                      : ThumbnailImage(
                          videoUrl: widget.feedData!.files![0].fileLoc,
                          width: MediaQuery.of(context).size.width,
                          height: KSize.getHeight(context, 200),
                        )
                  : Container(),
          if (widget.feedData!.fileType == 'image')
            widget.feedData!.files!.length == 1
                ? GestureDetector(
                    onTap: () {
                      Navigator.of(context).push<void>(CupertinoPageRoute(builder: (context) => KImageView(url: widget.feedData!.files![0].fileLoc)));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        child: Image.network(
                         API.baseUrl+  widget.feedData!.files![0].fileLoc!,
                          height: KSize.getHeight(context, 250),
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Center(
                      child: Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.center,
                        children: List.generate(widget.feedData!.files!.length, (index) {
                          return index >= 4
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push<void>(CupertinoPageRoute(
                                      builder: (context) => KImageSliderView(
                                        imagesList: List<String>.from(widget.feedData!.files!.map((model) => model.fileLoc)),
                                        initialPage: index,
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    height: KSize.getHeight(context, 140),
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(border: Border.all(color: KColor.appBackground)),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          API.baseUrl+ widget.feedData!.files![index].fileLoc!,
                                          height: KSize.getHeight(context, 140),
                                          width: MediaQuery.of(context).size.width * 0.35,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return const Center(child: CupertinoActivityIndicator());
                                          },
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Icon(Icons.error, color: KColor.black);
                                          },
                                        ),
                                        if (index == 3 && widget.feedData!.files!.length > 4)
                                          Container(
                                            height: KSize.getHeight(context, 140),
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(color: KColor.black.withOpacity(0.4)),
                                            child: Center(
                                              child: Text(
                                                '+${widget.feedData!.files!.length - 3}',
                                                style: KTextStyle.headline5.copyWith(color: KColor.white),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                        }),
                      ),
                    ),
                  ),
          SizedBox(height: KSize.getHeight(context, 5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    UserProfilePicture(
                      avatarRadius: 20,
                      iconSize: 19.5,
                      profileURL: widget.feedData?.pic,
                      slug: widget.feedData?.slug,
                      userId: widget.feedData?.userId,
                      type: widget.feedData?.activityType,
                      onTapNavigate: true,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.feedData?.feelings == null
                              ? UserName(
                                  slug: widget.feedData!.slug,
                                  name:
                                      //  widget.feedType == FeedType.GROUP || widget.feedType == FeedType.EVENT
                                      //     ? widget.feedData!.user!.firstName! + " " + widget.feedData!.user!.lastName!
                                      //     :
                                      widget.feedData!.name,
                                  userId: widget.feedData!.userId,
                                  type: widget.feedData!.activityType,
                                  overflowVisible: true,
                                  backgroundColor: KColor.textBackground,
                                )
                              : Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    UserName(
                                      slug: widget.feedData!.slug,
                                      name: widget.feedType == FeedType.GROUP || widget.feedType == FeedType.EVENT
                                          ? widget.feedData!.user!.firstName! + " " + widget.feedData!.user!.lastName!
                                          : widget.feedData!.name,
                                      userId: widget.feedData!.userId,
                                      type: widget.feedData!.activityType,
                                      overflowVisible: true,
                                      backgroundColor: KColor.textBackground,
                                    ),
                                    if (widget.feedData!.feelings!.icon!.isNotEmpty)
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(horizontal: 1),
                                      //   child: Image.network(
                                      //     widget.feedData!.feelings!.icon!,
                                      //     height: 20,
                                      //     width: 25,
                                      //   ),
                                      // ),
                                    Text(" "+widget.feedData!.feelings!.text!,
                                        style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w400)),
                                  ],
                                ),
                          SizedBox(height: KSize.getHeight(context, 2.5)),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (widget.feedData?.activityType == 'group')
                                Text(
                                  'Group post by ${widget.feedData?.user?.firstName} ${widget.feedData?.user?.lastName}',
                                  style: KTextStyle.bodyText2.copyWith(color: KColor.black54, fontSize: 12, letterSpacing: 0),
                                ),
                              if (widget.feedData?.activityType == 'event')
                                Text(
                                  'Event post by ${widget.feedData?.user?.firstName} ${widget.feedData?.user?.lastName}',
                                  style: KTextStyle.bodyText2.copyWith(color: KColor.black54, fontSize: 12, letterSpacing: 0),
                                ),
                              if (widget.feedData?.activityType == 'group' || widget.feedData?.activityType == 'event')
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(Icons.circle, size: 4, color: KColor.black54),
                                ),
                              Text(
                                DateTimeService.timeAgoLocal(widget.feedData?.createdAt.toString()) ?? '6 hours ago',
                                style: KTextStyle.bodyText2.copyWith(color: KColor.black54, fontSize: 12, letterSpacing: 0),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(Icons.circle, size: 4, color: KColor.black54),
                              ),
                              Icon(
                                widget.feedData?.feedPrivacy == FeedPrivacy.PUBLIC
                                    ? Icons.public
                                    : widget.feedData?.feedPrivacy == FeedPrivacy.FRIENDS
                                        ? Icons.group
                                        : Icons.lock,
                                size: 14,
                                color: KColor.black54,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: KSize.getHeight(context, 10)),
          if (widget.feedData?.feedTxt != null)
            widget.feedData?.isBackground == 1
                ? Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    height: 250,
                    decoration: BoxDecoration(
                        gradient: KColor
                            .gradientsColor[KColor.feedBackGroundGradientColors.indexWhere((element) => element == widget.feedData?.bgColor) + 2]),
                    child: Text(
                      widget.feedData!.feedTxt ?? '',
                      style: KTextStyle.headline4.copyWith(color: KColor.whiteConst),
                    ),
                  )
                : Text(
                    widget.feedData!.feedTxt!,
                    style: KTextStyle.bodyText2.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                  ),
          // TODO :: Meta data would never be null actually
          // if (widget.feedData!.metaData != null && widget.feedData!.metaData!.linkMeta != null)
          //   FeedLinkPreviewWidget(widget.feedData!.metaData!.linkMeta!),
          SizedBox(height: KSize.getHeight(context, widget.feedData?.isBackground == 1 ? 0 : 10)),

          // if (widget.feedData.isAdPost) FeedAdPreview(widget.feedData.campaign),
          ///  feed poll
          if (widget.feedData?.poll != null)
            PollCard(
              feedData: widget.feedData,
              feedType: widget.feedType,
              feedId: widget.feedId,
              isShare: widget.isShare,
            ),
        ],
      ),
    );
  }
}
