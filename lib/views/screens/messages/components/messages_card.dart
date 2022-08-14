import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/custom_plugin/video_thumbnail_generator.dart';
import 'package:buddyscripts/models/chats/chat_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/k_image_slider.dart';
import 'package:buddyscripts/views/global_components/k_image_view.dart';
import 'package:buddyscripts/views/global_components/k_video_player.dart';
import 'package:buddyscripts/views/global_components/k_widget_size.dart';
import 'package:buddyscripts/views/screens/messages/components/file_preview.dart';
import 'package:buddyscripts/views/screens/messages/components/reply_widget_card.dart';
import 'package:buddyscripts/views/screens/messages/components/status_link_preview_card.dart';
import 'package:buddyscripts/views/screens/messages/components/status_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class MessagesCard extends StatefulWidget {
  final ChatList chat;
  final int isGroup;
  final int? conversationId;
  final AnimationController? animationController;
  final bool showMoreMargin;

  const MessagesCard(
    this.chat,
    this.isGroup, {
    Key? key,
    this.animationController,
    this.showMoreMargin = true,
    this.conversationId,
  }) : super(key: key);

  @override
  _MessagesCardState createState() => _MessagesCardState();
}

class _MessagesCardState extends State<MessagesCard> {
  int replyMsgLength = 0;
  int msgLength = 0;

  @override
  void initState() {
    super.initState();

    msgLength = widget.chat.msg!.length;
    if (widget.chat.replyMsg != null) {
      replyMsgLength = widget.chat.replyMsg.length;
    } else {
      replyMsgLength = 0;
    }
  }

  Size? textSize;
  Size? replyMsgSize;
  dynamic replyWidth = 0.0;
  dynamic textWidth = 0.0;
  bool showDateTime = false;

