import 'package:buddyscripts/controller/chat/conversation_group_people_search_controller.dart';
import 'package:buddyscripts/controller/chat/state/conversation_group_people_search_state.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_conversations_loading_indicator.dart';
import 'package:buddyscripts/views/screens/messages/components/conversation_group_people_search_result_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationGroupPeopleSearchScreen extends ConsumerStatefulWidget {
  const ConversationGroupPeopleSearchScreen({Key? key}) : super(key: key);

  @override
  _ConversationGroupPeopleSearchScreenState createState() => _ConversationGroupPeopleSearchScreenState();
}

class _ConversationGroupPeopleSearchScreenState extends ConsumerState<ConversationGroupPeopleSearchScreen> {
  TextEditingController searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  TextEditingController msgController = TextEditingController();

  Future<bool> _onWillPop() {
    Navigator.of(context).pop();

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
            title: 'Conversation Search',
            automaticallyImplyLeading: true,
            customLeading: InkWell(
                onTap: () {
                  _onWillPop();
                },
                child: const Icon(Icons.arrow_back_ios, color: KColor.whiteConst, size: 20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                child: KTextField(
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
                      _debouncer.run(() => ref.read(conversationGroupPeopleSearchResultProvider.notifier).groupPeopleSearchConversation(value));
                    }
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 10),
                    Consumer(builder: (context, ref, _) {
                      final conversationGroupPeopleSearchResultState = ref.watch(conversationGroupPeopleSearchResultProvider);
                      return conversationGroupPeopleSearchResultState is ConversationGroupPeopleSearchSuccessState
                          ? conversationGroupPeopleSearchResultState.conversations!.group!.isEmpty &&
                                  conversationGroupPeopleSearchResultState.conversations!.people!.isEmpty
                              ? SizedBox(
                                  height: MediaQuery.of(context).size.height * .50,
                                  child: Center(
                                    child: Text("No Result Found", style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Column(
                                      children: List.generate(
                                        conversationGroupPeopleSearchResultState.conversations?.group?.length ?? 0,
                                        (index) {
                                          return ConversationGroupPeopleSearchResultCard(
                                              conversationGroupPeopleSearchResultState.conversations?.group![index], true);
                                        },
                                      ),
                                    ),
                                    Column(
                                      children: List.generate(
                                        conversationGroupPeopleSearchResultState.conversations?.people?.length ?? 0,
                                        (index) {
                                          return ConversationGroupPeopleSearchResultCard(
                                              conversationGroupPeopleSearchResultState.conversations?.people![index], false);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                          : conversationGroupPeopleSearchResultState is ConversationGroupPeopleSearchLoadingState
                              ? const KConversationLoadingIndicator()
                              : Container();
                    }),
                  ],
                ),
              ),
            ],
          ),
          // child: CustomScrollView(
          //   physics: const BouncingScrollPhysics(),
          //   slivers: [
          //     SliverPadding(
          //       padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          //       sliver: SliverToBoxAdapter(
          //         child: Column(
          //           children: [

          //             const SizedBox(height: 10),
          //             KTextField(
          //               hintText: 'Search',
          //               topMargin: 5,
          //               hasPrefixIcon: true,
          //               prefixIcon: Icon(Feather.search, color: KColor.black54, size: 20),
          //               isClearableField: true,
          //               backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.grey300!.withOpacity(0.7),
          //               borderRadius: 50,
          //               controller: searchController,
          //               autofocus: true,
          //               callBack: true,
          //               suffixCallback: true,
          //               suffixCallbackFunction: () {
          //                 Navigator.of(context).pop();
          //               },
          //               callBackFunction: (String value) {
          //                 if (value.isNotEmpty) _debouncer.run(() => ref.read(conversationGroupPeopleSearchResultProvider.notifier).groupPeopleSearchConversation(value));
          //               },
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),

          //     /// Search Conversation
          //     Consumer(builder: (context, ref, _) {
          //       final conversationGroupPeopleSearchResultState = ref.watch(conversationGroupPeopleSearchResultProvider);
          //       return conversationGroupPeopleSearchResultState is ConversationGroupPeopleSearchSuccessState
          //           ? conversationGroupPeopleSearchResultState.conversations!.group!.isEmpty &&
          //            conversationGroupPeopleSearchResultState.conversations!.group!.isEmpty
          //               ? SliverToBoxAdapter(
          //                   child: SizedBox(
          //                   height: MediaQuery.of(context).size.height * .50,
          //                   child:  Center(
          //                     child: Text("No Result Found",style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
          //                   ),
          //                 ))
          //               : SliverList(
          //                   delegate: SliverChildBuilderDelegate(
          //                     (BuildContext context, int index) =>
          //                      ConversationGroupPeopleSearchResultCard(conversationGroupPeopleSearchResultState.conversations?.people![index]),
          //                     //ShareMsgFriendCard(type: FriendType.ALL, conversation: conversationGroupPeopleSearchResultState.conversations[index]),
          //                     childCount: conversationGroupPeopleSearchResultState.conversations?.people?.length,
          //                   ),
          //                 )
          //           : conversationGroupPeopleSearchResultState is ConversationGroupPeopleSearchLoadingState
          //               ? const SliverToBoxAdapter(child: KConversationLoadingIndicator())
          //               : SliverToBoxAdapter(
          //                   child: Container(),
          //                 );
          //     }),
          //   ],
          // ),
        ),
      ),
    );
  }
}
