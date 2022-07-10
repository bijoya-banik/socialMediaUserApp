import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShareMsgFriendCard extends ConsumerStatefulWidget {
  final dynamic conversation;
  final FeedType? feedType;
  final FeedModel? feed;
  final int? id;
  final String? msg;

  const ShareMsgFriendCard({Key? key, this.conversation, this.feedType, this.feed, this.id, this.msg}) : super(key: key);

  @override
  _ShareMsgFriendCardState createState() => _ShareMsgFriendCardState();
}

class _ShareMsgFriendCardState extends ConsumerState<ShareMsgFriendCard> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserProfilePicture(
                avatarRadius: 16,
                profileURL: widget.conversation.isGroup == 0 ? widget.conversation.buddy.profilePic : widget.conversation.groupLogo,
                onTapNavigate: false,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: KSize.getHeight(context, 10)),
                    Row(
                      children: [
                        Expanded(
                          child: UserName(
                            name: widget.conversation.isGroup == 0
                                ? "${widget.conversation.buddy.firstName} ${widget.conversation.buddy.lastName}"
                                : widget.conversation.groupName,
                            onTapNavigate: false,
                            type: 'profile',
                            userId: widget.conversation.id,
                            overflowVisible: true,
                            backgroundColor: KColor.transparent!,
                            textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          width: KSize.getWidth(context, 60),
                          child: KButton(
                            title: isLoading
                                ? "Sending"
                                : ref
                                        .read(chatProvider.notifier)
                                        .statusShareUserIdList!
                                        .contains(widget.conversation.isGroup == 0 ? widget.conversation.buddyId : widget.conversation.id)
                                    ? 'Sent'
                                    : 'Send',
                            textColor: ref
                                    .read(chatProvider.notifier)
                                    .statusShareUserIdList!
                                    .contains(widget.conversation.isGroup == 0 ? widget.conversation.buddyId : widget.conversation.id)
                                ? KColor.grey
                                : KColor.primary,
                            color: ref
                                    .read(chatProvider.notifier)
                                    .statusShareUserIdList!
                                    .contains(widget.conversation.isGroup == 0 ? widget.conversation.buddyId : widget.conversation.id)
                                ? AppMode.darkMode
                                    ? KColor.grey800const!
                                    : KColor.grey200const!
                                : KColor.primary.withOpacity(0.2),
                            innerPadding: 1,
                            onPressedCallback: () async {
                              print(!ref
                                  .read(chatProvider.notifier)
                                  .statusShareUserIdList!
                                  .contains(widget.conversation.isGroup == 0 ? widget.conversation.buddyId : widget.conversation.id));
                              if (!ref
                                  .read(chatProvider.notifier)
                                  .statusShareUserIdList!
                                  .contains(widget.conversation.isGroup == 0 ? widget.conversation.buddyId : widget.conversation.id)) {
                                if (!isLoading) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  await ref.read(chatProvider.notifier).sendMessage(
                                        ref.read(chatProvider.notifier).msgController,
                                        widget.conversation.isGroup == 0 ? widget.conversation.buddyId : null,
                                        widget.conversation.isGroup == 0 ? null : widget.conversation.id,
                                        null,
                                        feed: widget.feed,
                                        feedType: widget.feedType,
                                      );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                        )
                        // }),
                      ],
                    ),
                    SizedBox(height: KSize.getHeight(context, 3)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: KSize.getHeight(context, 12)),
        ],
      ),
    );
  }
}
