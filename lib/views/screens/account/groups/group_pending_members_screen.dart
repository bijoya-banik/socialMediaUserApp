import 'package:buddyscripts/controller/group/group_pending_member_controller.dart';
import 'package:buddyscripts/controller/group/state/group_pending_member_state.dart';
import 'package:buddyscripts/models/group/group_pending_member_model.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupPendingMemberScreen extends StatefulWidget {
  const GroupPendingMemberScreen({Key? key}) : super(key: key);

  @override
  _GroupPendingMemberScreenState createState() => _GroupPendingMemberScreenState();
}

class _GroupPendingMemberScreenState extends State<GroupPendingMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final memberState = ref.watch(groupPendingMemberProvider);
      return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: 'Pending Members',
          automaticallyImplyLeading: false,
          hasLeading: true,
        ),
        child: memberState is GroupPendingMemberSuccessState
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: KSize.getHeight(context, 20)),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          memberState.groupPendingMemberModel.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.only(top: KSize.getHeight(context, 10)),
                                  padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 15)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: memberState.groupPendingMemberModel.length,
                                    itemBuilder: (context, index) {
                                      return PendingMemberCard(memberState.groupPendingMemberModel[index]);
                                    },
                                  ),
                                )
                              : Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                                    child: const KContentUnvailableComponent(message: "No pending members"),
                                  ),
                                )
                        ],
                      ),
                    ]),
                  ],
                ),
              )
            : const Center(child: CupertinoActivityIndicator()),
      );
    });
  }
}

class PendingMemberCard extends ConsumerStatefulWidget {
  final GroupPendingMemberModel data;
  const PendingMemberCard(this.data, {Key? key}) : super(key: key);

  @override
  _PendingMemberCardState createState() => _PendingMemberCardState();
}

class _PendingMemberCardState extends ConsumerState<PendingMemberCard> {
  bool isAccept = false;
  bool isDelete = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: KSize.getHeight(context, 15)),
      child: Row(
        children: [
          UserProfilePicture(profileURL: widget.data.user!.profilePic, avatarRadius: 22.5),
          SizedBox(width: KSize.getWidth(context, 5)),
          Expanded(
            child: UserName(
              backgroundColor: KColor.transparent!,
              name: widget.data.user!.firstName! + " " + widget.data.user!.lastName!,
              onTapNavigate: false,
              textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: [
              SizedBox(
                  width: KSize.getWidth(context, 75),
                  height: 40,
                  child: KButton(
                    title: isAccept ? "Loading.." : "Accept",
                    color: isAccept ? KColor.grey : KColor.primary,
                    innerPadding: 5,
                    onPressedCallback: () async {
                      if (!isAccept) {
                        setState(() {
                          isAccept = true;
                        });

                        await ref.read(groupPendingMemberProvider.notifier).acceptRequest(friendId: widget.data.user!.id, grpId: widget.data.groupId);
                        setState(() {
                          isAccept = false;
                        });
                      }
                    },
                  )),
              const SizedBox(width: 5),
              SizedBox(
                  width: KSize.getWidth(context, 75),
                  height: 40,
                  child: KButton(
                    title: isDelete ? "Loading.." : "Delete",
                    color: isDelete ? KColor.grey : KColor.textBackground,
                    textColor: KColor.black,
                    innerPadding: 5,
                    onPressedCallback: () async {
                      if (!isDelete) {
                        setState(() {
                          isDelete = true;
                        });

                        await ref.read(groupPendingMemberProvider.notifier).deleteRequest(friendId: widget.data.user!.id, grpId: widget.data.groupId);
                        setState(() {
                          isDelete = false;
                        });
                      }
                    },
                  )),
            ],
          )
        ],
      ),
    );
  }
}
