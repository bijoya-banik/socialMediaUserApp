import 'dart:convert';
import 'dart:io';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/controller/chat/group_chat_admin_controller.dart';
import 'package:buddyscripts/controller/chat/group_chat_controller.dart';
import 'package:buddyscripts/controller/chat/state/chat_state.dart';
import 'package:buddyscripts/controller/chat/group_chat_member_controller.dart';
import 'package:buddyscripts/custom_plugin/video_thumbnail_generator.dart';
import 'package:buddyscripts/models/chats/chat_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/services/socket_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_chat_loading_indicator.dart';
import 'package:buddyscripts/views/screens/call_agora/call_user_screen.dart';
import 'package:buddyscripts/views/screens/call_agora/call_user_model.dart' as call;
import 'package:buddyscripts/views/screens/messages/components/reply_widget_card.dart';
import 'package:buddyscripts/views/screens/messages/group_chat/group_chat_members_screen.dart';
import 'package:buddyscripts/views/screens/messages/group_chat/update_group_chat_name_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/global_components/k_app_bar.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/messages/components/messages_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:swipe_to/swipe_to.dart';

const Token = '006a3240716c7be4887bb2ccb2c006daec8IAAXtPkR1FYW4dCscIJDyZe0Wjg2lijKwkSv47sDDpPx5SNkemwAAAAAEABUm4+slaSkYgEAAQCUpKRi';
const channel = 'callTest';
bool userGetCall = false;
dynamic callEnded = ValueNotifier<bool>(false);
dynamic userGetResponse = ValueNotifier<bool>(false);
// dynamic anotherCall = ValueNotifier<int>(0);

class ChatScreen extends ConsumerStatefulWidget {
  final dynamic id;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic profilePic;
  final dynamic userName;
  final dynamic isOnline;
  final dynamic conversation;
  // final int? isGroup;
  // final String? role;

