import 'package:buddyscripts/controller/group/group_invite_member_controller.dart';
import 'package:buddyscripts/models/group/group_members_model.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupMemberCard extends ConsumerStatefulWidget {
  final GroupMember groupMemberData;
  final dynamic basicOverView;
  const GroupMemberCard({Key? key, required this.groupMemberData, required this.basicOverView}) : super(key: key);

  @override
  _GroupMemberCardState createState() => _GroupMemberCardState();
}

class _GroupMemberCardState extends ConsumerState<GroupMemberCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: KSize.getHeight(context, 5)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserProfilePicture(
                avatarRadius: 25,
                iconSize: 24.5,
                profileURL: widget.groupMemberData.user!.profilePic,
                slug: widget.groupMemberData.user!.username,
                userId: widget.groupMemberData.user!.id,
                type: 'profile',
                onTapNavigate: true,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: KSize.getHeight(context, 10)),
                    UserName(
                      name: '${widget.groupMemberData.user!.firstName} ${widget.groupMemberData.user!.lastName}',
                      slug: widget.groupMemberData.user!.username,
                      type: 'profile',
                      userId: widget.groupMemberData.user!.id,
                      backgroundColor: KColor.white,
                      onTapNavigate: true,
                      textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: KSize.getHeight(context, 6)),
                    Row(
                      children: [
                        Icon(
                            widget.groupMemberData.isAdmin == 'super admin' || widget.groupMemberData.isAdmin == 'admin'
                                ? MaterialCommunityIcons.shield_account
                                : MaterialIcons.account_circle,
                            size: 15,
                            color: KColor.black87),
                        SizedBox(width: KSize.getWidth(context, 3)),
                        Text(
                          widget.groupMemberData.isAdmin == 'super admin'
                              ? 'Super Admin'
                              : widget.groupMemberData.isAdmin == 'admin'
                                  ? 'Admin'
                                  : 'Member',
                          style: KTextStyle.bodyText3.copyWith(color: KColor.black87, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: KSize.getHeight(context, 10)),
                    widget.basicOverView.isMember == null
                        ? Container()
                        : widget.basicOverView.isMember.userId == widget.groupMemberData.userId ||
                                widget.basicOverView.isMember.isAdmin == "user" ||
                                widget.groupMemberData.isAdmin == 'super admin'
                            ? Container()
                            : Row(
                                children: [
                                  Visibility(
                                    visible: widget.basicOverView.isMember.isAdmin != "admin",
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.30,
                                      child: KButton(
                                        title: isLoading
                                            ? "Please wait..."
                                            : widget.groupMemberData.isAdmin == 'admin'
                                                ? 'Remove Admin'
                                                : 'Make Admin',
                                        color: isLoading ? KColor.grey : KColor.primary,
                                        textColor: KColor.whiteConst,
                                        innerPadding: 7,
                                        onPressedCallback: isLoading
                                            ? null
                                            : () async {
                                                if (!mounted) return;
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                if (widget.groupMemberData.isAdmin == 'admin') {
                                                  await ref
                                                      .read(groupInviteMemberProvider.notifier)
                                                      .removeAdmin(groupId: widget.basicOverView.id, userData: widget.groupMemberData);
                                                } else {
                                                  await ref
                                                      .read(groupInviteMemberProvider.notifier)
                                                      .makeAdmin(groupId: widget.basicOverView.id, userData: widget.groupMemberData);
                                                }
                                                if (!mounted) return;
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: KSize.getWidth(context, 5)),
                                  Visibility(
                                    visible: widget.groupMemberData.isAdmin != 'admin',
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.30,
                                      child: KButton(
                                        title: 'Remove',
                                        textColor: KColor.whiteConst,
                                        innerPadding: 7,
                                        onPressedCallback: () {
                                          KDialog.kShowDialog(
                                              context,
                                              ConfirmationDialogContent(
                                                  titleContent: 'Are you sure want to remove this member?',
                                                  onPressedCallback: () => {
                                                        Navigator.pop(context),
                                                        KDialog.kShowDialog(
                                                          context,
                                                          const ProcessingDialogContent("Processing..."),
                                                          barrierDismissible: false,
                                                        ),
                                                        ref
                                                            .read(groupInviteMemberProvider.notifier)
                                                            .removeMember(groupId: widget.basicOverView.id, userId: widget.groupMemberData.userId)
                                                      }),
                                              useRootNavigator: false);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
