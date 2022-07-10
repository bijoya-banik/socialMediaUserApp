import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/controller/chat/conversation_group_people_search_controller.dart';
import 'package:buddyscripts/controller/chat/share_msg_controller.dart';
import 'package:buddyscripts/controller/chat/state/share_msg_state.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_conversations_loading_indicator.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/messages/conversation_search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/share_message_friend_card.dart';

// ignore: must_be_immutable
class ShareMsgToFriendsScreen extends ConsumerStatefulWidget {
  final FeedType? feedType;
  final FeedModel? feed;
  final int? id;

  const ShareMsgToFriendsScreen({Key? key, this.feedType = FeedType.PROFILE, this.feed, this.id}) : super(key: key);

  @override
  _ShareMsgToFriendsScreenState createState() => _ShareMsgToFriendsScreenState();
}

class _ShareMsgToFriendsScreenState extends ConsumerState<ShareMsgToFriendsScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    msgController.text = ref.read(chatProvider.notifier).msgController ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      return CupertinoPageScaffold(
          backgroundColor: KColor.appBackground,
          navigationBar: KCupertinoNavBar(title: "Send to", automaticallyImplyLeading: false, hasLeading: true),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverRefreshControl(onRefresh: () {
                return ref.read(shareMsgProvider.notifier).fetchRecentChatList();
              }),

              SliverPadding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      TextField(
                          controller: msgController,
                          cursorColor: KColor.grey,
                          onChanged: (val) {
                            ref.read(chatProvider.notifier).msgController = val;
                          },
                          style: KTextStyle.bodyText1.copyWith(color: KColor.black),
                          decoration: InputDecoration(
                            hintText: "Write a message...",
                            hintStyle: KTextStyle.bodyText3.copyWith(color: KColor.black54),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: KColor.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: KColor.grey),
                            ),
                            prefixIcon: UserProfilePicture(
                              avatarRadius: 16,
                              profileURL: ref.read(userProvider.notifier).userData?.user?.profilePic,
                              onTapNavigate: false,
                            ),
                            prefixIconConstraints: const BoxConstraints(minHeight: 48),
                          )),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppMode.darkMode ? KColor.grey900const!.withOpacity(0.65) : KColor.grey200const!,
                              blurRadius: 44,
                              spreadRadius: 2,
                              offset: const Offset(0, -15),
                            ),
                          ],
                        ),
                        child: KTextField(
                          hintText: 'Search',
                          topMargin: 5,
                          hasPrefixIcon: true,
                          prefixIcon: Icon(Feather.search, color: KColor.black54, size: 20),
                          isClearableField: true,
                          isReadOnly: true,
                          backgroundColor: AppMode.darkMode ? KColor.feedActionCircle : KColor.grey300!.withOpacity(0.7),
                          borderRadius: 50,
                          onTap: () async {
                            ref.read(conversationGroupPeopleSearchResultProvider.notifier).reset();
                            dynamic msg = await Navigator.push(
                                context,
                                FadeRoute(
                                    page: ConversationSearchScreen(feed: widget.feed, feedType: widget.feedType, id: widget.id, forShare: true)));

                            setState(() {
                              msgController.text = msg ?? "";
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Conversations
              Consumer(builder: (context, ref, _) {
                final shareMsgState = ref.watch(shareMsgProvider);
                return shareMsgState is ShareMsgSuccessState
                    ? shareMsgState.shareMsg.isEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height / 2 + 20,
                                child: const KContentUnvailableComponent(message: 'No friends available!')))
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ShareMsgFriendCard(
                                  feed: widget.feed!,
                                  feedType: widget.feedType!,
                                  id: widget.id,
                                  conversation: shareMsgState.shareMsg[index],
                                  msg: msgController.text,
                                );
                              },
                              childCount: shareMsgState.shareMsg.length,
                            ),
                          )
                    : const SliverToBoxAdapter(child: KConversationLoadingIndicator());
              }),
              // Consumer(builder: (context, ref, _) {
              //   final shareMsgState = ref.watch(conversationSearchResultProvider);
              //   return shareMsgState is ConversationSearchSuccessState
              //       ? shareMsgState.conversations.isEmpty
              //           ? SliverToBoxAdapter(
              //               child: SizedBox(
              //                   height: MediaQuery.of(context).size.height / 2 + 20,
              //                   child: const KContentUnvailableComponent(message: 'No friends available!')))
              //           : SliverList(
              //               delegate: SliverChildBuilderDelegate(
              //                 (BuildContext context, int index) {
              //                   return ShareMsgFriendCard(
              //                     feed: widget.feed!,
              //                     feedType: widget.feedType!,
              //                     id: widget.id,
              //                     conversation: shareMsgState.conversations[index],
              //                     msg: msgController.text,
              //                   );
              //                 },
              //                 childCount: shareMsgState.conversations.length,
              //               ),
              //             )
              //       : const SliverToBoxAdapter(child: KConversationLoadingIndicator());
              // }),
            ],
          ));
    });
  }
}
