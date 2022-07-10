import 'dart:io';

import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/views/global_components/k_video_component.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime_type/mime_type.dart';

class PreviewMedia extends StatefulWidget {
  final dynamic asset;
  final FileElement? networkAsset;
  final int? index;
  final bool isNetworkAsset;
  final bool? isFeedMedia;

  const PreviewMedia({this.asset, this.index, this.isNetworkAsset = false, this.networkAsset, this.isFeedMedia = false, Key? key}) : super(key: key);

  @override
  _PreviewMediaState createState() => _PreviewMediaState();
}

class _PreviewMediaState extends State<PreviewMedia> {
  String? assetType;

  @override
  void initState() {
    if (widget.isFeedMedia!) {
      if (widget.isNetworkAsset) {
        // print("widget.networkAsset.name");
        // print(widget.networkAsset);
        // print(widget.asset.name);
        // print(widget.asset.path);

        if (widget.networkAsset!.type == "video") {
          assetType = 'video';
        } else if (widget.networkAsset!.type == "application") {
          assetType = 'doc';
        }
      } else {
        // print("widget.asset.name");
        // print(widget.asset);

        // print(widget.asset.path);
        // print(widget.asset.name);
        if ((mime(widget.asset.name))!.split('/')[0] == "video") {
          assetType = 'video';
        }
      }
    } else {
      if (widget.isNetworkAsset) {
        if (widget.networkAsset!.type == "video") {
          assetType = 'video';
        }
      } else {
        if ((mime(widget.asset.path))!.split('/')[0] == "video") {
          assetType = 'video';
        }
      }
      print("File Type: ${(mime(widget.asset.path))!.split('/')[0]}");
      if ((mime(widget.asset.path))!.split('/')[0] == "application") {
        assetType = 'doc';
      }
    }

    print('assetType = $assetType');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // if (widget.asset.path != '' || widget.networkAsset != null)
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: assetType == 'doc'
                ? Container(
                    height: KSize.getHeight(context, 80),
                    width: MediaQuery.of(context).size.width * 0.22,
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Icon(
                            Icons.file_copy,
                            size: 25,
                            color: KColor.adobeLogoColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            widget.isNetworkAsset ? widget.networkAsset?.fileLoc!.split('/').last : widget.asset.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                            style: KTextStyle.caption,
                          ),
                        )
                      ],
                    ))
                : assetType == 'video'
                    ? SizedBox(
                        height: KSize.getHeight(context, 80),
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: KVideoComponent(
                          widget.isNetworkAsset ? widget.networkAsset!.fileLoc : File(widget.asset.path),
                          isAsset: widget.isNetworkAsset ? false : true,
                          isPlayable: false,
                        ))
                    : widget.isNetworkAsset
                        ? Image.network(
                            widget.networkAsset!.fileLoc!,
                            height: KSize.getHeight(context, 80),
                            width: MediaQuery.of(context).size.width * 0.22,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(widget.asset.path),
                            height: KSize.getHeight(context, 80),
                            width: MediaQuery.of(context).size.width * 0.22,
                            fit: BoxFit.cover,
                          ),
          ),
        ),
        Consumer(builder: (context, ref, _) {
          final assetManager = ref.watch(assetManagerProvider);
          return Container(
            height: KSize.getHeight(context, 80),
            width: MediaQuery.of(context).size.width * 0.22,
            color: KColor.blackConst.withOpacity(0.4),
            child: Center(
              child: assetManager.isMediaUploading
                  ? const CupertinoActivityIndicator()
                  : IconButton(
                      onPressed: () {
                        if (!(assetManager.isMediaUploading)) {
                          widget.isNetworkAsset
                              ? ref.read(assetManagerProvider).removeNetworkAsset(widget.index)
                              : ref.read(assetManagerProvider).removeAsset(widget.index);
                        }
                      },
                      icon: const Icon(Icons.delete),
                      color: KColor.whiteConst,
                    ),
            ),
          );
        }),
      ],
    );
  }
}
