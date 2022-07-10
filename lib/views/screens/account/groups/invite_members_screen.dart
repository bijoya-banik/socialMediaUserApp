import 'package:buddyscripts/controller/event/invite_member_controller.dart';
import 'package:buddyscripts/controller/event/state/invite_member_state.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InviteMembersScreen extends StatefulWidget {
  final int? eventId;

  const InviteMembersScreen({Key? key, this.eventId}) : super(key: key);

  @override
  _InviteMembersScreenState createState() => _InviteMembersScreenState();
}

class _InviteMembersScreenState extends State<InviteMembersScreen> {
  TextEditingController searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final inviteMemberState = ref.watch(inviteMemberProvider);
      return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: 'Invite Members',
          automaticallyImplyLeading: false,
          hasLeading: true,
          trailing: InkWell(
            onTap: () => Navigator.pop(context),
            child: Text('Done', style: KTextStyle.subtitle2.copyWith(color: KColor.whiteConst, fontWeight: FontWeight.w700)),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                child: Text('Search for people to Invite', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
              ),
              SizedBox(height: KSize.getHeight(context, 10)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                child: KTextField(
                  controller: searchController,
                  hintText: 'Search',
                  topMargin: 5,
                  hasPrefixIcon: true,
                  prefixIcon: Icon(Feather.search, color: KColor.black54, size: 20),
                  isClearableField: true,
                  callBack: true,
                  callBackFunction: (String value) {
                    if (value.isNotEmpty) {
                      _debouncer.run(() => ref.read(inviteMemberProvider.notifier).fetchMembers(id: widget.eventId, searchedString: value));
                    }
                  },
                ),
              ),
              SizedBox(height: KSize.getHeight(context, 20)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                /// Invited
                Visibility(
                  visible: inviteMemberState is InviteMemberSuccessState && inviteMemberState.inviteMemberModel.allInvitedMembers!.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                        child: Text('Invited', style: KTextStyle.bodyText1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                      ),
                      if (inviteMemberState is InviteMemberSuccessState)
                        Container(
                          color: KColor.white,
                          margin: EdgeInsets.only(top: KSize.getHeight(context, 10)),
                          padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: inviteMemberState.inviteMemberModel.allInvitedMembers!.length,
                            itemBuilder: (context, index) {
                              var member = inviteMemberState.inviteMemberModel.allInvitedMembers![index];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: KSize.getHeight(context, 15)),
                                child: Row(
                                  children: [
                                    UserProfilePicture(profileURL: member.friend!.profilePic, avatarRadius: 22.5),
                                    SizedBox(width: KSize.getWidth(context, 5)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          UserName(
                                            name: member.friend!.firstName! + " " + member.friend!.lastName!,
                                            onTapNavigate: false,
                                            backgroundColor: KColor.white,
                                            textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            member.status == 'going'
                                                ? 'Going'
                                                : member.status == 'interested'
                                                    ? 'Interested'
                                                    : 'Invited',
                                            style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                    ],
                  ),
                ),
                Visibility(
                    visible: inviteMemberState is InviteMemberSuccessState &&
                        inviteMemberState.inviteMemberModel.allFriends!.isNotEmpty &&
                        inviteMemberState.inviteMemberModel.allInvitedMembers!.isNotEmpty,
                    child: SizedBox(height: KSize.getHeight(context, 20))),

                ///Suggested
                Visibility(
                  visible: inviteMemberState is InviteMemberSuccessState && inviteMemberState.inviteMemberModel.allFriends!.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                        child: Text('Suggested', style: KTextStyle.bodyText1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                      ),
                      if (inviteMemberState is InviteMemberSuccessState)
                        Container(
                          color: KColor.white,
                          margin: EdgeInsets.only(top: KSize.getHeight(context, 10)),
                          padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: inviteMemberState.inviteMemberModel.allFriends!.length,
                            itemBuilder: (context, index) {
                              var member = inviteMemberState.inviteMemberModel.allFriends![index];
                              return SearchResultCard(member, isSuggested: true);
                            },
                          ),
                        )
                    ],
                  ),
                ),

                /// Search Result
                Visibility(
                  visible: inviteMemberState is InviteMemberSearchResultSuccessState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                        child: Text('Search Result', style: KTextStyle.bodyText1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                      ),
                      if (inviteMemberState is InviteMemberSearchResultSuccessState)
                        if (inviteMemberState.inviteMemberSearchResultModel.isEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .50,
                            child: const Center(child: Text("No result found")),
                          )
                        else
                          Container(
                            color: KColor.white,
                            margin: EdgeInsets.only(top: KSize.getHeight(context, 10)),
                            padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: inviteMemberState.inviteMemberSearchResultModel.length,
                              itemBuilder: (context, index) {
                                var member = inviteMemberState.inviteMemberSearchResultModel[index];
                                return SearchResultCard(member);
                              },
                            ),
                          )
                    ],
                  ),
                ),

                /// Loading Indicator
                Visibility(visible: inviteMemberState is InviteMemberLoadingState, child: const KPagesLoadingIndicator())
              ]),
            ],
          ),
        ),
      );
    });
  }
}

class SearchResultCard extends ConsumerStatefulWidget {
  final dynamic member;
  final bool isSuggested;
  const SearchResultCard(this.member, {Key? key, this.isSuggested = false}) : super(key: key);

  @override
  _SearchResultCardState createState() => _SearchResultCardState();
}

class _SearchResultCardState extends ConsumerState<SearchResultCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: KSize.getHeight(context, 15)),
      child: Row(
        children: [
          UserProfilePicture(profileURL: widget.member.friend.profilePic, avatarRadius: 22.5),
          SizedBox(width: KSize.getWidth(context, 5)),
          Expanded(
            child: UserName(
              name: widget.member.friend.firstName + " " + widget.member.friend.lastName,
              onTapNavigate: false,
              backgroundColor: KColor.white,
              textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
              width: KSize.getWidth(context, 75),
              child: KButton(
                title: isLoading
                    ? 'Loading'
                    : widget.member.status == 'accepted'
                        ? 'Invite'
                        : 'Invited',
                color: isLoading ? KColor.grey : KColor.primary,
                innerPadding: 10,
                onPressedCallback: () async {
                  if (!isLoading) {
                    if (widget.member.status == 'accepted') {
                      setState(() {
                        isLoading = true;
                      });
                      await ref.read(inviteMemberProvider.notifier).inviteMember(userId: widget.member.friendId, suggested: widget.isSuggested);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
              ))
        ],
      ),
    );
  }
}
