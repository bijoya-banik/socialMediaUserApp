import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

// ignore: must_be_immutable
class FileOptionsDialogContent extends ConsumerWidget {
  FileOptionsDialogContent({Key? key}) : super(key: key);

  List attachmentOptions = [
    {'title': 'Camera', 'icon': CupertinoIcons.camera_fill},
    {'title': 'Gallery', 'icon': Icons.image},
    {'title': 'Document', 'icon': Icons.file_copy},
    {'title': 'Video', 'icon': Icons.play_arrow},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width - 35,
        margin: const EdgeInsets.only(bottom: 70),
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 20),
        decoration: BoxDecoration(color: KColor.white, borderRadius: BorderRadius.circular(10)),
        child: Wrap(
          runSpacing: 15,
          spacing: 20,
          alignment: WrapAlignment.center,
          children: List.generate(
            attachmentOptions.length,
            (index) {
              return GestureDetector(
                onTap: () async {
                  late File asset;

                  if (attachmentOptions[index]['title'] == 'Camera') {
                    XFile _asset = await AssetService.pickImageVideo(false, context, ImageSource.camera);
                    asset = File(_asset.path);
                  } else if (attachmentOptions[index]['title'] == 'Gallery') {
                    XFile _asset = await AssetService.pickImageVideo(false, context, ImageSource.gallery);
                    asset = File(_asset.path);
                  } else if (attachmentOptions[index]['title'] == 'Video') {
                    XFile _asset = await AssetService.pickImageVideo(false, context, ImageSource.gallery, isVideo: true);
                    asset = File(_asset.path);
                  } else if (attachmentOptions[index]['title'] == 'Document') {
                    PlatformFile _asset = await AssetService.pickMedia(false, context, true, false);
                    asset = File(_asset.path!);
                  }

                  ref.read(assetManagerProvider).addAssets(asset);
                  Navigator.of(context).pop();
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(color: KColor.appThemeColor.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Icon(attachmentOptions[index]['icon'], color: KColor.appThemeColor),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5), child: Text(attachmentOptions[index]['title'], style: KTextStyle.caption)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
