import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/chat/conversation_search_controller.dart';
import 'package:buddyscripts/controller/chat/group_chat_member_controller.dart';
import 'package:buddyscripts/controller/chat/state/conversation_search_state.dart';
import 'package:buddyscripts/models/chats/participant_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_conversations_loading_indicator.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/messages/group_chat/group_chat_name_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

class AddParticipateScreen extends ConsumerStatefulWidget {
  final int isGroup;
  final int? inboxId;
  const AddParticipateScreen({Key? key, this.isGroup = 0, this.inboxId}) : super(key: key);

  @override
  _AddParticipateScreenState createState() => _AddParticipateScreenState();
}

class _AddParticipateScreenState extends ConsumerState<AddParticipateScreen> {
  TextEditingController searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  TextEditingController msgController = TextEditingController();
  //bool _search = false;
  // bool _initSearch = true;
  List<ParticipateModel> participants = [];
  List participantsId = [];

  @override
  void initState() {
    // if (widget.isGroup == 1) {
    //   _initSearch = false;
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: "Add Participant",
          automaticallyImplyLeading: true,
          trailing: GestureDetector(
              onTap: () async {
                if (participants.isEmpty) return toast('Select participants first', bgColor: KColor.red);
                if (widget.isGroup == 1) {
                  KDialog.kShowDialog(
                    context,
                    const ProcessingDialogContent("Processing..."),
                    barrierDismissible: false,
                  );

                  await ref.read(groupChatMemberProvider.notifier).addMember(inboxId: widget.inboxId, userId: participantsId);

                  Navigator.of(context).pop();
                } else {
                  if (participants.length > 1) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => GroupChatNameScreen(
                                  participants: participants,
                                  participantsId: participantsId,
                                )));
                  } else {
                    toast("Select one more friend to create group", bgColor: KColor.red);
                  }
                }
              },
              child: widget.isGroup == 0
                  ? Text("Next", style: KTextStyle.subtitle2.copyWith(color: participants.length > 1 ? KColor.black : KColor.greyconst))
                  : Text("Add", style: KTextStyle.subtitle2.copyWith(color: KColor.black))),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
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
                        ref.read(conversationSearchResultProvider.notifier).refresh([]);
                      },
                      callBackFunction: (String value) {
                        // setState(() {
                        //   _search = true;
                        // });
                        if (value.isNotEmpty) {
                          _debouncer.run(() {
                            if (widget.isGroup == 1) {
                              // setState(() {
                              //   _initSearch = true;
                              // });
                              ref.read(conversationSearchResultProvider.notifier).searchForGroupMember(str: value, inboxId: widget.inboxId);
                            } else {
                              ref.read(conversationSearchResultProvider.notifier).searchConversation(value);
                            }
                          });
                        }
                      },
                    ),
                    participants.isNotEmpty
                        ? Container(
                            height: KSize.getHeight(context, 120),
                            margin: EdgeInsets.symmetric(vertical: KSize.getWidth(context, 12)),
                            padding: EdgeInsets.only(
                              left: KSize.getWidth(context, 12),
                              top: KSize.getWidth(context, 16),
                              bottom: KSize.getWidth(context, 10),
                            ),
                            alignment: Alignment.centerLeft,
                            // color: AppMode.darkMode ? KColor.darkAppBackground : KColor.white,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: participants.length,
                                itemBuilder: (context, index) {
                                  return participateContainer(participants[index]);
                                }),
                          )
                        : SizedBox(height: KSize.getHeight(context, 12)),
                  ],
                ),
              ),
            ),

            /// Search Conversation
            // !_initSearch
            //     ? SliverToBoxAdapter(child: Container())
            //     :
            // _search
            //     ?
            Consumer(builder: (context, ref, _) {
              final conversationsSearchResultState = ref.watch(conversationSearchResultProvider);
              return conversationsSearchResultState is ConversationSearchSuccessState
                  ? conversationsSearchResultState.conversations.isEmpty
                      ? SliverToBoxAdapter(
                          child: SizedBox(
                          height: MediaQuery.of(context).size.height * .50,
                          child: Center(
                            child: Text("No Result Found", style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                          ),
                        ))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return addParticipateContainer(
                                  conversationsSearchResultState.conversations[index].firstName!,
                                  conversationsSearchResultState.conversations[index].lastName!,
                                  conversationsSearchResultState.conversations[index].username!,
                                  conversationsSearchResultState.conversations[index].profilePic!,
                                  conversationsSearchResultState.conversations[index].id!);
                            },
                            childCount: conversationsSearchResultState.conversations.length,
                          ),
                        )
                  : conversationsSearchResultState is ConversationSearchLoadingState
                      ? const SliverToBoxAdapter(child: KConversationLoadingIndicator())
                      : SliverToBoxAdapter(
                          child: Container(),
                        );
            })
            //  : SliverToBoxAdapter(child: Container())
            // : Consumer(builder: (context, ref, _) {
            //     final conversationsResultState = ref.watch(conversationsProvider);
            //     return conversationsResultState is ConversationsSuccessState
            //         ? conversationsResultState.conversations.isEmpty
            //             ? SliverToBoxAdapter(
            //                 child: SizedBox(
            //                 height: MediaQuery.of(context).size.height * .50,
            //                 child: Center(
            //                   child: Text("No Result Found", style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
            //                 ),
            //               ))
            //             : SliverList(
            //                 delegate: SliverChildBuilderDelegate(
            //                   (BuildContext context, int index) {
            //                     return conversationsResultState.conversations[index].buddy == null
            //                         ? Container()
            //                         : addParticipateContainer(
            //                             conversationsResultState.conversations[index].buddy!.firstName!,
            //                             conversationsResultState.conversations[index].buddy!.lastName!,
            //                             conversationsResultState.conversations[index].buddy!.username!,
            //                             conversationsResultState.conversations[index].buddy!.profilePic!,
            //                             conversationsResultState.conversations[index].buddy!.id!);
            //                   },
            //                   childCount: conversationsResultState.conversations.length,
            //                 ),
            //               )
            //         : conversationsResultState is ConversationsLoadingState
            //             ? const SliverToBoxAdapter(child: KConversationLoadingIndicator())
            //             : SliverToBoxAdapter(
            //                 child: Container(),
            //               );
            //   })
          ],
        ),
      ),
    );
  }

  Container participateContainer(ParticipateModel? participant) {
    return Container(
      alignment: Alignment.centerLeft,
      width: KSize.getWidth(context, 60),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: KSize.getHeight(context, 55),
                width: KSize.getWidth(context, 55),
                child: CircleAvatar(
                    backgroundImage: const AssetImage(AssetPath.profilePlaceholder), foregroundImage: NetworkImage(participant!.profilePic!)),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      participants.remove(participant);
                      participantsId.remove(participant.userId);
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppMode.darkMode ? KColor.grey800 : KColor.grey300!.withOpacity(0.7),
                      ),
                      child: Icon(Icons.close, size: 15, color: KColor.black)),
                ),
              ),
            ],
          ),
          SizedBox(height: KSize.getHeight(context, 8)),
          Text(
            '${participant.firstName}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: KTextStyle.bodyText3.copyWith(fontSize: 11, color: KColor.black),
          )
        ],
      ),
    );
  }

  Container addParticipateContainer(final String firstName, final String lastName, final String userName, final String profilePicture, final int id) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () {
          setState(() {
            if (participantsId.contains(id)) {
              setState(() {
                participants.removeWhere((element) => element.userId == id);
                participantsId.remove(id);
              });
            } else {
              participants
                  .add(ParticipateModel(userId: id, firstName: firstName, lastName: lastName, userName: userName, profilePic: profilePicture));

              participantsId.add(id);
            }
          });
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserProfilePicture(avatarRadius: 16, profileURL: profilePicture, onTapNavigate: false, slug: userName),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: KSize.getHeight(context, 10)),
                      Row(
                        children: [
                          Expanded(
                            child: UserName(
                              name: "$firstName $lastName",
                              onTapNavigate: false,
                              type: 'profile',
                              slug: userName,
                              userId: id,
                              overflowVisible: true,
                              backgroundColor: KColor.transparent!,
                              textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w600),
                            ),
                          ),
                          !participantsId.contains(id)
                              ? Icon(Icons.radio_button_unchecked, color: KColor.black54.withOpacity(0.5))
                              : Icon(Icons.check_circle, color: KColor.black)
                        ],
                      ),
                      SizedBox(height: KSize.getHeight(context, 7)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: KSize.getHeight(context, 12)),
          ],
        ),
      ),
    );
  }
}
