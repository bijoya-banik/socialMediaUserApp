import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/comment/comment_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/feed_details_controller.dart';
import 'package:buddyscripts/controller/feed/feed_reacted_users_controller.dart';
import 'package:buddyscripts/custom_plugin/video_thumbnail_generator.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/reaction_button/reaction_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/feed_ad_preview.dart';
import 'package:buddyscripts/views/global_components/feed_link_preview.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_image_slider.dart';
import 'package:buddyscripts/views/global_components/k_video_player.dart';
import 'package:buddyscripts/views/screens/home/components/poll_card.dart';
import 'package:buddyscripts/views/screens/home/components/reaction_box/reaction_emoji_component.dart';
import 'package:buddyscripts/views/screens/home/components/share_options_modal.dart';
import 'package:buddyscripts/views/screens/home/components/shared_feed_card.dart';
import 'package:buddyscripts/views/screens/home/edit_feed_screen.dart';
import 'package:buddyscripts/views/screens/home/reacted_users_count_screen.dart';
import 'package:buddyscripts/views/screens/messages/components/file_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/global_components/k_image_view.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/home/components/comment_modal.dart';
import 'package:buddyscripts/views/screens/home/report_feed_screen.dart';
import 'package:buddyscripts/views/screens/home/feed_details_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

import 'reaction_box/reaction_button_toggle.dart';

class FeedCard extends ConsumerStatefulWidget {
  final bool onTapNavigate;
  final FeedModel? feedData;
  final FeedType? feedType;
  final bool showCommentModal;
  final int? id;

