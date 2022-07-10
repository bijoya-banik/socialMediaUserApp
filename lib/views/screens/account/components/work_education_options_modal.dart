import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/screens/account/profile/work_add_edit_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class WorkEducationOptionsModal extends ConsumerWidget {
  final bool isPlatformIos;
  final WorkDatum? workData;
  final int? index;
  const WorkEducationOptionsModal({Key? key, this.workData, this.isPlatformIos = false, this.index}) : super(key: key);

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
                  child: const Text('Edit'),
                  onPressed: () => Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => WorkAddEditScreen(workData: workData!, isEdit: true, index: index))),
                ),
                CupertinoActionSheetAction(
                  child: const Text('Delete'),
                  isDestructiveAction: true,
                  onPressed: () async {
                    KDialog.kShowDialog(
                      NavigationService.navigatorKey.currentContext,
                      const ProcessingDialogContent("Deleting..."),
                      barrierDismissible: false,
                    );
                    List<WorkDatum> workDatum = ref.read(profileAboutProvider.notifier).profileOverviewModel!.basicOverView!.workData!;
                    workDatum.removeAt(index!);
                    await ref.read(userProvider.notifier).updateUserData(workData: workDatum, isWorkUpdate: true);
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
            color: KColor.appBackground,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 65,
                    height: 5,
                    decoration: BoxDecoration(color: KColor.grey200, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25)),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundColor: KColor.black.withOpacity(0.1),
                    child: Icon(Icons.edit_outlined, color: KColor.black),
                  ),
                  title: Text('Edit', style: KTextStyle.subtitle2.copyWith(color: KColor.black87)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (context) => WorkAddEditScreen(workData: workData!, isEdit: true, index: index)));
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundColor: KColor.red!.withOpacity(0.1),
                    child: Icon(Icons.delete, color: KColor.red),
                  ),
                  title: Text('Delete', style: KTextStyle.subtitle2.copyWith(color: KColor.primary)),
                  onTap: () async {
                    KDialog.kShowDialog(
                      NavigationService.navigatorKey.currentContext,
                      const ProcessingDialogContent("Deleting..."),
                      barrierDismissible: false,
                    );
                    List<WorkDatum> workDatum = ref.read(profileAboutProvider.notifier).profileOverviewModel!.basicOverView!.workData!;
                    workDatum.removeAt(index!);
                    await ref.read(userProvider.notifier).updateUserData(workData: workDatum, isWorkUpdate: true);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
  }
}
