import 'package:buddyscripts/controller/story/all_story_controller.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/screens/story/models/story_model.dart';
import 'package:buddyscripts/views/screens/story/story_slider_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryOptionsModal extends ConsumerStatefulWidget {
  final AnimationController animBarController;
  final Story story;

  final int index;
  final bool isPlatformIos;
  const StoryOptionsModal(this.animBarController, this.story, this.index, {Key? key, this.isPlatformIos = false}) : super(key: key);

  @override
  _StoryOptionsModalState createState() => _StoryOptionsModalState();
}

class _StoryOptionsModalState extends ConsumerState<StoryOptionsModal> {
  @override
  Widget build(BuildContext context) {
    return widget.isPlatformIos
        ? CupertinoTheme(
            data: CupertinoThemeData(
              brightness: AppMode.darkMode ? Brightness.dark : Brightness.light,
            ),
            child: CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('Delete'),
                  isDestructiveAction: true,
                  onPressed: () async {
                    disposeBottomSheet = false;
                    Navigator.pop(context);

                    KDialog.kShowDialog(
                      context,
                      const ProcessingDialogContent("Processing..."),
                      barrierDismissible: false,
                    );
                    await ref.read(allstoryProvider.notifier).deleteStory(widget.story, widget.animBarController, widget.index);
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancel'),
                isDefaultAction: true,
                onPressed: () {
                  widget.animBarController.forward();
                },
              ),
            ),
          )
        : Container(
            color: KColor.textBackground,
            height: MediaQuery.of(context).size.height * 0.18,
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
                  title: Text('Delete', style: KTextStyle.subtitle2.copyWith(color: KColor.primary)),
                  onTap: () async {
                    disposeBottomSheet = false;
                    Navigator.pop(context);

                    KDialog.kShowDialog(
                      context,
                      const ProcessingDialogContent("Processing..."),
                      barrierDismissible: false,
                    );
                    await ref.read(allstoryProvider.notifier).deleteStory(widget.story, widget.animBarController, widget.index);
                  },
                ),
              ],
            ),
          );
  }
}
