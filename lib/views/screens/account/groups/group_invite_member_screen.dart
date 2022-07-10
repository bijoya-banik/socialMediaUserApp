import 'package:buddyscripts/controller/group/group_invite_member_controller.dart';
import 'package:buddyscripts/controller/group/state/group_invite_member_state.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/group/group_invite_member_model.dart';

class GroupInviteMembersScreen extends StatefulWidget {
  final int? groupId;

  const GroupInviteMembersScreen({Key? key, this.groupId}) : super(key: key);

  @override
  _GroupInviteMembersScreenState createState() => _GroupInviteMembersScreenState();
}

class _GroupInviteMembersScreenState extends State<GroupInviteMembersScreen> {
  TextEditingController searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final groupInviteMemberState = ref.watch(groupInviteMemberProvider);
      return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: 'Invite Members',
          automaticallyImplyLeading: false,
          hasLeading: true,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                child: Text('Search for people to Invite', style: KTextStyle.headline5.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
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
                  suffixCallback: true,
                  suffixCallbackFunction: () {
                    ref.read(groupInviteMemberProvider.notifier).changeState();
                  },
                  callBack: true,
                  callBackFunction: (String value) {
                    if (value.isNotEmpty) {
                      _debouncer.run(() => ref.read(groupInviteMemberProvider.notifier).searchMembers(groupId: widget.groupId!, searchedString: value));
                    }
                  },
                ),
              ),
              SizedBox(height: KSize.getHeight(context, 20)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Visibility(
                    visible: groupInviteMemberState is GroupInviteMemberSuccessState && groupInviteMemberState.groupinviteMemberModel.isNotEmpty,
                    child: SizedBox(height: KSize.getHeight(context, 20))),

                //Suggested
                Visibility(
                  visible: groupInviteMemberState is GroupInviteMemberSuccessState && groupInviteMemberState.groupinviteMemberModel.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                        child: Text('Suggested', style: KTextStyle.bodyText1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      ),
                      if (groupInviteMemberState is GroupInviteMemberSuccessState)
                        Container(
                          margin: EdgeInsets.only(top: KSize.getHeight(context, 10)),
                          padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: groupInviteMemberState.groupinviteMemberModel.length,
                            itemBuilder: (context, index) {
                              var member = groupInviteMemberState.groupinviteMemberModel[index];
                              return SearchResultCard(member: member, groupId: widget.groupId, search: false);
                            },
                          ),
                        )
                    ],
                  ),
                ),

                // Search Result
                Visibility(
                  visible: groupInviteMemberState is GroupInviteMemberSearchResultSuccessState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                        child: Text('Search Result', style: KTextStyle.bodyText1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                      ),
                      if (groupInviteMemberState is GroupInviteMemberSearchResultSuccessState)
                        if (groupInviteMemberState.groupinviteMemberSearchResultModel.isEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .50,
                            child: Center(
                              child: Text("No result found", style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                            ),
                          )
                        else
                          Container(
                            margin: EdgeInsets.only(top: KSize.getHeight(context, 10)),
                            padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: groupInviteMemberState.groupinviteMemberSearchResultModel.length,
                              itemBuilder: (context, index) {
                                var member = groupInviteMemberState.groupinviteMemberSearchResultModel[index];
                                return SearchResultCard(member: member, groupId: widget.groupId, search: true);
                              },
                            ),
                          )
                    ],
                  ),
                ),

                /// Loading Indicator
                Visibility(visible: groupInviteMemberState is GroupInviteMemberLoadingState, child: const KPagesLoadingIndicator())
              ]),
            ],
          ),
        ),
      );
    });
  }
}

class SearchResultCard extends ConsumerStatefulWidget {
  final GroupInviteMemberModel? member;
  final int? groupId;
  final bool search;
  const SearchResultCard({Key? key, this.member, this.groupId, this.search = false}) : super(key: key);

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
          UserProfilePicture(profileURL: widget.member?.profilePic, avatarRadius: 22.5),
          SizedBox(width: KSize.getWidth(context, 5)),
          Expanded(
            child: UserName(
              name: '${widget.member?.firstName} + ${widget.member?.lastName}',
              onTapNavigate: false,
              backgroundColor: AppMode.darkMode ? KColor.darkAppBackground : KColor.appBackground,
              textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.w600),
            ),
          ),
          Visibility(
            visible: widget.member?.status == null,
            child: SizedBox(
                width: KSize.getWidth(context, 75),
                child: KButton(
                  title: isLoading ? "Wait..." : 'Invite',
                  color: isLoading ? KColor.grey : KColor.primary,
                  innerPadding: 10,
                  onPressedCallback: isLoading
                      ? null
                      : () async {
                          if (!mounted) return;
                          setState(() {
                            isLoading = true;
                          });

                          await ref
                              .read(groupInviteMemberProvider.notifier)
                              .inviteMemberToGroup(userId: widget.member!.id!,
                               groupId: widget.groupId!, search: widget.search);

                          if (!mounted) return;
                          setState(() {
                            isLoading = false;
                          });
                        },
                )),
          )
        ],
      ),
    );
  }
}
