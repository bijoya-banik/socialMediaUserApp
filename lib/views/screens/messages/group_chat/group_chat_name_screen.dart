import 'package:buddyscripts/controller/chat/group_chat_controller.dart';
import 'package:buddyscripts/models/chats/participant_model.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

class GroupChatNameScreen extends ConsumerStatefulWidget {
  final List<ParticipateModel> participants;
  final List participantsId;

  const GroupChatNameScreen({Key? key, required this.participants, required this.participantsId}) : super(key: key);

  @override
  _GroupChatNameScreenState createState() => _GroupChatNameScreenState();
}

class _GroupChatNameScreenState extends ConsumerState<GroupChatNameScreen> {
  TextEditingController groupNameController = TextEditingController();
  String groupName = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: "New group chat",
          automaticallyImplyLeading: true,
          trailing: GestureDetector(
            onTap: () async {
              if (groupName.isEmpty) {
                toast("Enter group name", bgColor: KColor.red);
              } else {
                KDialog.kShowDialog(
                  context,
                  const ProcessingDialogContent("Processing..."),
                  barrierDismissible: false,
                );

                await ref.read(groupChatProvider.notifier).createGroupChat(groupChatName: groupName, userIdList: widget.participantsId);
              }
            },
            child: Text("Create", style: KTextStyle.subtitle2.copyWith(color: groupName.isNotEmpty ? KColor.black : KColor.greyconst)),
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: TextFormField(
                        cursorColor: KColor.grey,
                        style: KTextStyle.bodyText1.copyWith(color: KColor.black87),
                        autofocus: true,
                        controller: groupNameController,
                        decoration: InputDecoration(
                            hintText: "Group name",
                            hintStyle: KTextStyle.subtitle2.copyWith(color: KColor.black54),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: KColor.black),
                            )),
                        onChanged: (val) {
                          setState(() {
                            groupName = groupNameController.text;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return membersContainer(widget.participants[index].firstName!, widget.participants[index].lastName!,
                      widget.participants[index].userName!, widget.participants[index].profilePic!, widget.participants[index].userId!);
                },
                childCount: widget.participants.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container membersContainer(final String firstName, final String lastName, final String userName, final String profilePicture, final int id) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
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
                            textStyle: KTextStyle.subtitle1.copyWith(fontSize: 18, color: KColor.black87, fontWeight: FontWeight.w600),
                          ),
                        ),
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
    );
  }
}