  @override
  Widget build(BuildContext context) {
    // print(' TEST: widget.animationController = ${widget.animationController}');
    bool isSelf = widget.chat.userId == getIntAsync(USER_ID);
    return
        // widget.animationController != null
        //     ? SlideTransition(
        //         position: Tween<Offset>(
        //           begin: Offset(0.0, 1.0),
        //           end: Offset(0.0, 0.0),
        //         ).animate(CurvedAnimation(
        //           parent: widget.animationController,
        //           curve: Curves.easeIn,
        //         )),
        //         // SizeTransition(
        //         //     sizeFactor: CurvedAnimation(parent: widget.animationController, curve: Curves.easeIn),
        //         //     axisAlignment: 0.0,
        //         child: _buildMessageCard(isSelf, context),
        //       )
        //     :

        Column(
      children: [
        if (showDateTime)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 12),
            child: Text(
              DateTimeService.convert(widget.chat.createdAt, isDateWithTime: true),
              textAlign: TextAlign.center,
              style: KTextStyle.caption.copyWith(color: KColor.timeGreyText, fontSize: 12, letterSpacing: 0),
            ),
          ),
        _buildMessageCard(isSelf, context),
      ],
    );
  }

  Widget _buildMessageCard(bool isSelf, BuildContext context) {
    return Align(
        alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
            onTap: () {
              setState(() {
                showDateTime = !showDateTime;
              });
            },
            onLongPress: () {
              if (widget.isGroup == 1 && widget.chat.userId == getIntAsync(USER_ID) || widget.isGroup == 0) {
                _showOptionsModal(context, widget.chat.id, inboxId: widget.conversationId, isGroup: widget.isGroup == 0 ? false : true);
              }
            },
            child: Container(
              padding: const EdgeInsets.only(top: 3, left: 3, right: 3),
              margin: EdgeInsets.only(top: widget.chat.replyId != null ? 5 : 0),
              child: Column(
                children: [
                  Stack(
                    alignment: isSelf ? Alignment.bottomRight : Alignment.bottomLeft,
                    children: [
                      if (widget.chat.replyId != null && widget.chat.replyFiles!.isEmpty) newReplyCard(isSelf, context),
                      if (widget.chat.replyId != null && widget.chat.replyFiles!.isNotEmpty) newReplyFilesCard(isSelf, context),
                      KWidgetSize(
                        onChange: (Size size) {
                          setState(() {
                            textSize = size;
                            textWidth = textSize?.height;
                          });
                        },
                        child: Positioned(
                          child: widget.chat.files!.isNotEmpty
                              ? buildFileMessage(context, isSelf)
                              : (widget.chat.chatMetaData!.feedMeta != null || widget.chat.chatMetaData!.linkMeta != null)
                                  ? buildFeedMessage(context, isSelf)
                                  : Container(
                                      margin: EdgeInsets.only(bottom: widget.showMoreMargin ? 8 : 2.5),
                                      decoration: BoxDecoration(
                                          color: KColor.feedActionCircle,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(15),
                                            topRight: Radius.circular(
                                              widget.chat.replyFiles!.isNotEmpty
                                                  ? 15
                                                  : !isSelf
                                                      ? 15
                                                      : 0,
                                            ),
                                            bottomLeft: const Radius.circular(15),
                                            bottomRight: const Radius.circular(15),
                                          )),
                                      child: buildTextMessage(context, isSelf)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }

  Container buildFileMessage(BuildContext context, bool isSelf) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      margin: EdgeInsets.only(bottom: widget.showMoreMargin ? 8 : 5),
      child: Wrap(
          spacing: KSize.getWidth(context, 15),
          children: List.generate(1, (index) {
            return Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                child: Stack(
                  children: [
                    widget.chat.files![index].type == "application"
                        ? FilePreview(
                            widget.chat.files![index].originalName ?? "",
                            widget.chat.files![index].fileLoc ?? "",
                            isSelf,
                            widget.chat.user?.firstName!,
                            isGroup: widget.isGroup == 1 ? true : false,
                          )
                        : widget.chat.files![index].type == "video"
                            ? Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                                margin: EdgeInsets.only(bottom: widget.showMoreMargin ? 8 : 2.5),
                                padding: const EdgeInsets.only(top: 9, bottom: 20, left: 9, right: 9),
                                decoration: BoxDecoration(
                                    color: KColor.feedActionCircle,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(!isSelf ? 0 : 15),
                                      topRight: Radius.circular(!isSelf ? 15 : 0),
                                      bottomLeft: const Radius.circular(15),
                                      bottomRight: const Radius.circular(15),
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isSelf) buddyNameWidget(),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      child: KVideoPlayer(
                                        widget.chat.files![index].fileLoc,
                                        isFromChat: true,
                                        isLocal: widget.chat.files![index].isLocal!,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : widget.chat.files![index].isLocal!
                                ? widget.chat.files!.length == 1
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.of(context).push<void>(
                                              CupertinoPageRoute(builder: (context) => KImageView(url: widget.chat.files![index].fileLoc)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            border: Border.all(width: 3.5, color: KColor.grey100!),
                                          ),
                                          child: ClipRRect(
                                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                                              child: widget.chat.id == -1
                                                  ? SizedBox(
                                                      height: MediaQuery.of(context).size.width * 0.7,
                                                      width: MediaQuery.of(context).size.width * 0.65,
                                                      child: const CupertinoActivityIndicator(),
                                                    )
                                                  : Container()),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: !isSelf ? KColor.feedActionCircle : KColor.appThemeColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          border: Border.all(width: 3.5, color: KColor.grey100!),
                                        ),
                                        child: Wrap(
                                          spacing: 2.5,
                                          runSpacing: 2.5,
                                          children: List.generate(
                                              widget.chat.files!.length > 4 ? 4 : widget.chat.files!.length,
                                              (ind) => Stack(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).push<void>(CupertinoPageRoute(
                                                            builder: (context) => KImageSliderView(
                                                              imagesList: List<String>.from(widget.chat.files!.map((model) => model.fileLoc)),
                                                              initialPage: index,
                                                            ),
                                                          ));
                                                        },
                                                        child: Container(
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                                          ),
                                                          child: ClipRRect(
                                                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                              child: widget.chat.id == -1
                                                                  ? SizedBox(
                                                                      height: MediaQuery.of(context).size.width *
                                                                          (widget.chat.files!.length < 4 ? 0.175 : 0.25),
                                                                      width: MediaQuery.of(context).size.width *
                                                                          (widget.chat.files!.length < 4 ? 0.175 : 0.27),
                                                                      child: const CupertinoActivityIndicator(),
                                                                    )
                                                                  : Container()

                                                              //  Image.file(
                                                              //   File(widget.chat.files[ind].fileLoc),
                                                              //   height: MediaQuery.of(context).size.width *
                                                              //       (widget.chat.files.length < 4 ? 0.175 : 0.25),
                                                              //   width: MediaQuery.of(context).size.width *
                                                              //       (widget.chat.files.length < 4 ? 0.175 : 0.27),
                                                              //   fit: BoxFit.cover,
                                                              // ),
                                                              ),
                                                        ),
                                                      ),
                                                      if (ind == 3 && widget.chat.files!.length > 4)
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                ScaleRoute(
                                                                  page: KImageSliderView(
                                                                    imagesList: List<String>.from(widget.chat.files!.map((model) => model.fileLoc)),
                                                                    initialPage: index,
                                                                  ),
                                                                ));
                                                          },
                                                          child: Container(
                                                            height: MediaQuery.of(context).size.width * 0.25,
                                                            width: MediaQuery.of(context).size.width * 0.27,
                                                            decoration: BoxDecoration(
                                                              color: KColor.black.withOpacity(0.4),
                                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                '+${widget.chat.files!.length - 3}',
                                                                style: KTextStyle.headline5.copyWith(color: KColor.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  )),
                                        ),
                                      )
                                : widget.chat.files!.length == 1
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.of(context).push<void>(
                                              CupertinoPageRoute(builder: (context) => KImageView(url: widget.chat.files![index].fileLoc)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: KColor.feedActionCircle,
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            border: Border.all(width: 3.5, color: KColor.transparent!),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (!isSelf) buddyNameWidget(),
                                              ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                child: Image.network(
                                                  //  "https://media3.giphy.com/media/JxhFGtYWZuZA0C1MdY/giphy.gif?cid=fe35a745jk0ahvyqf7e23asjqi4xc2x20qhxk19jrbsjzmuc&rid=giphy.gif&ct=g",
                                                  API.baseUrl+ widget.chat.files![index].fileLoc!,
                                                  height: MediaQuery.of(context).size.width * 0.7,
                                                  width: MediaQuery.of(context).size.width * 0.65,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: KColor.feedActionCircle,
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          border: Border.all(width: 3.5, color: KColor.feedActionCircle),
                                        ),
                                        child: Column(
                                          children: [
                                            if (!isSelf) buddyNameWidget(),
                                            Wrap(
                                              spacing: 2.5,
                                              runSpacing: 2.5,
                                              children: List.generate(
                                                  widget.chat.files!.length > 4 ? 4 : widget.chat.files!.length,
                                                  (ind) => Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.of(context).push<void>(CupertinoPageRoute(
                                                                builder: (context) => KImageSliderView(
                                                                  imagesList: List<String>.from(widget.chat.files!.map((model) => model.fileLoc)),
                                                                  initialPage: index,
                                                                ),
                                                              ));
                                                            },
                                                            child: Container(
                                                              decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                                child: Image.network(
                                                                  API.baseUrl+ widget.chat.files![ind].fileLoc!,
                                                                  height: MediaQuery.of(context).size.width *
                                                                      (widget.chat.files!.length < 4 ? 0.175 : 0.25),
                                                                  width: MediaQuery.of(context).size.width *
                                                                      (widget.chat.files!.length < 4 ? 0.175 : 0.27),
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          if (ind == 3 && widget.chat.files!.length > 4)
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    ScaleRoute(
                                                                      page: KImageSliderView(
                                                                        imagesList:
                                                                            List<String>.from(widget.chat.files!.map((model) => model.fileLoc)),
                                                                        initialPage: index,
                                                                      ),
                                                                    ));
                                                              },
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.width * 0.25,
                                                                width: MediaQuery.of(context).size.width * 0.27,
                                                                decoration: BoxDecoration(
                                                                  color: KColor.black.withOpacity(0.4),
                                                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    '+${widget.chat.files!.length - 3}',
                                                                    style: KTextStyle.headline5.copyWith(color: KColor.white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      )),
                                            ),
                                          ],
                                        ),
                                      ),
                    Positioned(
                      bottom: widget.chat.files![index].type == "video" ? 5 : -1,
                      right: 2,
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: widget.chat.files![index].type == 'application' ? KColor.transparent! : KColor.black54,
                                blurRadius: 50,
                                spreadRadius: 5,
                                offset: const Offset(-15, -20),
                              ),
                            ],
                          ),
                          child: dateAndSeenView(isSelf, isVideo: widget.chat.files![index].type == "video" ? true : false)),
                    ),
                  ],
                ));
          })),
    );
  }

  Widget newReplyCard(isSelf, BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
        margin: EdgeInsets.only(bottom: textWidth == 0 ? 0 : textWidth - 10),
        decoration: BoxDecoration(
            color: AppMode.darkMode ? KColor.grey850const : KColor.grey100const,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: Radius.circular(!isSelf
                    ? 0
                    : widget.chat.replyId != null
                        ? 15
                        : 0),
                bottomRight: const Radius.circular(15))),
        child: ReplyMessageWidget(
          message: Message(
              id: widget.chat.replyId!,
              username: "",
              message: widget.chat.replyMsg ?? "",
              replyMessage: Message(id: widget.chat.replyId!, username: "", message: "", replyMessage: null)),
          onCancelReply: null,
        ));
  }

  Widget newReplyFilesCard(isSelf, BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        margin: EdgeInsets.only(bottom: textWidth == 0 ? 0 : textWidth - 10),
        decoration: BoxDecoration(
            color: KColor.grey100,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: Radius.circular(!isSelf
                    ? 0
                    : widget.chat.replyId != null
                        ? 15
                        : 0),
                bottomRight: Radius.circular(!isSelf ? 15 : 0))),
        child: Wrap(
          spacing: 2.5,
          runSpacing: 2.5,
          children: List.generate(widget.chat.replyFiles!.length, (ind) {
            return widget.chat.replyFiles![ind].type == 'video'
                ? Container(
                    width: KSize.getHeight(context, 150),
                    height: KSize.getHeight(context, 150),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomLeft: const Radius.circular(15),
                          bottomRight: Radius.circular(!isSelf ? 15 : 0)),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: const Radius.circular(15),
                            bottomRight: Radius.circular(!isSelf ? 15 : 0)),
                        child: ThumbnailImage(
                          videoUrl: widget.chat.replyFiles![ind].fileLoc,
                          type: "reply",
                          width: KSize.getHeight(context, 150),
                          height: KSize.getHeight(context, 150),
                          fit: BoxFit.cover,
                        )),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomLeft: const Radius.circular(15),
                          bottomRight: Radius.circular(!isSelf ? 15 : 0)),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: const Radius.circular(15),
                            bottomRight: Radius.circular(!isSelf ? 15 : 0)),
                        child: widget.chat.replyFiles![ind].type == "image"
                            ? Image.network(
                                API.baseUrl+ widget.chat.replyFiles![ind].fileLoc!,
                                height: MediaQuery.of(context).size.width * 0.15,
                                width: MediaQuery.of(context).size.width * 0.15,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.file_copy,
                                      size: 20,
                                      color: KColor.adobeLogoColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(widget.chat.replyFiles![ind].originalName ?? "Attachment",
                                          overflow: TextOverflow.ellipsis, style: KTextStyle.caption.copyWith(color: KColor.black)),
                                    ),
                                  ],
                                ),
                              )),
                  );
          }),
        ));
  }

  Container buildTextMessage(BuildContext context, bool isSelf) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
          color: !isSelf ? KColor.feedActionCircle : KColor.appThemeColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.chat.replyId != null
                ? 15
                : !isSelf
                    ? 0
                    : 15),
            topRight: Radius.circular(widget.chat.replyId != null
                ? 15
                : !isSelf
                    ? 15
                    : 0),
            bottomLeft: const Radius.circular(15),
            bottomRight: const Radius.circular(15),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSelf) buddyNameWidget(),
          Wrap(
            alignment: WrapAlignment.end,
            runAlignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.1),
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 0),
                child: Text(
                  widget.chat.msg ?? "",
                  style: KTextStyle.subtitle1
                      .copyWith(color: !isSelf ? KColor.black87 : KColor.whiteConst, fontWeight: FontWeight.w500, letterSpacing: 0, height: 1.25),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: isSelf ? KColor.white54.withOpacity(0.15) : KColor.transparent!,
                      blurRadius: 50,
                      spreadRadius: 5,
                      offset: const Offset(-18, -10),
                    ),
                  ],
                ),
                child: dateAndSeenView(isSelf),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buddyNameWidget() {
    return UnconstrainedBox(
      child: Visibility(
        visible: widget.isGroup == 1,
        child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 7),
            child: Text(widget.chat.user!.firstName!, style: KTextStyle.bodyText3.copyWith(color: KColor.primary, fontWeight: FontWeight.bold))),
      ),
    );
  }

  Container buildFeedMessage(BuildContext context, bool isSelf) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: !isSelf ? KColor.feedActionCircle : KColor.appThemeColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSelf) buddyNameWidget(),
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Visibility(
                visible: widget.chat.msg != "",
                child: Container(
                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.1),
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 8),
                  child: Text(
                    widget.chat.msg ?? "",
                    style: KTextStyle.subtitle1
                        .copyWith(color: !isSelf ? KColor.black87 : KColor.whiteConst, fontWeight: FontWeight.w500, letterSpacing: 0, height: 1.25),
                  ),
                ),
              ),
              Stack(
                children: [
                  widget.chat.chatMetaData?.feedMeta == null
                      ? StatusLinkPreviewCard(widget.chat.chatMetaData?.linkMeta, widget.chat.msg ?? "")
                      : widget.chat.chatMetaData?.feedMeta?.linkMeta != null
                          ? StatusLinkPreviewCard(widget.chat.chatMetaData?.feedMeta?.linkMeta, widget.chat.msg ?? "")
                          : StatusPreviewCard(widget.chat.chatMetaData!, widget.chat.msg ?? ""),
                  Positioned(
                    bottom: -1,
                    right: 2,
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: KColor.black54,
                              blurRadius: 50,
                              spreadRadius: 5,
                              offset: const Offset(-15, -20),
                            ),
                          ],
                        ),
                        child: dateAndSeenView(isSelf, isVideo: true)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox dateAndSeenView(isSelf, {isVideo = false, feedData = false}) {
    return SizedBox(
      width: isSelf ? 75 : 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateTimeService.convert(widget.chat.createdAt, isDate: false).toString().toLowerCase(),
            textAlign: TextAlign.center,
            style: KTextStyle.caption.copyWith(color: KColor.timeGreyText, letterSpacing: 0),
          ),
          Visibility(
              visible: isSelf,
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  Icon(Icons.done_all, size: 16, color: widget.chat.isSeen == 1 ? KColor.seenGreen : KColor.grey),
                ],
              )),
        ],
      ),
    );
  }

  void _showOptionsModal(context, chatId, {inboxId, isGroup = false}) {
    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        elevation: 5,
        isScrollControlled: true,
        useRootNavigator: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
      ),
      builder: (_) => PlatformWidget(
        material: (_, __) => MessageOptionsModal(
          chatId,
          inboxId: inboxId,
          isGroup: isGroup,
        ),
        cupertino: (_, __) => MessageOptionsModal(
          chatId,
          inboxId: inboxId,
          isGroup: isGroup,
          isPlatformIos: true,
        ),
      ),
    );
  }
}

