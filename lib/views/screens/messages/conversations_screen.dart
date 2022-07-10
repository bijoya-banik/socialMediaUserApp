import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/chat/conversations_controller.dart';
import 'package:buddyscripts/controller/chat/state/conversations_state.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_conversations_loading_indicator.dart';
import 'package:buddyscripts/views/screens/messages/conversation_group_people_search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/messages/components/conversations_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  int sliding = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppMode.darkMode ? KColor.darkAppBackground : KColor.whiteConst,
      navigationBar: KCupertinoNavBar(
        title: 'Messages',
        automaticallyImplyLeading: false,
        hasLeading: true,
        // trailing: PopupMenuButton(
        //   tooltip: '',
        //   onSelected: (selected) {
        //     if (selected == 'new_group') {
        //       //   ref.read(conversationsProvider.notifier).fetchConversations();
        //       ref.read(conversationSearchResultProvider.notifier).memberSearchForCreateGroupChat();
        //       Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (context) => const AddParticipateScreen()));
        //     }
        //   },
        //   color: AppMode.darkMode ? KColor.feedActionCircle : KColor.appBackground,
        //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        //   offset: const Offset(0, -10),
        //   icon: Icon(MaterialIcons.group_add, color: KColor.black),
        //   itemBuilder: (_) => <PopupMenuItem<String>>[
        //     PopupMenuItem<String>(
        //         value: "new_group",
        //         child: Text('Create new group chat', style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal))),
        //   ],
        // ),
        customLeading: Container(
          margin: const EdgeInsets.only(top: 5),
          child: Stack(
            children: [
              Consumer(builder: (context, ref, _) {
                final userState = ref.watch(userProvider);
                return UserProfilePicture(
                    profileURL: userState is UserSuccessState ? userState.userModel.user?.profilePic : null,
                    slug: userState is UserSuccessState ? userState.userModel.user?.username : null,
                    userId: userState is UserSuccessState ? userState.userModel.user?.id : null,
                    avatarRadius: 15.5,
                    iconSize: 15);
              }),
              // Positioned(
              //   bottom: 10,
              //   right: 7,
              //   child: Container(
              //     height: 9,
              //     width: 9,
              //     decoration: BoxDecoration(shape: BoxShape.circle, color: KColor.seenGreen, border: Border.all(width: 1, color: KColor.whiteConst)),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: () {
            return ref.read(conversationsProvider.notifier).fetchConversations();
          }),

          SliverPadding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppMode.darkMode ? KColor.grey900const!.withOpacity(0.65) : KColor.grey100const!,
                      blurRadius: 50,
                      spreadRadius: 0,
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
                  backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.grey300!.withOpacity(0.7),
                  borderRadius: 50,
                  onTap: () {
                    Navigator.push(context, FadeRoute(page: const ConversationGroupPeopleSearchScreen()));
                  },
                ),
              ),
            ),
          ),

          /// Conversations
          Consumer(builder: (context, ref, _) {
            final conversationsState = ref.watch(conversationsProvider);
            return conversationsState is ConversationsSuccessState
                ? conversationsState.conversations.isEmpty
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height / 2 + 20,
                            child: const KContentUnvailableComponent(message: 'No conversation available!')))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) => conversationsState.conversations[index].isDeleted == 1
                              ? Container()
                              : ConversationsCard(conversationsState.conversations[index], index),
                          childCount: conversationsState.conversations.length,
                        ),
                      )
                : const SliverToBoxAdapter(child: KConversationLoadingIndicator());
          }),
        ],
      ),
    );
  }
}