  const FeedCard(
      {Key? key,
      this.onTapNavigate = true,
      this.feedData,
      this.feedType,
      this.showCommentModal = false,
      this.id})
      : super(key: key);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends ConsumerState<FeedCard> {
  bool animate = false;

  @override
  void initState() {
    super.initState();

    /// WHen <User Name> commented on your post is tapped, we need to
    /// open the post details screen and immediately open comment sheet.
    /// Below code is for that purpose
    if (widget.showCommentModal) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ref.read(commentsProvider.notifier).fetchComments(widget.feedData!.id!);
        _showCommentSheet(widget.feedData!, widget.feedType!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.feedData!.activityType == "feed" ||
            widget.feedData!.activityType == "share" ||
            widget.feedData!.isAdPost == false ||
            widget.feedData!.campaign == null
        ?
        //  Container():
        GestureDetector(
            onTap: () {
              if (widget.onTapNavigate) {
                ref
                    .read(feedDetailsProvider.notifier)
                    .fetchFeedDetails(widget.feedData!.id!);
                Navigator.of(context, rootNavigator: true).push(
                    (CupertinoPageRoute(
                        builder: (context) => const FeedDetailsScreen())));
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                  left: KSize.getWidth(context, 0),
                  right: KSize.getWidth(context, 0),
                  bottom: 10),
              decoration: BoxDecoration(
                  color: KColor.textBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: KSize.getHeight(context, 15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              UserProfilePicture(
                                avatarRadius: 20,
                                iconSize: 19.5,
                                profileURL: widget.feedData!.pic,
                                slug: widget.feedData!.slug,
                                userId: widget.feedData!.userId,
                                type: widget.feedData!.activityType,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.feedData?.feelings == null
                                        ? UserName(
                                            slug: widget.feedData!.slug,
                                            name: widget.feedType ==
                                                        FeedType.GROUP ||
                                                    widget.feedType ==
                                                        FeedType.EVENT
                                                ? widget.feedData!.user!
                                                        .firstName! +
                                                    " " +
                                                    widget.feedData!.user!
                                                        .lastName!
                                                : widget.feedData!.name,
                                            userId: widget.feedData!.userId,
                                            type: widget.feedData!.activityType,
                                            overflowVisible: true,
                                            backgroundColor:
                                                KColor.textBackground,
                                          )
                                        : Wrap(
                                            children: [
                                              UserName(
                                                slug: widget.feedData!.slug,
                                                name: widget.feedType ==
                                                            FeedType.GROUP ||
                                                        widget.feedType ==
                                                            FeedType.EVENT
                                                    ? widget.feedData!.user!
                                                            .firstName! +
                                                        " " +
                                                        widget.feedData!.user!
                                                            .lastName!
                                                    : widget.feedData!.name,
                                                userId: widget.feedData!.userId,
                                                type: widget
                                                    .feedData!.activityType,
                                                overflowVisible: true,
                                                backgroundColor:
                                                    KColor.textBackground,
                                              ),
                                              if (widget.feedData!.feelings!
                                                  .icon!.isNotEmpty)
                                                // Padding(
                                                //   padding: const EdgeInsets.symmetric(horizontal: 1),
                                                //   child: Image.network(
                                                //     widget.feedData!.feelings!.icon!,
                                                //     height: 20,
                                                //     width: 25,
                                                //   ),
                                                // ),
                                                Text(
                                                    " " +
                                                        widget.feedData!
                                                            .feelings!.text!,
                                                    style: KTextStyle.subtitle1
                                                        .copyWith(
                                                            color:
                                                                KColor.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                            ],
                                          ),
                                    SizedBox(
                                        height: KSize.getHeight(context, 2.5)),
                                    widget.feedData!.isAdPost!
                                        ? Text('Sponsored',
                                            style: KTextStyle.bodyText2
                                                .copyWith(
                                                    color: KColor.black54,
                                                    fontSize: 12,
                                                    letterSpacing: 0))
                                        : Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              if (widget.feedData!
                                                          .activityType ==
                                                      'group' &&
                                                  widget.feedType !=
                                                      FeedType.GROUP)
                                                Text(
                                                  '${widget.feedData!.user!.firstName} ${widget.feedData!.user!.lastName}',
                                                  style: KTextStyle.bodyText2
                                                      .copyWith(
                                                          color: KColor.black54,
                                                          fontSize: 12,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              if (widget.feedData!
                                                          .activityType ==
                                                      'event' &&
                                                  widget.feedType !=
                                                      FeedType.EVENT)
                                                Text(
                                                  '${widget.feedData!.user!.firstName} ${widget.feedData!.user!.lastName}',
                                                  style: KTextStyle.bodyText2
                                                      .copyWith(
                                                          color: KColor.black54,
                                                          fontSize: 12,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              if (widget.feedData!
                                                          .activityType ==
                                                      'group' ||
                                                  widget.feedData!
                                                          .activityType ==
                                                      'event')
                                                Visibility(
                                                  visible: widget.feedType !=
                                                          FeedType.GROUP &&
                                                      widget.feedType !=
                                                          FeedType.EVENT,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: Icon(Icons.circle,
                                                        size: 4,
                                                        color: KColor.black54),
                                                  ),
                                                ),
                                              Text(
                                                DateTimeService.timeAgoLocal(
                                                        widget
                                                            .feedData!.createdAt
                                                            .toString()) ??
                                                    '',
                                                style: KTextStyle.bodyText2
                                                    .copyWith(
                                                        color: KColor.black54,
                                                        fontSize: 12,
                                                        letterSpacing: 0),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Icon(Icons.circle,
                                                    size: 4,
                                                    color: KColor.black54),
                                              ),
                                              Icon(
                                                widget.feedData!.feedPrivacy ==
                                                        FeedPrivacy.PUBLIC
                                                    ? Icons.public
                                                    : widget.feedData!
                                                                .feedPrivacy ==
                                                            FeedPrivacy.FRIENDS
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
                      ),
                      PopupMenuButton(
                        tooltip: '',
                        onSelected: (selected) {
                          if (selected == 'report') {
                            Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute(
                                    builder: (context) => ReportFeedScreen(
                                        widget.feedData, "feed")));
                          }
                          if (selected == 'edit') {
                            Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute(
                                    builder: (context) => EditFeedScreen(
                                        feed: widget.feedData,
                                        feedType: widget.feedType)));
                          }
                          if (selected == 'save') {
                            widget.feedData?.savedPosts != null
                                ? ref.read(feedProvider.notifier).unsaveFeed(
                                    widget.feedData!.id!, widget.feedType!)
                                : ref.read(feedProvider.notifier).saveFeed(
                                    widget.feedData!.id!, widget.feedType!);
                          }
                          if (selected == 'delete') {
                            _deleteConfirmationDialog(
                                widget.feedData!, widget.feedType!);
                          }
                          // if (selected == 'block_user') {
                          //   KDialog.kShowDialog(
                          //       context,
                          //       ConfirmationDialogContent(
                          //           titleShow: true,
                          //           title: "Block ${widget.feedData!.user!.firstName} ${widget.feedData!.user!.lastName}?",
                          //           titleContent:
                          //               '${widget.feedData!.user!.firstName} ${widget.feedData!.user!.lastName} will no longer be able to:\n\n • See your posts on your timeline\n • Tag you\n • Invite you to events or groups\n • Message you\n • Add you as a friend\n\nIf you\'re friends, blocking ${widget.feedData!.user!.firstName} ${widget.feedData!.user!.lastName} will also unfriend him/her',
                          //           buttonTextYes: "Block",
                          //           buttonTextNo: "Cancel",
                          //           onPressedCallback: () => {
                          //                 Navigator.pop(context),
                          //                 KDialog.kShowDialog(
                          //                   context,
                          //                   const ProcessingDialogContent("Processing..."),
                          //                   barrierDismissible: false,
                          //                 ),
                          //                 ref
                          //                     .read(blockUserProvider.notifier)
                          //                     .block(widget.feedData!.user!.id, feedType: widget.feedType, feed: widget.feedData, route: "feedCard")
                          //               }),
                          //       useRootNavigator: false);
                          // }
                          if (selected == 'hide') {
                            _hideConfirmationDialog(
                                widget.feedData!, widget.feedType!);
                          }
                        },
                        color: AppMode.darkMode
                            ? KColor.feedActionCircle
                            : KColor.appBackground,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        offset: const Offset(0, -10),
                        icon: Icon(MaterialIcons.more_vert,
                            color: KColor.black87),
                        itemBuilder: (_) => <PopupMenuItem<String>>[
                          if (widget.feedData!.userId != getIntAsync(USER_ID))
                            PopupMenuItem<String>(
                                value: "report",
                                child: Text('Report',
                                    style: KTextStyle.subtitle2.copyWith(
                                        color: KColor.black87,
                                        fontWeight: FontWeight.normal))),
                          PopupMenuItem<String>(
                              value: "save",
                              child: Text(
                                  widget.feedData!.savedPosts != null
                                      ? 'Unsave'
                                      : 'Save',
                                  style: KTextStyle.subtitle2.copyWith(
                                      color: KColor.black87,
                                      fontWeight: FontWeight.normal))),
                          if (widget.feedData!.isFeedEdit!)
                            if (widget.feedData!.poll == null ||
                                (widget.feedData!.poll != null &&
                                    widget.feedData!.poll!.voteByAnyOne ==
                                        'no'))
                              PopupMenuItem<String>(
                                  value: "edit",
                                  child: Text('Edit',
                                      style: KTextStyle.subtitle2.copyWith(
                                          color: KColor.black87,
                                          fontWeight: FontWeight.normal))),
                          if (widget.feedData!.isFeedEdit!)
                            PopupMenuItem<String>(
                                value: "delete",
                                child: Text('Delete',
                                    style: KTextStyle.subtitle2.copyWith(
                                        color: KColor.black87,
                                        fontWeight: FontWeight.normal))),
                          // if ((widget.feedData!.activityType == "feed" || widget.feedData!.activityType == "group") &&
                          //     widget.feedData!.userId != getIntAsync(USER_ID))
                          //   PopupMenuItem<String>(
                          //       value: "block_user",
                          //       child: Text('Block User', style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal))),
                          if (widget.feedData!.userId != getIntAsync(USER_ID))
                            PopupMenuItem<String>(
                                value: "hide",
                                child: Text('Hide',
                                    style: KTextStyle.subtitle2.copyWith(
                                        color: KColor.black87,
                                        fontWeight: FontWeight.normal))),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: KSize.getHeight(context, 10)),
                  widget.feedData!.activityType == 'share'
                      ? widget.feedData!.share == null
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    widget.feedData?.isBackground == 0 ? 10 : 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.feedData!.feedTxt != null)
                                    Text(
                                      widget.feedData!.feedTxt ?? "",
                                      style: KTextStyle.bodyText2.copyWith(
                                        height: KSize.getHeight(context, 1.5),
                                        color: KColor.black,
                                      ),
                                    ),
                                  SizedBox(
                                      height: KSize.getHeight(context, 10)),
                                  const KContentUnvailableComponent(
                                      isUnavailablePost: true),
                                ],
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.feedData?.isBackground == 0
                                      ? 10
                                      : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.feedData!.feedTxt != null)
                                    Text(
                                      widget.feedData!.feedTxt!,
                                      style: KTextStyle.bodyText2.copyWith(
                                        height: KSize.getHeight(context, 1.5),
                                        color: KColor.black,
                                      ),
                                    ),
                                  SizedBox(
                                      height: KSize.getHeight(context, 10)),
                                  SharedFeedCard(
                                    feedData: widget.feedData!.share,
                                    feedType: widget.feedType,
                                    feedId: widget.feedData!.id,
                                  ),
                                  SizedBox(height: KSize.getHeight(context, 5)),
                                ],
                              ),
                            )
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  widget.feedData?.isBackground == 0 ? 10 : 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.feedData?.feedTxt != null)
                                widget.feedData?.isBackground == 0
                                    ? InkWell(
                                        onTap: () {
                                          if (widget.feedData?.metaData
                                                  ?.linkMeta !=
                                              null) {
                                            launch(widget.feedData!.metaData!
                                                .linkMeta!.url!);
                                          }
                                        },
                                        child: Text(
                                          widget.feedData!.feedTxt ?? '',
                                          style: KTextStyle.bodyText2.copyWith(
                                              color: KColor.black,
                                              height: KSize.getHeight(
                                                  context, 1.5)),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          if (widget.feedData?.metaData
                                                  ?.linkMeta !=
                                              null) {
                                            launch(widget.feedData!.metaData!
                                                .linkMeta!.url!);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 250,
                                          decoration: BoxDecoration(
                                              gradient: KColor
                                                  .gradientsColor[KColor
                                                      .feedBackGroundGradientColors
                                                      .indexWhere((element) =>
                                                          element ==
                                                          widget.feedData
                                                              ?.bgColor) +
                                                  2]),
                                          child: Text(
                                            widget.feedData!.feedTxt ?? '',
                                            textAlign: TextAlign.center,
                                            style: KTextStyle.headline4
                                                .copyWith(
                                                    color: KColor.whiteConst),
                                          ),
                                        )),
                              //  if (widget.feedData?.metaData?.linkMeta != null) FeedLinkPreviewWidget(widget.feedData!.metaData!.linkMeta!),
                              SizedBox(height: KSize.getHeight(context, 10)),
                              /*
                          * Feed assets - images/videos
                        */
                              if (widget.feedData?.fileType == 'application')
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      alignment: WrapAlignment.start,
                                      children: List.generate(
                                          widget.feedData!.files!.length,
                                          (index) {
                                        return SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: FilePreview(
                                            widget.feedData!.files![index]
                                                    .originalName ??
                                                "",
                                            widget.feedData!.files![index]
                                                    .fileLoc ??
                                                "",
                                            true,
                                            '',
                                            isFeed: true,
                                          ),
                                        );
                                      })),
                                ),
                              widget.feedData?.fileType == 'video'
                                  ? widget.feedType == FeedType.DETAILS
                                      ? KVideoPlayer(
                                          widget.feedData!.files![0].fileLoc)
                                      : ThumbnailImage(
                                          videoUrl: widget
                                              .feedData!.files![0].fileLoc,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: KSize.getHeight(context, 200),
                                        )
                                  : Container(),
                              if (widget.feedData!.fileType == 'image')
                                widget.feedData!.files!.length == 1
                                    ? GestureDetector(
                                        onTap: () {
                                          print(widget
                                              .feedData!.files![0].fileLoc);
                                          Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      KImageView(
                                                          url: widget
                                                              .feedData!
                                                              .files![0]
                                                              .fileLoc)));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(6)),
                                            child: Image.network(
                                              widget
                                                  .feedData!.files![0].fileLoc!,
                                              height:
                                                  KSize.getHeight(context, 250),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              // cacheHeight: KSize.getHeight(context, 250).ceil(),
                                              // cacheWidth: MediaQuery.of(context).size.width.ceil(),
                                              cacheHeight:
                                                  KSize.getHeight(context, 1000)
                                                      .ceil(),
                                              cacheWidth:
                                                  (MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          2)
                                                      .ceil(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: Center(
                                          child: Wrap(
                                            spacing: 5,
                                            alignment: WrapAlignment.center,
                                            children: List.generate(
                                                widget.feedData!.files!.length,
                                                (index) {
                                              return index >= 4
                                                  ? Container()
                                                  : GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push<void>(
                                                                CupertinoPageRoute(
                                                          builder: (context) =>
                                                              KImageSliderView(
                                                            imagesList: List<
                                                                    String>.from(
                                                                widget.feedData!
                                                                    .files!
                                                                    .map((model) =>
                                                                        model
                                                                            .fileLoc)),
                                                            initialPage: index,
                                                          ),
                                                        ));
                                                      },
                                                      child: Container(
                                                        height: KSize.getHeight(
                                                            context, 150),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        margin: const EdgeInsets
                                                            .only(bottom: 5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: KColor
                                                                    .appBackground)),
                                                        child: Stack(
                                                          children: [
                                                            Image.network(
                                                              widget
                                                                  .feedData!
                                                                  .files![index]
                                                                  .fileLoc!,
                                                              height: KSize
                                                                  .getHeight(
                                                                      context,
                                                                      150),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              cacheHeight: KSize
                                                                      .getHeight(
                                                                          context,
                                                                          600)
                                                                  .ceil(),
                                                              cacheWidth: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      1.2)
                                                                  .ceil(),
                                                              // cacheHeight: KSize.getHeight(context, 300).ceil(),
                                                              // cacheWidth: (MediaQuery.of(context).size.width * 0.8).ceil(),
                                                              fit: BoxFit.cover,
                                                              loadingBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null)
                                                                  return child;
                                                                return const Center(
                                                                    child:
                                                                        CupertinoActivityIndicator());
                                                              },
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                                return Icon(
                                                                    Icons.error,
                                                                    color: AppMode.darkMode
                                                                        ? KColor
                                                                            .white
                                                                        : KColor
                                                                            .black);
                                                              },
                                                            ),
                                                            if (index == 3 &&
                                                                widget
                                                                        .feedData!
                                                                        .files!
                                                                        .length >
                                                                    4)
                                                              Container(
                                                                height: KSize
                                                                    .getHeight(
                                                                        context,
                                                                        150),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                decoration: BoxDecoration(
                                                                    color: KColor
                                                                        .blackConst
                                                                        .withOpacity(
                                                                            0.4)),
                                                                child: Center(
                                                                  child: Text(
                                                                    '+${widget.feedData!.files!.length - 3}',
                                                                    style: KTextStyle
                                                                        .headline5
                                                                        .copyWith(
                                                                            color:
                                                                                KColor.whiteConst),
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
                              if (widget.feedData!.isAdPost!)
                                FeedAdPreview(widget.feedData!.campaign!),
                            ],
                          ),
                        ),

                  /////  feed poll
                  if (widget.feedData?.poll != null)
                    PollCard(
                      feedData: widget.feedData,
                      feedType: widget.feedType,
                      feedId: widget.feedData?.id,
                    ),

                  /*
              * Feed like, comment, share section
            */
                  //  if(  (widget.feedData!.likeCount!=0 || widget.feedData!.likeCount!=null)
                  //     && (widget.feedData!.commentCount != 0 ||widget.feedData!.commentCount != null)
                  //   ) // Container():

                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: (widget.feedData!.likeCount == 0 &&
                                widget.feedData!.commentCount == 0)
                            ? 0
                            : 10,
                        horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.feedData!.likeCount != 0)
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                ref
                                    .read(feedReactionTypesProvider.notifier)
                                    .fetchFeedReactionTypes(
                                        widget.feedData!.id!);
                                ref
                                    .read(feedReactedUsersProvider.notifier)
                                    .fetchFeedReactedUsers(
                                        widget.feedData!.id!);
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            ReactedUsersCountScreen(
                                                feedId: widget.feedData!.id!)));
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: widget.feedData!.likeType!.length ==
                                            1
                                        ? 25
                                        : widget.feedData!.likeType!.length == 2
                                            ? 40
                                            : 60,
                                    child: Stack(
                                      children: [
                                        ReactionEmojiComponent(
                                            reactionType: widget.feedData!
                                                .likeType![0].reactionType),
                                        if (widget.feedData!.likeType!.length >=
                                            2)
                                          Positioned(
                                              left: 15,
                                              child: ReactionEmojiComponent(
                                                  reactionType: widget
                                                      .feedData!
                                                      .likeType![1]
                                                      .reactionType)),
                                        if (widget.feedData!.likeType!.length >=
                                            3)
                                          Positioned(
                                              left: 32,
                                              child: ReactionEmojiComponent(
                                                  reactionType: widget
                                                      .feedData!
                                                      .likeType![2]
                                                      .reactionType)),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    widget.feedData!.like == null
                                        ? '${widget.feedData!.likeCount}'
                                        : widget.feedData!.likeCount == 1
                                            ? 'You'
                                            : widget.feedData!.likeCount == 2
                                                ? 'You and 1 other'
                                                : 'You and ${widget.feedData!.likeCount - 1} others',
                                    style: KTextStyle.bodyText2.copyWith(
                                        color: KColor.black54,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (widget.feedData!.commentCount != 0)
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(commentsProvider.notifier)
                                  .fetchComments(widget.feedData!.id!);
                              _showCommentSheet(
                                  widget.feedData!, widget.feedType!);
                            },
                            child: Text(
                              widget.feedData!.commentCount == 1
                                  ? '1 comment'
                                  : '${widget.feedData!.commentCount} comments',
                              style: KTextStyle.bodyText2.copyWith(
                                  color: KColor.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                        vertical: (widget.feedData!.likeCount == 0 &&
                                widget.feedData!.commentCount == 0)
                            ? 0
                            : 5,
                      ),
                      child: Divider(
                          height: 0, color: KColor.black.withOpacity(0.2))),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: KColor.textBackground,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(feedProvider.notifier).likeFeed(
                                  feedId: widget.feedData!.id,
                                  feedType: widget.feedType,
                                  isLike: widget.feedData?.like == null
                                      ? true
                                      : false,
                                  reactionType: 'LIKE',
                                  action: 'deleteOrCreate',
                                );

                            // print('Selected value: $value, isChecked: $isChecked, reaction : $reaction');
                            // print('reaction : ${reaction.value}');
                            // print('selectedReaction = $selectedReaction');
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .2,
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  children: [
                                    widget.feedData!.like == null
                                        ? CircleAvatar(
                                            radius: 17,
                                            backgroundColor:
                                                KColor.feedActionCircle,
                                            child: Icon(
                                              FontAwesome.thumbs_o_up,
                                              color: KColor.feedActionButton,
                                              size: 18,
                                            ))
                                        : CircleAvatar(
                                            radius: 17,
                                            backgroundColor:
                                                KColor.feedActionCircle,
                                            child: Icon(
                                              FontAwesome.thumbs_up,
                                              color: KColor.reactionBlue,
                                              size: 18,
                                            )),
                                    const SizedBox(width: 6),
                                    Text('Like',
                                        style: KTextStyle.bodyText2.copyWith(
                                            color: widget.feedData?.like == null
                                                ? KColor.black54
                                                : KColor.reactionBlue,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                )
                                // ReactionButtonToggle<String>(
                                //   itemScale: 0.5,
                                //   boxColor: AppMode.darkMode ? KColor.appBackground : KColor.whiteConst,
                                //   onReactionChanged: (String? value, bool isChecked, reaction) {
                                //     print('Selected value: $value, isChecked: $isChecked, reaction : $reaction');
                                //     print('reaction : ${reaction.value}');

                                //     ref.read(feedProvider.notifier).likeFeed(
                                //         feedId: widget.feedData!.id,
                                //         feedType: widget.feedType,
                                //         isLike: false,
                                //         reactionType: value!.toUpperCase(),
                                //         action: 'update');
                                //     setState(() {});
                                //   },
                                //   reactions: [
                                //     ReactionModel<String>(
                                //       value: 'Like',
                                //       title: const ReactionBoxTitle('Like'),
                                //       previewIcon: const ReactionsPreviewIcon('assets/images/like.gif'),
                                //       icon: Row(
                                //         children: [
                                //           widget.feedData!.like == null
                                //               ? CircleAvatar(
                                //                   radius: 17,
                                //                   backgroundColor: KColor.feedActionCircle,
                                //                   child: Icon(
                                //                     FontAwesome.thumbs_o_up,
                                //                     color: KColor.feedActionButton,
                                //                     size: 18,
                                //                   ))
                                //               : widget.feedData!.like?.reactionType == 'LIKE'
                                //                   ? CircleAvatar(
                                //                       radius: 17,
                                //                       backgroundColor: KColor.feedActionCircle,
                                //                       child: Icon(
                                //                         FontAwesome.thumbs_up,
                                //                         color: KColor.reactionBlue,
                                //                         size: 18,
                                //                       ))
                                //                   : ReactionsIcon(
                                //                       widget.feedData?.like?.reactionType == 'LOVE'
                                //                           ? AssetPath.loveReaction
                                //                           : widget.feedData?.like?.reactionType == 'HAHA'
                                //                               ? AssetPath.hahaReaction
                                //                               : widget.feedData?.like?.reactionType == 'WOW'
                                //                                   ? AssetPath.wowReaction
                                //                                   : widget.feedData?.like?.reactionType == 'SAD'
                                //                                       ? AssetPath.sadReaction
                                //                                       : AssetPath.angryReaction,
                                //                       const Text(''),
                                //                     ),
                                //           const SizedBox(width: 6),
                                //           Text(
                                //             widget.feedData?.like == null
                                //                 ? 'Like'
                                //                 : widget.feedData?.like!.reactionType == 'LOVE'
                                //                     ? 'Love'
                                //                     : widget.feedData?.like!.reactionType == 'HAHA'
                                //                         ? 'Haha'
                                //                         : widget.feedData?.like!.reactionType == 'WOW'
                                //                             ? 'Wow'
                                //                             : widget.feedData?.like!.reactionType == 'SAD'
                                //                                 ? 'Sad'
                                //                                 : widget.feedData?.like!.reactionType == 'ANGRY'
                                //                                     ? 'Angry'
                                //                                     : 'Like',
                                //             style: KTextStyle.bodyText2.copyWith(
                                //                 color: widget.feedData?.like == null
                                //                     ? KColor.black54
                                //                     : widget.feedData?.like!.reactionType == 'LOVE'
                                //                         ? KColor.red
                                //                         : widget.feedData?.like!.reactionType == 'HAHA'
                                //                             ? KColor.reactionYellow
                                //                             : widget.feedData?.like!.reactionType == 'WOW'
                                //                                 ? KColor.reactionYellow
                                //                                 : widget.feedData?.like!.reactionType == 'SAD'
                                //                                     ? KColor.reactionYellow
                                //                                     : widget.feedData?.like!.reactionType == 'ANGRY'
                                //                                         ? KColor.reactionOrange
                                //                                         : KColor.reactionBlue,
                                //                 fontWeight: FontWeight.w500),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //     ReactionModel<String>(
                                //       value: 'Love',
                                //       title: const ReactionBoxTitle('Love'),
                                //       previewIcon: const ReactionsPreviewIcon('assets/images/love.gif'),
                                //       icon: ReactionsIcon(
                                //         'assets/images/love2.png',
                                //         Text('Love', style: KTextStyle.subtitle2.copyWith(color: KColor.red)),
                                //       ),
                                //     ),
                                //     ReactionModel<String>(
                                //       value: 'Haha',
                                //       title: const ReactionBoxTitle('Haha'),
                                //       previewIcon: const ReactionsPreviewIcon('assets/images/haha.gif'),
                                //       icon: ReactionsIcon(
                                //         'assets/images/haha2.png',
                                //         Text('Haha', style: KTextStyle.subtitle2.copyWith(color: KColor.reactionYellow)),
                                //       ),
                                //     ),
                                //     ReactionModel<String>(
                                //       value: 'Wow',
                                //       title: const ReactionBoxTitle('Wow'),
                                //       previewIcon: const ReactionsPreviewIcon('assets/images/wow.gif'),
                                //       icon: ReactionsIcon(
                                //         'assets/images/wow2.png',
                                //         Text('Wow', style: KTextStyle.subtitle2.copyWith(color: KColor.reactionYellow)),
                                //       ),
                                //     ),
                                //     ReactionModel<String>(
                                //       value: 'Sad',
                                //       title: const ReactionBoxTitle('Sad'),
                                //       previewIcon: const ReactionsPreviewIcon('assets/images/sad.gif'),
                                //       icon: ReactionsIcon(
                                //         'assets/images/sad2.png',
                                //         Text('Sad', style: KTextStyle.subtitle2.copyWith(color: KColor.reactionYellow)),
                                //       ),
                                //     ),
                                //     ReactionModel<String>(
                                //       value: 'Angry',
                                //       title: const ReactionBoxTitle('Angry'),
                                //       previewIcon: const ReactionsPreviewIcon('assets/images/angry.gif'),
                                //       icon: ReactionsIcon(
                                //         'assets/images/angry2.png',
                                //         Text('Angry', style: KTextStyle.subtitle2.copyWith(color: KColor.reactionOrange)),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                ),
                          ),
                        ),
                        // /////////////////////////////////////////////////////////////////////////
                        Material(
                          color: KColor.textBackground,
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(commentsProvider.notifier)
                                  .fetchComments(widget.feedData!.id!);
                              _showCommentSheet(
                                  widget.feedData!, widget.feedType!);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8, bottom: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 17,
                                    backgroundColor: KColor.feedActionCircle,
                                    child: Icon(
                                      FontAwesome5.comment_alt,
                                      color: KColor.feedActionButton,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Comment',
                                    style: KTextStyle.bodyText2.copyWith(
                                        color: KColor.black54,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: KColor.textBackground,
                          child: InkWell(
                            onTap: () {
                              _showOptionsModal(context, widget.feedData,
                                  widget.feedType, widget.id);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8, bottom: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 17,
                                    backgroundColor: KColor.feedActionCircle,
                                    child: Transform(
                                      transform: Matrix4.rotationY(math.pi),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        CupertinoIcons.reply,
                                        size: 20,
                                        color: KColor.feedActionButton,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Share',
                                    style: KTextStyle.bodyText2.copyWith(
                                        color: KColor.black54,
                                        fontWeight: FontWeight.w500),
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
              ),
            ),
          )
        : Container();
  }

  _deleteConfirmationDialog(FeedModel feed, FeedType feedType) async {
    return (await showPlatformDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) => ConfirmationDialogContent(
          titleContent: 'Are you sure you want to delete this post?',
          onPressedCallback: () {
            Navigator.pop(context);
            KDialog.kShowDialog(
                context, const ProcessingDialogContent('Deleting...'),
                barrierDismissible: false);
            ref
                .read(feedProvider.notifier)
                .deleteFeed(feed: feed, feedType: feedType);
          }),
    ));
  }

  _hideConfirmationDialog(FeedModel feed, FeedType feedType) async {
    return (await showPlatformDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) => ConfirmationDialogContent(
          titleContent: 'Are you sure you want to hide this post?',
          onPressedCallback: () {
            Navigator.pop(context);
            KDialog.kShowDialog(
                context, const ProcessingDialogContent('Hiding Post...'),
                barrierDismissible: false);
            ref
                .read(feedProvider.notifier)
                .hideFeed(feed: feed, feedType: feedType);
          }),
    ));
  }

  void _showCommentSheet(FeedModel feedData, FeedType feedType) async {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isDismissible: false,
        elevation: 5,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.white,
        builder: (context) {
          return CommentModal(feedData, feedType);
        });
  }

  void _showOptionsModal(context, feed, feedType, id) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isDismissible: true,
        elevation: 5,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: KColor.white,
        builder: (context) {
          return ShareOptionsModal(feed: feed, feedType: feedType, id: id);
        });
  }
}

class ReactionsIcon extends StatelessWidget {
  final String? path;
  final Text? text;
  const ReactionsIcon(this.path, this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KColor.transparent,
      child: Row(
        children: <Widget>[
          Image.asset(path!, height: 27),
          const SizedBox(width: 5),
          text!,
        ],
      ),
    );
  }
}

class ReactionsPreviewIcon extends StatelessWidget {
  final String path;
  const ReactionsPreviewIcon(this.path, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
      child: Image.asset(path, height: 40),
    );
  }
}

class ReactionBoxTitle extends StatelessWidget {
  final String title;
  const ReactionBoxTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
      decoration: BoxDecoration(
        color: KColor.blackConst.withOpacity(0.35),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        title,
        style: KTextStyle.caption.copyWith(
          color: KColor.whiteConst.withOpacity(0.75),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