class MessageOptionsModal extends ConsumerWidget {
  final bool isPlatformIos, isGroup;
  final int chatId;
  final int? inboxId;

  const MessageOptionsModal(this.chatId, {Key? key, this.isPlatformIos = false, this.isGroup = false, this.inboxId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isPlatformIos
        ? CupertinoTheme(
            data: CupertinoThemeData(
              brightness: AppMode.darkMode ? Brightness.dark : Brightness.light,
            ),
            child: CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('Delete'),
                  isDestructiveAction: true,
                  onPressed: () {
                    isGroup
                        ? ref.read(chatProvider.notifier).deleteChatMessage(chatId, inboxId: inboxId, isGroup: true)
                        : ref.read(chatProvider.notifier).deleteChatMessage(chatId);
                    Navigator.pop(context);
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancel'),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          )
        : Container(
            color: KColor.textBackground,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 65,
                    height: 5,
                    decoration: BoxDecoration(color: KColor.grey100, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25)),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundColor: KColor.red!.withOpacity(0.1),
                    child: Icon(Icons.delete, color: KColor.red),
                  ),
                  title: Text('Delete', style: KTextStyle.subtitle2.copyWith(color: KColor.red)),
                  onTap: () {
                    isGroup
                        ? ref.read(chatProvider.notifier).deleteChatMessage(chatId, inboxId: inboxId, isGroup: true)
                        : ref.read(chatProvider.notifier).deleteChatMessage(chatId);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
  }
}

// enum PlayerState { stopped, playing, paused }

// typedef void OnError(Exception exception);

// class AudioApp extends StatefulWidget {
//   final String audioUrl;

//   AudioApp(this.audioUrl);

//   @override
//   _AudioAppState createState() => _AudioAppState();
// }

// class _AudioAppState extends State<AudioApp> {
//   Duration duration;
//   Duration position;

//   AudioPlayer audioPlayer;

//   String localFilePath;

//   PlayerState playerState = PlayerState.stopped;

//   get isPlaying => playerState == PlayerState.playing;

//   get isPaused => playerState == PlayerState.paused;

//   get durationText => duration != null ? duration.toString().split('.').first : '';

//   get positionText => position != null ? position.toString().split('.').first : '';

//   bool isMuted = false;

//   StreamSubscription _positionSubscription;
//   StreamSubscription _audioPlayerStateSubscription;

//   @override
//   void initState() {
//     super.initState();
//     initAudioPlayer();
//   }

//   @override
//   void dispose() {
//     _positionSubscription.cancel();
//     _audioPlayerStateSubscription.cancel();
//     audioPlayer.stop();
//     super.dispose();
//   }

//   void initAudioPlayer() {
//     audioPlayer = AudioPlayer();
//     _positionSubscription = audioPlayer.onAudioPositionChanged.listen((p) => setState(() => position = p));
//     _audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen((s) {
//       if (s == AudioPlayerState.PLAYING) {
//         setState(() => duration = audioPlayer.duration);
//       } else if (s == AudioPlayerState.STOPPED) {
//         onComplete();
//         setState(() {
//           position = duration;
//         });
//       }
//     }, onError: (msg) {
//       setState(() {
//         playerState = PlayerState.stopped;
//         duration = Duration(seconds: 0);
//         position = Duration(seconds: 0);
//       });
//     });
//   }

//   Future play() async {
//     await audioPlayer.play(widget.audioUrl);
//     setState(() {
//       playerState = PlayerState.playing;
//     });
//   }

//   Future pause() async {
//     await audioPlayer.pause();
//     setState(() => playerState = PlayerState.paused);
//   }

//   Future stop() async {
//     await audioPlayer.stop();
//     setState(() {
//       playerState = PlayerState.stopped;
//       position = Duration();
//     });
//   }

//   Future mute(bool muted) async {
//     await audioPlayer.mute(muted);
//     setState(() {
//       isMuted = muted;
//     });
//   }

//   void onComplete() {
//     setState(() => playerState = PlayerState.stopped);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildPlayer(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlayer() => Container(
//         padding: EdgeInsets.all(7),
//         decoration: BoxDecoration(color: KColor.white, borderRadius: BorderRadius.all(Radius.circular(10))),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(mainAxisSize: MainAxisSize.min, children: [
//               IconButton(
//                 onPressed: isPlaying ? null : () => play(),
//                 iconSize: 35,
//                 icon: Icon(Icons.play_arrow),
//                 color: KColor.cyan,
//               ),
//               IconButton(
//                 onPressed: isPlaying ? () => pause() : null,
//                 iconSize: 35,
//                 icon: Icon(Icons.pause),
//                 color: KColor.cyan,
//               ),
//             ]),
//             if (duration != null)
//               Slider(
//                   value: position?.inMilliseconds?.toDouble() ?? 0.0,
//                   onChanged: (double value) {
//                     return audioPlayer.seek((value / 1000).roundToDouble());
//                   },
//                   min: 0.0,
//                   max: duration.inMilliseconds.toDouble()),
//             // if (position != null) _buildProgressView()
//           ],
//         ),
//       );
// }
