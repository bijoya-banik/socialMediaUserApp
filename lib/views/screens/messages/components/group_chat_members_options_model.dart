import 'package:buddyscripts/controller/chat/group_chat_member_controller.dart';
import 'package:buddyscripts/models/group_chat/group_chat_members_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupChatMemberOptionsModal extends ConsumerWidget {
  final GroupChatMemberModel? groupMember;
  final bool isPlatformIos;
  const GroupChatMemberOptionsModal(this.groupMember, {Key? key, this.isPlatformIos = false}) : super(key: key);
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
                  child: Text(groupMember?.role == "SUPER ADMIN" || groupMember?.role == "ADMIN" ? "Remove Admin" : "Make Admin",
                      style: KTextStyle.subtitle2.copyWith(color: KColor.black87)),
                  onPressed: () async {
                    KDialog.kShowDialog(
                      context,
                      const ProcessingDialogContent("Processing..."),
                      barrierDismissible: false,
                    );

                    if (groupMember?.role == "SUPER ADMIN" || groupMember?.role == "ADMIN") {
                      await ref.read(groupChatMemberProvider.notifier).removeAdminRole(inboxId: groupMember?.inboxId, buddyId: groupMember?.userId);
                    } else {
                      await ref.read(groupChatMemberProvider.notifier).makeAdmin(groupMember: groupMember!);
                    }

                    Navigator.of(context).pop();
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text('Remove Member', style: KTextStyle.subtitle2.copyWith(color: KColor.primary)),
                  isDestructiveAction: true,
                  onPressed: () async {
                    KDialog.kShowDialog(
                      context,
                      const ProcessingDialogContent("Processing..."),
                      barrierDismissible: false,
                    );

                    await ref.read(groupChatMemberProvider.notifier).removeMember(inboxId: groupMember?.inboxId, buddyId: groupMember?.userId);

                    Navigator.of(context).pop();
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
                    backgroundColor: KColor.black.withOpacity(0.1),
                    child: Icon(Icons.person, color: KColor.black87),
                  ),
                  title: Text(groupMember?.role == "SUPER ADMIN" || groupMember?.role == "ADMIN" ? "Remove Admin" : "Make Admin",
                      style: KTextStyle.subtitle2.copyWith(color: KColor.black87)),
                  onTap: () async {
                    KDialog.kShowDialog(
                      context,
                      const ProcessingDialogContent("Processing..."),
                      barrierDismissible: false,
                    );

                    if (groupMember?.role == "SUPER ADMIN" || groupMember?.role == "ADMIN") {
                      await ref.read(groupChatMemberProvider.notifier).removeAdminRole(inboxId: groupMember?.inboxId, buddyId: groupMember?.userId);
                    } else {
                      await ref.read(groupChatMemberProvider.notifier).makeAdmin(groupMember: groupMember!);
                    }

                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundColor: KColor.black.withOpacity(0.1),
                    child: Icon(Icons.delete, color: KColor.primary),
                  ),
                  title: Text('Remove Member', style: KTextStyle.subtitle2.copyWith(color: KColor.primary)),
                  onTap: () async {
                    KDialog.kShowDialog(
                      context,
                      const ProcessingDialogContent("Processing..."),
                      barrierDismissible: false,
                    );

                    await ref.read(groupChatMemberProvider.notifier).removeMember(inboxId: groupMember?.inboxId, buddyId: groupMember?.userId);

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
  }
}
