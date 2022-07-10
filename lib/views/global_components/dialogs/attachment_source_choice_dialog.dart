import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class AttachmentSourceChoiceDialog extends StatefulWidget {
  final bool isAllowFiles;

  const AttachmentSourceChoiceDialog({Key? key, this.isAllowFiles = false}) : super(key: key);

  @override
  _AttachmentSourceChoiceDialogState createState() => _AttachmentSourceChoiceDialogState();
}

class _AttachmentSourceChoiceDialogState extends State<AttachmentSourceChoiceDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KColor.textBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Text("Select attachment source:", style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.black)),
      actions: <Widget>[
        MaterialButton(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppMode.darkMode ? KColor.feedActionCircle : KColor.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Icon(CupertinoIcons.camera_fill, color: AppMode.darkMode ? KColor.black54 : KColor.primary)),
              const SizedBox(height: 5),
              Text("Camera", style: KTextStyle.caption.copyWith(color: KColor.black)),
              const SizedBox(height: 5),
            ],
          ),
          onPressed: () => Navigator.pop(context, ImageSource.camera),
        ),
        MaterialButton(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppMode.darkMode ? KColor.feedActionCircle : KColor.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Icon(Icons.image, color: AppMode.darkMode ? KColor.black54 : KColor.primary)),
              const SizedBox(height: 5),
              Text("Gallery", style: KTextStyle.caption.copyWith(color: KColor.black)),
              const SizedBox(height: 5),
            ],
          ),
          onPressed: () => Navigator.pop(context, ImageSource.gallery),
        ),
        if (widget.isAllowFiles)
          MaterialButton(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: KColor.primary.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: Icon(Icons.file_copy, color: KColor.primary, size: 35)),
                const SizedBox(height: 5),
                Text("Files", style: KTextStyle.caption),
                const SizedBox(height: 5),
              ],
            ),
            onPressed: () => Navigator.pop(context, 'application'),
          )
      ],
    );
  }
}
