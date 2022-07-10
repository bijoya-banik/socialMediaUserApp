import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/views/screens/messages/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineFriendsComponent extends ConsumerWidget {
  final dynamic friendData;
  const OnlineFriendsComponent({Key? key, this.friendData}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(chatProvider.notifier).fetchChat(id: friendData.id, group: 0, onlineChat: friendData.isOnline);
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ChatScreen(
                      id: friendData.id,
                      firstName: friendData.firstName,
                      lastName: friendData.lastName,
                      userName: friendData.username,
                      profilePic: friendData.profilePic,
                      isOnline: friendData.isOnline,
                      conversation: ConversationsModel(isGroup: 0, ),
                    )));
      },
      child: Container(
        alignment: Alignment.centerLeft,
        width: KSize.getWidth(context, 60),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: KSize.getHeight(context, 50),
                  width: KSize.getWidth(context, 50),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: KColor.appThemeColor),
                    color: KColor.transparent,
                  ),
                  child: CircleAvatar(
                      backgroundImage: const AssetImage(AssetPath.profilePlaceholder), foregroundImage: NetworkImage(friendData.profilePic)),
                ),
                Positioned(
                  bottom: 0,
                  right: 7,
                  child: Container(
                    height: 9,
                    width: 9,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: friendData.isOnline == 'online' ? KColor.seenGreen : KColor.grey,
                        border: Border.all(width: 1, color: KColor.white)),
                  ),
                ),
              ],
            ),
            SizedBox(height: KSize.getHeight(context, 8)),
            Text(
              '${friendData.firstName}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: KTextStyle.bodyText3.copyWith(fontSize: 11, color: KColor.black),
            )
          ],
        ),
      ),
    );
  }
}