  const ChatScreen({
    Key? key,
    this.id,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.userName,
    this.isOnline,
    this.conversation,
    // this.isGroup = 0,
    // this.role,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with TickerProviderStateMixin {
  List attachmentOptions = [
    {'title': 'Camera', 'icon': CupertinoIcons.camera_fill},
    {'title': 'Gallery', 'icon': Icons.image},
    {'title': 'Document', 'icon': Icons.file_copy},
    {'title': 'Video', 'icon': Icons.play_arrow},
    {'title': 'GIF', 'icon': AssetPath.gif},
  ];

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  dynamic position = 0;
  dynamic lastposition = 0;
  dynamic chatprofilePic;
  dynamic chatMute;
  bool _isDisabled = true;
  bool _isTop = false;
  TextEditingController messageController = TextEditingController();
  //ScrollController _scrollController = new ScrollController();
  final _debouncer = Debouncer(milliseconds: 1000);
  List<MessagesCard> messageCardList = [];
  final focusNode = FocusNode();
  Message? replyMessage;
  Message? storeReplyMessage;
  String message = '';
  GiphyGif? gif;
  String name = "";
  String replyUserName = "";
  List<FileElement> successGifFile = [];
  List<FileElement> replyfiles = [];
  static const inputTopRadius = Radius.circular(6);
  static const inputBottomRadius = Radius.circular(6);
  @override
  void initState() {
    super.initState();

    chatprofilePic = widget.profilePic;
    chatMute = widget.conversation?.isGroupMember?.muteNoti;

    //  if (widget.conversation?.isGroupMember != null) {
    if (widget.conversation?.isGroup == 1) {
      name = widget.firstName;
    } else {
      name = widget.firstName + " " + widget.lastName;
    }
    // } else {
    //   name = widget.firstName;
    // }

    ref.read(chatProvider.notifier).buddyId = widget.id;

    itemPositionsListener.itemPositions.addListener(() {
      _itemScrollListener();
    });
  }

  _itemScrollListener() {
    position = itemPositionsListener.itemPositions.value.first.index;
    lastposition = itemPositionsListener.itemPositions.value.last.index;

    if (position > 0) {
      setState(() {
        _isTop = true;
      });

      if (lastposition == (ref.read(chatProvider.notifier).chatLength)! - 1) {
        if (ref.read(chatProvider.notifier).moreChatInstanceLength != 0) {
          ref.read(chatProvider.notifier).chatLength = 0;
          _moreChat();
        }
      }
    } else {
      if (_isTop) setState(() => _isTop = false);
    }
  }

  _moreChat() async {
    await ref.read(chatProvider.notifier).fetchMoreChat();
  }

  // ignore: unused_element
  _updateOnline() async {
    await Future.delayed(const Duration(seconds: 1));
    ref.read(chatProvider.notifier).updateBuddyOnline(widget.isOnline);
  }

  void _scrollToIndex(int index) {
    _itemScrollController.scrollTo(index: index, duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(() {});
    //  _scrollController.dispose();
    for (MessagesCard messagesCard in messageCardList) {
      if (messagesCard.animationController != null) messagesCard.animationController?.dispose();
    }
    super.dispose();
  }

  onWillPop() {
    ref.read(chatProvider.notifier).resetBuddyId();
    ref.read(chatProvider.notifier).resetBuddyOnline();
    ref.read(assetManagerProvider.notifier).removeAll();
    ref.read(chatProvider.notifier).resetmoreChatInstanceLength();
    // context.read(conversationsProvider).fetchConversations(isLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(chatProvider, (_, state) {
      if (state is ChatSuccessState) {
        messageCardList.clear();
        for (int i = 0; i < state.chat.chatLists!.length; i++) {
          messageCardList.add(MessagesCard(
            state.chat.chatLists![i],
            widget.conversation?.isGroup!,
            showMoreMargin: i == 0
                ? false
                : state.chat.chatLists![i].userId != state.chat.chatLists![i - 1].userId
                    ? true
                    : false,
            conversationId: widget.conversation.id,
          ));
        }
      }
    });
    return WillPopScope(
      onWillPop: () async {
        onWillPop();
        return true;
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          //set the sensitivity for your ios gesture anywhere between 10-50 is good

          int sensitivity = 25;

          if (details.delta.dx > sensitivity) {
            //SWIPE FROM RIGHT DETECTION
            onWillPop();
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: KColor.textBackground,
          resizeToAvoidBottomInset: true,
          appBar: KAppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            isCustomLeading: true,
            customIcon: Icons.arrow_back_ios,
            isCustomLeadingFunction: true,
            customLeadingFunction: () {
              ref.read(chatProvider.notifier).resetBuddyId();
              ref.read(assetManagerProvider.notifier).removeAll();
            },
            customAction: [
              Visibility(
                visible: widget.conversation?.isGroup == 1,
                child: PopupMenuButton(
                  tooltip: "",
                  onSelected: (selected) async {
                    if (selected == 'member') {
                      ref.read(groupChatMemberProvider.notifier).fetchGroupChatAllMembers(widget.id);
                      ref.read(groupChatAdminProvider.notifier).fetchGroupChatAdmins(widget.id);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => GroupChatAllMembersScreen(
                                  chatId: widget.id,
                                  admin:
                                      widget.conversation?.isGroupMember?.role == "SUPER ADMIN" || widget.conversation?.isGroupMember?.role == "ADMIN"
                                          ? true
                                          : false)));
                    } else if (selected == 'updateName') {
                      var chatGroupName = await Navigator.push(
                          context, CupertinoPageRoute(builder: (context) => UpdateGroupChatNameScreen(groupName: name, inboxId: widget.id)));
                      setState(() {
                        name = chatGroupName;
                      });
                    } else if (selected == 'updatePhoto') {
                      File? picked = await AssetService.pickMedia(true, context, false, true);
                      if (picked != null) {
                        var image =
                            await ref.read(groupChatProvider.notifier).updateGroupChatPhoto(image: [picked], groupChatName: name, inboxId: widget.id);
                        setState(() {
                          chatprofilePic = image;
                        });
                      }
                    } else if (selected == 'mute') {
                      int mute = await ref.read(groupChatProvider.notifier).muteGroupChat(inboxId: widget.id);
                      setState(() {
                        chatMute = mute;
                      });
                    } else if (selected == 'unmute') {
                      int unmute = await ref.read(groupChatProvider.notifier).unmuteGroupChat(inboxId: widget.id);
                      setState(() {
                        chatMute = unmute;
                      });
                    } else if (selected == 'leave') {
                      KDialog.kShowDialog(
                          context,
                          ConfirmationDialogContent(
                              titleShow: true,
                              titleColor: KColor.primary,
                              title: "Leave group",
                              titleContent: 'Are you sure that you want to leave this conversation? You will no longer receive new messages.',
                              buttonTextYes: "Leave",
                              buttonTextNo: "Cancel",
                              onPressedCallback: () async => {
                                    Navigator.pop(context),
                                    KDialog.kShowDialog(
                                      context,
                                      const ProcessingDialogContent("Processing..."),
                                      barrierDismissible: false,
                                    ),
                                    await ref.read(groupChatProvider.notifier).leaveGroupChat(inboxId: widget.id)
                                  }),
                          useRootNavigator: false);
                    } else if (selected == 'delete') {
                      KDialog.kShowDialog(
                          context,
                          ConfirmationDialogContent(
                              titleShow: true,
                              titleColor: KColor.primary,
                              title: "Delete group",
                              titleContent: 'Are you sure want to delete this group?',
                              buttonTextYes: "Delete",
                              buttonTextNo: "Cancel",
                              onPressedCallback: () async => {
                                    Navigator.pop(context),
                                    KDialog.kShowDialog(
                                      context,
                                      const ProcessingDialogContent("Processing..."),
                                      barrierDismissible: false,
                                    ),
                                    await ref.read(groupChatProvider.notifier).deleteChatGroup(inboxId: widget.id)
                                  }),
                          useRootNavigator: false);
                    }
                  },
                  color: AppMode.darkMode ? KColor.feedActionCircle : KColor.appBackground,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  offset: const Offset(0, -10),
                  icon: Icon(MaterialIcons.more_vert, color: KColor.black),
                  itemBuilder: (_) => <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                        value: "leave",
                        child: Text('Leave Group', style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal))),
                    if (widget.conversation?.isGroupMember?.role == "SUPER ADMIN" || widget.conversation?.isGroupMember?.role == "ADMIN")
                      PopupMenuItem<String>(
                          value: "delete",
                          child: Text('Delete Group', style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal))),
                    if (widget.conversation?.isGroupMember?.role == "SUPER ADMIN" || widget.conversation?.isGroupMember?.role == "ADMIN")
                      PopupMenuItem<String>(
                          value: "updateName",
                          child: Text('Change name', style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal))),
                    if (widget.conversation?.isGroupMember?.role == "SUPER ADMIN" || widget.conversation?.isGroupMember?.role == "ADMIN")
                      PopupMenuItem<String>(
                          value: "updatePhoto",
                          child:
                              Text('Change group photo', style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal))),
                    PopupMenuItem<String>(
                        value: "member",
                        child: Text('Group Members', style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal))),
                    PopupMenuItem<String>(
                        value: chatMute == 0 ? "mute" : "unmute",
                        child: Text(chatMute == 0 ? "Mute" : "Unmute",
                            style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal))),
                  ],
                ),
              ),
              Visibility(
                visible: widget.conversation?.isGroup == 0,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CallUserScreen(
                                  friend: call.CallUserModel(
                                    userName: widget.userName,
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    userId: widget.id,
                                    profilePic: widget.profilePic,
                                  ),
                                  self: call.CallUserModel(
                                      userName: ref.read(userProvider.notifier).userData?.user?.username,
                                      firstName: ref.read(userProvider.notifier).userData?.user?.firstName,
                                      lastName: ref.read(userProvider.notifier).userData?.user?.lastName,
                                      userId: ref.read(userProvider.notifier).userData?.user?.id,
                                      profilePic: ref.read(userProvider.notifier).userData?.user?.profilePic),
                                  type: "call-made",
                                  token: Token,
                                  channel: channel,
                                  video: false,
                                ),
                              ));
                        },
                        icon: Icon(Icons.call, color: KColor.black87)),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CallUserScreen(
                                  friend: call.CallUserModel(
                                      userName: widget.userName,
                                      firstName: widget.firstName,
                                      lastName: widget.lastName,
                                      userId: widget.id,
                                      profilePic: widget.profilePic),
                                  self: call.CallUserModel(
                                      userName: ref.read(userProvider.notifier).userData?.user?.username,
                                      firstName: ref.read(userProvider.notifier).userData?.user?.firstName,
                                      lastName: ref.read(userProvider.notifier).userData?.user?.lastName,
                                      userId: ref.read(userProvider.notifier).userData?.user?.id,
                                      profilePic: ref.read(userProvider.notifier).userData?.user?.profilePic),
                                  type: "call-made",
                                  token: Token,
                                  channel: channel,
                                  video: true,
                                ),
                              ));
                        },
                        icon: Icon(MaterialIcons.videocam, color: KColor.black87)),
                  ],
                ),
              ),
            ],
            customTitle: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Stack(
                    children: [
                      chatprofilePic != null
                          ? UserProfilePicture(
                              profileURL: chatprofilePic,
                              onTapNavigate: widget.conversation?.isGroup == 1 ? false : true,
                              slug: widget.userName,
                              avatarRadius: 20.5,
                              iconSize: 20,
                            )
                          : Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                radius: 20.5,
                                backgroundColor: KColor.grey100,
                                backgroundImage: const AssetImage(AssetPath.grpPlaceholder),
                              ),
                            ),
                      // widget.conversation?.isGroup == 1
                      //     ? Container()
                      //     : Positioned(
                      //         bottom: 0,
                      //         right: 12,
                      //         child: Consumer(builder: (context, ref, _) {
                      //           // ignore: unused_local_variable
                      //           final chatState = ref.watch(chatProvider);
                      //           return chatState is ChatSuccessState
                      //               ? Container(
                      //                   height: 9,
                      //                   width: 9,
                      //                   decoration: BoxDecoration(
                      //                     shape: BoxShape.circle,
                      //                     color: //widget.isOnline == 'online' ?
                      //                         ref.read(chatProvider.notifier).chatModel!.onlineChat == "online" ? KColor.seenGreen : KColor.grey,
                      //                     border: Border.all(width: 1, color: KColor.whiteConst),
                      //                   ),
                      //                 )
                      //               : Container();
                      //         })),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserName(
                          name: name,
                          slug: widget.userName,
                          onTapNavigate: widget.conversation?.isGroup == 1 ? false : true,
                          backgroundColor: KColor.secondary,
                          textStyle: KTextStyle.subtitle2.copyWith(color: KColor.black, fontSize: 16),
                        ),
                        SizedBox(height: KSize.getHeight(context, 3)),
                        // widget.conversation?.isGroup == 1
                        //     ? Text(
                        //         // widget.isOnline == 'online'
                        //         widget.isOnline,
                        //         style: KTextStyle.caption.copyWith(color: KColor.black54),
                        //       )
                        //     : Row(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Consumer(builder: (context, ref, _) {
                        //             // ignore: unused_local_variable
                        //             final chatState = ref.watch(chatProvider);
                        //             return Text(
                        //               // widget.isOnline == 'online'
                        //               chatState is ChatSuccessState
                        //                   ? ref.read(chatProvider.notifier).chatModel?.onlineChat == "online"
                        //                       ? (ref.read(chatProvider.notifier).isTyping)!
                        //                           ? 'typing...'
                        //                           : 'Online'
                        //                       : 'Offline'
                        //                   : "",
                        //               style: KTextStyle.caption.copyWith(color: KColor.black54),
                        //             );
                        //           }),
                        //         ],
                        //       ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Consumer(builder: (context, ref, _) {
            final assetManager = ref.watch(assetManagerProvider);
            final isReplying = replyMessage != null;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              child: Stack(
                children: [
                  Column(
                    children: [
                      /// Messages
                      Consumer(builder: (context, ref, _) {
                        final chatState = ref.watch(chatProvider);

                        //    if (chatState is ChatSuccessState)
                        //  print(chatState.chat.chatLists.length);
                        // print("chatState.chat.chatLists.length");

                        if (chatState is ChatSuccessState) {
                          return chatState.chat.chatLists!.isEmpty
                              ? Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesome.send, color: KColor.black54),
                                        const SizedBox(height: 10),
                                        Text("Say HI!!", style: KTextStyle.subtitle2.copyWith(color: KColor.black87)),
                                      ],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: GestureDetector(
                                    onTap: () => hideKeyboard(context),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ScrollablePositionedList.builder(
                                            itemScrollController: _itemScrollController,
                                            itemPositionsListener: itemPositionsListener,
                                            //child: ListView.builder(
                                            // shrinkWrap: true,
                                            padding: EdgeInsets.only(top: ref.read(chatProvider.notifier).moreChatInstanceLength == 0 ? 10 : 35),
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            // controller: _scrollController,
                                            scrollDirection: Axis.vertical,
                                            reverse: true,
                                            itemCount: messageCardList.length,
                                            itemBuilder: (context, index) => Column(
                                              children: [
                                                /// Date time for messages.
                                                /// This will be used later. List of messages should be grouped per date.
                                                /*Visibility(
                                                    visible: (DateTime.now()).difference(chatState.chat.chatLists[index].createdAt).inDays > 1,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 15),
                                                      child: Text(
                                                        DateTimeService.timeAgoLocal(chatState.chat.chatLists[index].createdAt.toString()),
                                                        textAlign: TextAlign.center,
                                                        style: KTextStyle.caption.copyWith(color: KColor.timeGreyText, fontSize: 12, letterSpacing: 0),
                                                      ),
                                                    ),
                                                  ),*/
                                                index == messageCardList.length - 1 && ref.read(chatProvider.notifier).moreChatInstanceLength == -1
                                                    ? Container(
                                                        alignment: Alignment.center,
                                                        margin: const EdgeInsets.only(bottom: 5),
                                                        child: const CupertinoActivityIndicator(),
                                                      )
                                                    : Container(),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (messageCardList[index].chat.replyId != null) {
                                                      int replyIndex = messageCardList
                                                          .indexWhere(((element) => element.chat.id == messageCardList[index].chat.replyId));

                                                      _scrollToIndex(replyIndex == -1 ? messageCardList.length - 1 : replyIndex);
                                                    }
                                                  },
                                                  child: SwipeTo(
                                                    iconColor: KColor.black,
                                                    child: messageCardList[index],
                                                    onRightSwipe: () {
                                                      replyfiles = messageCardList[index].chat.files!;
                                                      focusNode.requestFocus();
                                                      replyUserName = messageCardList[index].chat.userId == getIntAsync(USER_ID) ? "You" : name;
                                                      replyToMessage(Message(
                                                          id: messageCardList[index].chat.id,
                                                          username: messageCardList[index].chat.userId == getIntAsync(USER_ID)
                                                              ? "You"
                                                              : widget.conversation?.isGroup == 1
                                                                  ? messageCardList[index].chat.user?.firstName
                                                                  : replyUserName,
                                                          message: messageCardList[index].chat.msg,
                                                          replyMessage: replyMessage));
                                                      focusNode.requestFocus();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        } else {
                          return const Expanded(child: KChatLoadingIndicator());
                        }
                      }),

                      /// Text field & Attachment
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    color: KColor.grey.withOpacity(0.125), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          if (isReplying)
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: KColor.grey.withOpacity(0.1),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: !isReplying ? Radius.zero : const Radius.circular(22),
                                                    topRight: !isReplying ? Radius.zero : const Radius.circular(22),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.all(8),
                                                        child: ReplyMessageWidget(
                                                          fromRoute: "type",
                                                          message: replyMessage!,
                                                          onCancelReply: cancelReply,
                                                        ),
                                                      ),
                                                    ),
                                                    if (replyMessage != null)
                                                      replyfiles.isNotEmpty
                                                          ? Stack(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(6),
                                                                      child: replyfiles[0].type == "video"
                                                                          ? ThumbnailImage(
                                                                              videoUrl: replyfiles[0].fileLoc,
                                                                              type: "replySwipe",
                                                                              width: KSize.getHeight(context, 45),
                                                                              height: KSize.getHeight(context, 45),
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                          : replyfiles[0].type == "image"
                                                                              ? Image.network(replyfiles[0].fileLoc!, width: 45, height: 45)
                                                                              : Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Icon(Icons.file_copy, color: KColor.black87),
                                                                                )),
                                                                ),
                                                                Positioned(
                                                                  top: 5,
                                                                  right: 5,
                                                                  child: Container(
                                                                    padding: const EdgeInsets.all(3),
                                                                    alignment: Alignment.topRight,
                                                                    decoration:
                                                                        BoxDecoration(shape: BoxShape.circle, color: KColor.white.withOpacity(0.9)),
                                                                    child: GestureDetector(
                                                                      child: Icon(Icons.close, color: KColor.primary, size: 16),
                                                                      onTap: cancelReply,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(
                                                              padding: const EdgeInsets.all(10),
                                                              alignment: Alignment.topRight,
                                                              child: GestureDetector(
                                                                child: Icon(Icons.close, color: KColor.primary, size: 16),
                                                                onTap: cancelReply,
                                                              ),
                                                            )
                                                  ],
                                                )),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  focusNode: focusNode,
                                                  controller: messageController,
                                                  maxLines: 5,
                                                  minLines: 1,
                                                  autofocus: !_isDisabled,
                                                  cursorColor: KColor.grey,
                                                  onChanged: (value) {
                                                    if (value.trim().isEmpty) {
                                                      if (!_isDisabled) {
                                                        FocusScope.of(context).unfocus();
                                                        setState(() {
                                                          _isDisabled = true;
                                                          messageController.text = "";
                                                        });
                                                      }
                                                    } else {
                                                      if (_isDisabled) {
                                                        setState(() {
                                                          _isDisabled = false;
                                                        });
                                                      }
                                                      SocketService().showTyping(widget.id, true);
                                                      _debouncer.run(() {
                                                        SocketService().showTyping(widget.id, false);
                                                      });
                                                    }
                                                  },
                                                  keyboardType: TextInputType.multiline,
                                                  style: KTextStyle.subtitle1.copyWith(color: KColor.black),
                                                  decoration: InputDecoration(
                                                    hintText: "Type some message...",
                                                    hintStyle: KTextStyle.subtitle1.copyWith(color: KColor.black54),
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                                    isDense: true,
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: isReplying ? Radius.zero : inputTopRadius,
                                                        topRight: isReplying ? Radius.zero : inputTopRadius,
                                                        bottomLeft: inputBottomRadius,
                                                        bottomRight: inputBottomRadius,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: assetManager.assets.length <= 4 ? _showFileOptionsDialog : null,
                                                child: Container(
                                                  margin: EdgeInsets.only(right: KSize.getWidth(context, 10)),
                                                  child: Icon(
                                                    MaterialIcons.search,
                                                    color: assetManager.assets.length <= 4 ? KColor.appThemeColor : KColor.black54,
                                                    size: 25,
                                                  ),
                                                ),
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
                            SizedBox(width: KSize.getWidth(context, 10)),
                            InkWell(
                              splashColor: KColor.transparent,
                              highlightColor: KColor.transparent,
                              onTap: () async {
                                //  SocketService().test(messageController.text);

                                if ((!_isDisabled || assetManager.assets.isNotEmpty) && !assetManager.isMediaUploading) {
                                  // Scroll down when user sends message, if user scrolled up

                                  // if (_scrollController.positions.isNotEmpty) {
                                  //   print("object");
                                  //   if (_scrollController.offset > 0) {
                                  //     print("object");
                                  //     _scrollController.animateTo(_scrollController.position.minScrollExtent,
                                  //         duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                                  //   }
                                  // }

                                  if (position > 0) {
                                    _scrollToIndex(0);
                                  }

                                  storeReplyMessage = replyMessage;
                                  cancelReply();

                                  var message = messageController.text;
                                  showAnimatedMessageCard([], message);

                                  await ref.read(chatProvider.notifier).sendMessage(message, widget.conversation?.isGroup == 0 ? widget.id : null,
                                      widget.conversation?.isGroup == 1 ? widget.id : null, storeReplyMessage ?? const Message());
                                  // messageController.clear();
                                  // _isDisabled = true;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: KColor.appThemeColor, shape: BoxShape.circle),
                                child: Icon(
                                  Icons.send_rounded,
                                  color: _isDisabled && assetManager.assets.isEmpty ? KColor.white.withOpacity(0.25) : KColor.whiteConst,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// Scroll down to bottom indicator
                  Visibility(
                    visible: _isTop,
                    child: Positioned(
                      bottom: 80,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          _scrollToIndex(0);

                          if (!mounted) return;
                          setState(() {
                            _isTop = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: KColor.white,
                            boxShadow: [
                              BoxShadow(color: KColor.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10),
                            ],
                          ),
                          child: Icon(Icons.keyboard_arrow_down, color: KColor.appThemeColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void showAnimatedMessageCard(List<File> files, msg, {gif = false, gifFile}) {
    print(' TEST: inside showAnimatedMessageCard');
    List<FileElement> _files = [];
    if (files.isNotEmpty) {
      for (var file in files) {
        _files.add(FileElement(
          type: ref.read(assetManagerProvider).isDocumentSelected
              ? "application"
              : ref.read(assetManagerProvider).isVideoSelected
                  ? "video"
                  : "image",
          fileLoc: file.path,
          isLocal: true,
          originalName: file.path.split('/').last.toString(),
        ));
      }
    }
    if (gifFile != null) {
      _files.add(FileElement(
        type: "image",
        fileLoc: gifFile,
        isLocal: true,
      ));
    }

    MessagesCard _messagesCard = MessagesCard(
      ChatList(
          id: -1,
          msg: msg,
          userId: getIntAsync(USER_ID),
          replyId: storeReplyMessage?.id,
          replyMsg: storeReplyMessage?.message,
          replyFiles: replyfiles,
          files: _files,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: 0,
          chatMetaData: ChatMetaData(linkMeta: null, feedMeta: null)),
      widget.conversation!.isGroup!,
      conversationId: widget.conversation.id,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );
    print(' TEST: _messagesCard = $_messagesCard');
    print(' TEST:  _messagesCard animationController = ${_messagesCard.animationController}');
    print("_files.length");
    print(_files.length);
    print(_files);

    setState(() {
      messageCardList.insert(0, _messagesCard);
      messageController.clear();
      _isDisabled = true;
    });

    _messagesCard.animationController!.forward();
  }

  void _showFileOptionsDialog() {
    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      barrierColor: KColor.transparent!,
      transitionDuration: const Duration(milliseconds: 200),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        // SystemChannels.textInput.invokeMethod('TextInput.show');

        // return Padding(
        //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        //   child:
        return fileOptionsDialog(); // FileOptionsDialogContent();
        // );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          alignment: Alignment.lerp(Alignment.bottomRight, Alignment.bottomRight, 150)!,
          scale: Tween<double>(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(reverseCurve: Curves.easeOut, parent: anim1, curve: Curves.easeOut),
          ),
          child: child,
        );
      },
    );
  }

  Align fileOptionsDialog() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width - 35,
        margin: const EdgeInsets.only(bottom: 70),
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 20),
        decoration: BoxDecoration(color: AppMode.darkMode ? KColor.grey850const : KColor.appBackground, borderRadius: BorderRadius.circular(10)),
        child: Wrap(
          runSpacing: 15,
          spacing: 20,
          alignment: WrapAlignment.center,
          children: List.generate(
            attachmentOptions.length,
            (index) {
              return GestureDetector(
                onTap: () async {
                  File? asset;

                  if (attachmentOptions[index]['title'] == 'Camera') {
                    XFile _asset = await AssetService.pickImageVideo(false, context, ImageSource.camera);
                    asset = File(_asset.path);
                  } else if (attachmentOptions[index]['title'] == 'Gallery') {
                    List<XFile> _asset = await AssetService.pickImageVideo(false, context, ImageSource.gallery, pickMultiImage: true);

                    // asset = File(_asset.path);
                    print('_asset = $_asset');
                    for (int i = 0; i < _asset.length; i++) {
                      ref.read(assetManagerProvider).addAssets(File(_asset[i].path));
                    }
                  } else if (attachmentOptions[index]['title'] == 'Video') {
                    XFile _asset = await AssetService.pickImageVideo(false, context, ImageSource.gallery, isVideo: true);
                    asset = File(_asset.path);
                  } else if (attachmentOptions[index]['title'] == 'Document') {
                    PlatformFile _asset = await AssetService.pickMedia(false, context, true, false);
                    asset = File(_asset.path.toString());
                  } else if (attachmentOptions[index]['title'] == 'GIF') {
                    Navigator.of(context).pop();
                    gif = null;
                    successGifFile = [];
                    gif = await GiphyPicker.pickGif(
                      context: context,
                      apiKey: 'qj3EB381QPq832emOMF1KMUfG7cci4fD',
                      fullScreenDialog: false,
                      previewType: GiphyPreviewType.previewWebp,
                      decorator: GiphyDecorator(
                        showAppBar: false,
                        searchElevation: 4,
                        giphyTheme: ThemeData.dark().copyWith(
                          inputDecorationTheme: const InputDecorationTheme(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    );
                  }

                  storeReplyMessage = replyMessage;
                  cancelReply();

                  if (attachmentOptions[index]['title'] == 'GIF') {
                    if (gif != null) {
                      successGifFile.add(FileElement(
                        fileLoc: gif?.images.original?.url,
                        type: "image",
                      ));
                      showAnimatedMessageCard([], "Attachment", gif: true, gifFile: gif?.images.original?.url);

                      await ref.read(chatProvider.notifier).sendMessage("Attachment", widget.conversation?.isGroup == 0 ? widget.id : null,
                          widget.conversation?.isGroup == 1 ? widget.id : null, storeReplyMessage,
                          replyFiles: replyfiles, files: jsonEncode(successGifFile));
                    }
                  } else {
                    if (asset != null) ref.read(assetManagerProvider).addAssets(asset);
                    Navigator.of(context).pop();
                    showAnimatedMessageCard(
                        attachmentOptions[index]['title'] == 'Gallery' ? ref.read(assetManagerProvider).assets : [asset!], "Attachment");

                    await ref.read(chatProvider.notifier).uploadMedia(
                        widget.conversation?.isGroup == 0 ? widget.id : null,
                        widget.conversation?.isGroup == 1 ? widget.id : null,
                        ref.read(assetManagerProvider).assets,
                        storeReplyMessage == null ? const Message() : storeReplyMessage!);
                    ref.read(assetManagerProvider).removeAll();
                  }
                  // messageController.clear();
                  // _isDisabled = true;
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppMode.darkMode ? KColor.grey900const : KColor.appThemeColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: index == 4
                          ? Image.asset(
                              attachmentOptions[index]['icon'],
                              color: AppMode.darkMode ? KColor.whiteConst.withOpacity(0.7) : KColor.appThemeColor,
                            )
                          : Icon(attachmentOptions[index]['icon'],
                              color: AppMode.darkMode ? KColor.whiteConst.withOpacity(0.7) : KColor.appThemeColor),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(attachmentOptions[index]['title'], style: KTextStyle.caption.copyWith(color: KColor.black))),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }

  void replyToMessage(Message message) {
    print("message.username");
    print(message.username);
    setState(() {
      replyMessage = message;
    });

    print(message.message);
  }
}
