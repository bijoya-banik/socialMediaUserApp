import 'package:buddyscripts/controller/group/group_category_controller.dart';
import 'package:buddyscripts/controller/group/group_controller.dart';
import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/models/group/groups_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/screens/account/groups/edit_group_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/screens/account/groups/group_details_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class GroupCard extends ConsumerWidget {
  final GroupDatum? groupData;
  final dynamic grouptype;
  const GroupCard(this.groupData, this.grouptype, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(groupFeedProvider.notifier).fetchGroupFeed(groupData!.slug!);
        Navigator.push(context, CupertinoPageRoute(builder: (context) => GroupDetailsScreen()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.425,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: grouptype == GroupType.MYGROUP ? 0 : 15),
        decoration:
            BoxDecoration(color: AppMode.darkMode ? KColor.appBackground : KColor.white, borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Column(
          children: [
            Visibility(
              visible: grouptype == GroupType.MYGROUP,
              child: Align(
                alignment: Alignment.topRight,
                child: PopupMenuButton(
                  tooltip: '',
                  onSelected: (selected) {
                    if (selected == 'edit') {
                      ref.read(groupCategoryProvider.notifier).fetchGroupCategory();
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(fullscreenDialog: true, builder: (context) => EditGroupScreen(groupData)),
                      );
                    } else if (selected == 'delete') {
                      KDialog.kShowDialog(
                          context,
                          ConfirmationDialogContent(
                              titleContent: 'Are you sure want to delete this group?',
                              onPressedCallback: () => {
                                    Navigator.pop(context),
                                    KDialog.kShowDialog(
                                      context,
                                      const ProcessingDialogContent("Processing..."),
                                      barrierDismissible: false,
                                    ),
                                    ref.read(groupProvider.notifier).deleteGroup(groupData!.id!)
                                  }),
                          useRootNavigator: false);
                    }
                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  color: AppMode.darkMode ? KColor.feedActionCircle : KColor.appBackground,
                  offset: const Offset(0, 40),
                  icon: Icon(MaterialIcons.more_horiz, color: KColor.black87),
                  itemBuilder: (_) => <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                        value: "edit",
                        child: Text(
                          'Edit',
                          style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                        )),
                    PopupMenuItem<String>(
                        value: "delete",
                        child: Text(
                          'Delete',
                          style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                        )),
                  ],
                ),
              ),
            ),
            Container(
              height: KSize.getHeight(context, 95),
              width: KSize.getWidth(context, 95),
              decoration: BoxDecoration(
                color: KColor.white,
                shape: BoxShape.circle,
                border: Border.all(color: KColor.primary.withOpacity(0.25)),
                image: DecorationImage(
                  image: NetworkImage(groupData!.cover ?? "https://ewr1.vultrobjects.com/filestore/ckybofioi00eb4jh2bkk5gebs.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: KSize.getHeight(context, 12)),
            Text(groupData?.groupName ?? "",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w700, color: KColor.black87)),
            SizedBox(height: KSize.getHeight(context, 5)),
            Text(groupData!.totalMembers! > 1 ? '${groupData!.totalMembers} members' : '${groupData!.totalMembers} member',
                style: KTextStyle.bodyText3.copyWith(color: KColor.black54)),
            SizedBox(height: KSize.getHeight(context, 20)),
          ],
        ),
      ),
    );
  }
}
