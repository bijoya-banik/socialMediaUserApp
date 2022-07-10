import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class KVideoPlayer extends StatefulWidget {
  final dynamic videoSource;
  final bool isFromChat;
  final bool isLocal;

  const KVideoPlayer(this.videoSource, {this.isFromChat = false, this.isLocal = false, Key? key}) : super(key: key);

  @override
  _KVideoPlayerState createState() => _KVideoPlayerState();
}

class _KVideoPlayerState extends State<KVideoPlayer> with WidgetsBindingObserver {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    flickManager = FlickManager(
      autoPlay: widget.isFromChat ? false : true,
      videoPlayerController:
          widget.isLocal ? VideoPlayerController.file(File(widget.videoSource)) : VideoPlayerController.network(widget.videoSource),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      /// went to Background
      flickManager?.flickControlManager?.pause();
    }
    if (state == AppLifecycleState.resumed) {
      /// came back to Foreground
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    flickManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        print('Widget ${visibilityInfo.key} is $visiblePercentage% visible');
        if (visibilityInfo.visibleFraction < 1.0 && mounted) {
          flickManager?.flickControlManager?.pause();
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * (widget.isFromChat ? 0.25 : 0.4),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: FlickVideoPlayer(
            flickManager: flickManager!,
            flickVideoWithControls: const FlickVideoWithControls(
              videoFit: BoxFit.contain,
              controls: FlickPortraitControls(),
            ),
          ),
        ),
      ),
    );
  }
}
