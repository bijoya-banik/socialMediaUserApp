import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/controller/chat/conversation_group_people_search_controller.dart';
import 'package:buddyscripts/controller/chat/state/conversation_group_people_search_state.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_conversations_loading_indicator.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/home/components/share_msg_search_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationSearchScreen extends ConsumerStatefulWidget {
  final FeedType? feedType;
  final FeedModel? feed;
  final int? id;
  final bool forShare;

  const ConversationSearchScreen({Key? key, this.feedType = FeedType.PROFILE, this.feed, this.id, this.forShare = false}) : super(key: key);

  @override
  _ConversationSearchScreenState createState() => _ConversationSearchScreenState();
}

class _ConversationSearchScreenState extends ConsumerState<ConversationSearchScreen> {
  TextEditingController searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    if (widget.forShare) {
      msgController.text = ref.read(chatProvider.notifier).msgController!;
    }

    super.initState();
  }

  Future<bool> _onWillPop() {
    if (widget.forShare) {
      Navigator.of(context).pop(msgController.text);
    } else {
      Navigator.of(context).pop();
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          _onWillPop();
          return Future.value(true);
        },
        child: CupertinoPageScaffold(
          backgroundColor: KColor.darkAppBackground,
          navigationBar: KCupertinoNavBar(
            title: widget.forShare ? 'Search' : 'Conversation Search',
            automaticallyImplyLeading: widget.forShare ? false : true,
            customLeading: InkWell(
                onTap: () {
                  _onWillPop();
                },
                child: const Icon(Icons.arrow_back_ios, color: KColor.whiteConst, size: 20)),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Visibility(
                        visible: widget.forShare,
                        child: TextField(
                            controller: msgController,
                            cursorColor: KColor.grey400,
                            onChanged: (val) {
                              ref.read(chatProvider.notifier).msgController = val;
                            },
                            style: KTextStyle.bodyText1.copyWith(color: KColor.black),
                            decoration: InputDecoration(
                              hintText: "Write a message",
                              hintStyle: KTextStyle.bodyText3.copyWith(color: KColor.black54),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: KColor.grey400!),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: KColor.grey400!),
                              ),
                              prefixIcon: UserProfilePicture(
                                avatarRadius: 16,
                                profileURL: ref.read(userProvider.notifier).userData?.user?.profilePic,
                                onTapNavigate: false,
                              ),
                              prefixIconConstraints: const BoxConstraints(minHeight: 48),
                            )),
                      ),
                      const SizedBox(height: 10),
                      KTextField(
                        hintText: 'Search',
                        topMargin: 5,
                        hasPrefixIcon: true,
                        prefixIcon: Icon(Feather.search, color: KColor.black54, size: 20),
                        isClearableField: true,
                        backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.grey300!.withOpacity(0.7),
                        borderRadius: 50,
                        controller: searchController,
                        autofocus: true,
                        callBack: true,
                        suffixCallback: true,
                        suffixCallbackFunction: () {
                          Navigator.of(context).pop();
                        },
                        callBackFunction: (String value) {
                          if (value.isNotEmpty) {
                            _debouncer
                                .run(() => {ref.read(conversationGroupPeopleSearchResultProvider.notifier).groupPeopleSearchConversation(value)});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Consumer(builder: (context, ref, _) {
                final conversationGroupPeopleSearchResultState = ref.watch(conversationGroupPeopleSearchResultProvider);
                return conversationGroupPeopleSearchResultState is ConversationGroupPeopleSearchSuccessState
                    ? conversationGroupPeopleSearchResultState.conversations!.group!.isEmpty &&
                            conversationGroupPeopleSearchResultState.conversations!.people!.isEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .50,
                              child: Center(
                                child: Text("No Result Found", style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Column(
                                      children: List.generate(
                                        conversationGroupPeopleSearchResultState.conversations?.group?.length ?? 0,
                                        (index) {
                                          return ShareMsgSearchCard(
                                            feed: widget.feed!,
                                            feedType: widget.feedType!,
                                            id: widget.id,
                                            conversation: conversationGroupPeopleSearchResultState.conversations?.group![index],
                                            group: true,
                                          );
                                        },
                                      ),
                                    ),
                                    Column(
                                        children: List.generate(
                                      conversationGroupPeopleSearchResultState.conversations?.people?.length ?? 0,
                                      (index) {
                                        return ShareMsgSearchCard(
                                          feed: widget.feed!,
                                          feedType: widget.feedType!,
                                          id: widget.id,
                                          conversation: conversationGroupPeopleSearchResultState.conversations?.people![index],
                                          group: false,
                                        );
                                      },
                                    )),
                                  ],
                                );
                              },
                              childCount: 1,
                            ),
                          )
                    : conversationGroupPeopleSearchResultState is ConversationGroupPeopleSearchLoadingState
                        ? const SliverToBoxAdapter(child: KConversationLoadingIndicator())
                        : SliverToBoxAdapter(
                            child: Container(),
                          );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
