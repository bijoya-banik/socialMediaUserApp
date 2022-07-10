import 'package:buddyscripts/controller/chat/conversations_controller.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageOptionsModal extends ConsumerWidget {
  final int buddyId;
  final ConversationsModel conversation;
  final bool isPlatformIos;
  const MessageOptionsModal(this.buddyId, this.conversation, {Key? key, this.isPlatformIos = false}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isPlatformIos
        ? CupertinoTheme(
            data: CupertinoThemeData(
              brightness: AppMode.darkMode ? Brightness.dark : Brightness.light,
            ),
            child: CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: Text(conversation.isSeen == 0 ? 'Mark as read' : 'Mark as unread'),
                  onPressed: () {
                    if (conversation.isSeen == 0) {
                      ref.read(conversationsProvider.notifier).seenConversation(conversation.id, buddyId);
                    } else {
                      ref.read(conversationsProvider.notifier).unseenConversation(conversation.id, buddyId);
                    }

                    Navigator.pop(context);
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('Delete'),
                  isDestructiveAction: true,
                  onPressed: () {
                    ref.read(conversationsProvider.notifier).deleteConversation(buddyId);
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
            height: MediaQuery.of(context).size.height * 0.23,
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
                  title: Text('Delete', 
                  style: KTextStyle.subtitle2.copyWith(color: KColor.red)),
                  onTap: () {
                    ref.read(conversationsProvider.notifier).deleteConversation(buddyId);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                    leading: CircleAvatar(
                      radius: 23,
                      backgroundColor: KColor.green!.withOpacity(0.1),
                      child: Icon(Icons.done_all, color: KColor.green),
                    ),
                    title: Text(
                      conversation.isSeen == 0 ? 'Mark as read' : 'Mark as unread',
                      style: KTextStyle.subtitle2.copyWith(color: KColor.black87),
                    ),
                    onTap: () {
                      print(conversation.isSeen);
                      if (conversation.isSeen == 0) {
                        ref.read(conversationsProvider.notifier).seenConversation(conversation.id, buddyId);
                      } else {
                        ref.read(conversationsProvider.notifier).unseenConversation(conversation.id, buddyId);
                      }

                      Navigator.pop(context);
                    }),
              ],
            ),
          );
  }
}
