import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/screens/messages/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class ConversationGroupPeopleSearchResultCard extends ConsumerWidget {
  final dynamic data;
  final bool isGroup;

  const ConversationGroupPeopleSearchResultCard(this.data, this.isGroup, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();

        ref.read(chatProvider.notifier).fetchChat(id: data.id, group: isGroup ? 1 : 0, onlineChat: isGroup ? "" : data.isOnline);
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ChatScreen(
                      id: data.id,
                      firstName: isGroup ? data.groupName : data.firstName,
                      lastName: isGroup ? "" : data.lastName,
                      profilePic: isGroup ? data.groupLogo : data.profilePic,
                      userName: isGroup ? "" : data.username,
                      isOnline: isGroup ? data.memberNames : data.isOnline,
                      conversation: data,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          color: AppMode.darkMode ? KColor.blackConst : KColor.appBackground,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserProfilePicture(profileURL: isGroup ? data.groupLogo : data.profilePic, avatarRadius: 20, onTapNavigate: false, iconSize: 24.5),
            Expanded(
              child: UserName(
                name: isGroup ? "${data.groupName}" : "${data.firstName} ${data.lastName}",
                onTapNavigate: false,
                backgroundColor: AppMode.darkMode ? KColor.blackConst : KColor.appBackground,
                textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
