import 'package:buddyscripts/controller/chat/group_chat_controller.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMuteModal extends ConsumerWidget {
  final bool isPlatformIos, muteStatus;
  final int? inboxId;

  const ChatMuteModal({Key? key, this.isPlatformIos = false, this.muteStatus = false, this.inboxId}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isPlatformIos
        ? CupertinoTheme(
            data: CupertinoThemeData(brightness: AppMode.darkMode ? Brightness.dark : Brightness.light),
            child: CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: Text(muteStatus ? 'Unmute' : 'Mute'),
                  isDestructiveAction: true,
                  onPressed: () async {
                    if (muteStatus) {
                      await ref.read(groupChatProvider.notifier).unmuteGroupChat(inboxId: inboxId);
                    } else {
                      await ref.read(groupChatProvider.notifier).muteGroupChat(inboxId: inboxId);
                    }

                    Navigator.pop(context);
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancel'),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          )
        : Container(
            color: KColor.textBackground,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 65,
                    height: 5,
                    decoration: BoxDecoration(color: KColor.grey100, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25)),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundColor: KColor.red!.withOpacity(0.1),
                    child: Icon(Icons.delete, color: KColor.red),
                  ),
                  title: Text(muteStatus ? 'Unmute' : 'Mute', style: KTextStyle.subtitle2.copyWith(color: KColor.red)),
                  onTap: () async {
                    if (muteStatus) {
                      await ref.read(groupChatProvider.notifier).unmuteGroupChat(inboxId: inboxId);
                    } else {
                      await ref.read(groupChatProvider.notifier).muteGroupChat(inboxId: inboxId);
                    }

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
  }
}
