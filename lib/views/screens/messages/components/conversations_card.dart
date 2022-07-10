import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/screens/messages/components/chat_mute_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/messages/chat_screen.dart';
import 'package:buddyscripts/views/screens/messages/components/message_options_modal.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../constants/shared_preference_constant.dart';

class ConversationsCard extends ConsumerWidget {
  final ConversationsModel conversation;
  final int index;

  const ConversationsCard(this.conversation, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: KColor.white,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          ref.read(chatProvider.notifier).fetchChat(
              id: conversation.isGroup == 1 ? conversation.id : conversation.buddyId,
              group: conversation.isGroup,
              onlineChat: conversation.buddy?.isOnline);
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ChatScreen(
                      id: conversation.isGroup == 1 ? conversation.id : conversation.buddyId,
                      firstName: conversation.isGroup == 1 ? conversation.groupName : conversation.buddy?.firstName,
                      lastName: conversation.isGroup == 1 ? "" : conversation.buddy?.lastName,
                      profilePic: conversation.isGroup == 1 ? conversation.groupLogo : conversation.buddy?.profilePic,
                      userName: conversation.isGroup == 1 ? "" : conversation.buddy?.username,
                      isOnline: conversation.isGroup == 1 ? conversation.memberName : conversation.buddy?.isOnline,
                      conversation: conversation)));
        },
        onLongPress: () {
          if (conversation.isGroup == 0) {
            _showOptionsModal(context, conversation.buddyId);
          } else {
            _showMuteModal(context, conversation.isGroupMember?.muteNoti == 0 ? false : true, conversation.id);
          }
        },
        child: Ink(
          color: KColor.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: KSize.getHeight(context, 5)),
                conversation.isGroup == 1
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          conversation.groupLogo != null
                              ? UserProfilePicture(
                                  profileURL: conversation.groupLogo,
                                  avatarRadius: 25,
                                  iconSize: 24.5,
                                )
                              : Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: KColor.grey100,
                                    backgroundImage: const AssetImage(AssetPath.grpPlaceholder),
                                  ),
                                ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: UserName(
                                        name: conversation.groupName,
                                        onTapNavigate: false,
                                        backgroundColor: KColor.transparent!,
                                        textStyle: KTextStyle.subtitle1
                                            .copyWith(color: conversation.isSeen == 1 ? KColor.black87 : KColor.black, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(width: KSize.getWidth(context, 5)),
                                    Text(
                                      DateTimeService.timeAgoLocal(conversation.updatedAt?.toIso8601String()),
                                      style: KTextStyle.bodyText2.copyWith(
                                        color: conversation.isSeen == 1 ? KColor.black87 : KColor.black,
                                        fontWeight: conversation.isSeen == 1 ? FontWeight.normal : FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: KSize.getHeight(context, 3)),
                                Row(
                                  children: [
                                    if (conversation.lastmsg != null) Expanded(child: lastMsgContainer(context)),
                                    conversation.isGroupMember?.muteNoti == 0
                                        ? Container()
                                        : Icon(Icons.notifications_off, size: 18, color: KColor.black54),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              UserProfilePicture(
                                profileURL: conversation.buddy?.profilePic,
                                slug: conversation.buddy?.username,
                                avatarRadius: 25,
                                iconSize: 24.5,
                              ),
                              // Positioned(
                              //   bottom: 3,
                              //   right: 10,
                              //   child: Container(
                              //     height: 9,
                              //     width: 9,
                              //     decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       color: conversation.buddy?.isOnline == 'online' ? KColor.seenGreen : KColor.grey,
                              //       border: Border.all(width: 1, color: KColor.white),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: UserName(
                                        name: "${conversation.buddy?.firstName}" " " "${conversation.buddy?.lastName}",
                                        onTapNavigate: false,
                                        backgroundColor: KColor.transparent!,
                                        textStyle: KTextStyle.subtitle1
                                            .copyWith(color: conversation.isSeen == 1 ? KColor.black87 : KColor.black, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(width: KSize.getWidth(context, 5)),
                                    Text(
                                      DateTimeService.timeAgoLocal(conversation.updatedAt?.toIso8601String()),
                                      style: KTextStyle.bodyText2.copyWith(
                                        color: conversation.isSeen == 1 ? KColor.black87 : KColor.black,
                                        fontWeight: conversation.isSeen == 1 ? FontWeight.normal : FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: KSize.getHeight(context, 3)),
                                if (conversation.lastmsg != null) lastMsgContainer(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: KSize.getHeight(context, 5)),
                Divider(
                  thickness: 1,
                  color: AppMode.darkMode ? KColor.grey850const : KColor.grey200const,
                ),
                //  Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row lastMsgContainer(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            Characters(conversation.lastmsg?.msg == null
                    ? ""
                    : conversation.lastmsg?.userId != getIntAsync(USER_ID)
                        ? conversation.lastmsg?.msg == ""
                            ? conversation.isGroup == 0
                                ? "sent an attachment"
                                : '${conversation.lastmsg?.user?.firstName}' " sent an attachment"
                            : conversation.isGroup == 0
                                ? '${conversation.lastmsg?.msg}'
                                : '${conversation.lastmsg?.user?.firstName}: ${conversation.lastmsg?.msg}'
                        : conversation.lastmsg?.msg == ""
                            ? "You: sent an attachment"
                            : "You: ${conversation.lastmsg?.msg}")
                .toList()
                .join("\u{200B}"),
            // Characters(conversation.lastmsg!.msg!.toString()).toList().join("\u{200B}"),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // softWrap: false,
            style: KTextStyle.bodyText2.copyWith(
                color: conversation.isSeen == 1 ? KColor.black54 : KColor.black,
                fontWeight: conversation.isSeen == 1 ? FontWeight.normal : FontWeight.bold),
          ),
        ),
        SizedBox(width: KSize.getWidth(context, 5)),
      ],
    );
  }

  void _showOptionsModal(context, buddyId) {
    print(buddyId);
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
        material: (_, __) => MessageOptionsModal(buddyId, conversation),
        cupertino: (_, __) => MessageOptionsModal(buddyId, conversation, isPlatformIos: true),
      ),
    );
  }

  void _showMuteModal(context, muteStatus, inboxId) {
    // print(buddyId);
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
        material: (_, __) => ChatMuteModal(muteStatus: muteStatus, inboxId: inboxId),
        cupertino: (_, __) => ChatMuteModal(muteStatus: muteStatus, inboxId: inboxId, isPlatformIos: true),
      ),
    );
  }
}
