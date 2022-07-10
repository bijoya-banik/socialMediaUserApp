import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class KVideoComponent extends StatefulWidget {
  final dynamic videoSource;
  final bool isAsset;
  final bool isPlayable;
  final bool navigateReplacement;

  const KVideoComponent(
    this.videoSource, {
    this.isAsset = false,
    this.isPlayable = true,
    this.navigateReplacement = false,
    Key? key,
  }) : super(key: key);

  @override
  _KVideoComponentState createState() => _KVideoComponentState();
}

class _KVideoComponentState extends State<KVideoComponent> {
  VideoPlayerController? _controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    initController();
  }

  initController() async {
    print("initController()");
    await _disposeVideoController();
    if (widget.videoSource != null && mounted) {
      _controller = widget.isAsset ? VideoPlayerController.file(widget.videoSource) : VideoPlayerController.network(widget.videoSource);

      await _controller!.initialize().then((_) {
        setState(() {});
        initialized = _controller!.value.isInitialized;
      });
    }
  }

  Future<void> _disposeVideoController() async {
    print('_disposeVideoController()');
    if (_controller != null) {
      print('_controller != null');
      await _controller!.dispose();
    }
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
        setState(() {});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: initialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(_controller!),
                    if (widget.isPlayable)
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: VideoProgressIndicator(
                            _controller!,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                                backgroundColor: KColor.black.withOpacity(0.25),
                                bufferedColor: KColor.white.withOpacity(0.5),
                                playedColor: KColor.primary),
                          )),
                    if (widget.isPlayable)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            onPressed: () {
                              //This will help to hide the status bar and bottom bar of Mobile
//also helps you to set preferred device orientations like landscape
                              SystemChrome.setPreferredOrientations(
                                [
                                  DeviceOrientation.portraitUp,
                                  DeviceOrientation.portraitDown,
                                  DeviceOrientation.landscapeLeft,
                                  DeviceOrientation.landscapeRight,
                                ],
                              );

//This will help you to push fullscreen view of video player on top of current page
                              // if (widget.navigateReplacement) Navigator.pop(context);
                              Navigator.of(context, rootNavigator: true)
                                  .push(
                                CupertinoPageRoute(builder: (context) => FullScreenVideo(_controller!)),
                              )
                                  .then(
                                (value) {
//This will help you to set previous Device orientations of screen so App will continue for portrait mode
                                  SystemChrome.setPreferredOrientations(
                                    [
                                      DeviceOrientation.portraitUp,
                                      DeviceOrientation.portraitDown,
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.fullscreen, color: KColor.white)),
                      ),
                    if (widget.isPlayable) _ControlsOverlay(controller: _controller!),
                  ],
                ),
              )
            : Container(height: KSize.getHeight(context, 150), alignment: Alignment.center, child: const CupertinoActivityIndicator()),
      ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

class __ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 60),
      child: GestureDetector(
        onTap: () {
          widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
          setState(() {});
        },
        child: Center(
          child: Container(
            height: 45,
            width: 45,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: !widget.controller.value.isPlaying ? KColor.white.withOpacity(0.6) : KColor.transparent),
            child: Icon(!widget.controller.value.isPlaying ? Icons.play_arrow : null, size: 30, color: KColor.black),
          ),
        ),
      ),
    );
  }
}

class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideo(this.controller, {Key? key}) : super(key: key);

  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  bool isPortrait = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      resizeToAvoidBottomInset: false,
      navigationBar: isPortrait ? KCupertinoNavBar(automaticallyImplyLeading: false, hasLeading: true) : null,
      child: OrientationBuilder(
        builder: (context, orientation) {
          isPortrait = orientation == Orientation.portrait;
          print('isPortrait = $isPortrait');
          return InkWell(
            onTap: () {
              widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
              setState(() {});
            },
            child: Center(
              child: Stack(
                //This will help to expand video in Horizontal mode till last pixel of screen
                fit: isPortrait ? StackFit.loose : StackFit.expand,
                children: [
                  AspectRatio(
                    aspectRatio: widget.controller.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(widget.controller),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: VideoProgressIndicator(
                              widget.controller,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                  backgroundColor: KColor.black.withOpacity(0.25),
                                  bufferedColor: KColor.white.withOpacity(0.5),
                                  playedColor: KColor.primary),
                            )),
                        _ControlsOverlay(controller: widget.controller),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              onPressed: () {
                                SystemChrome.setPreferredOrientations(
                                  [
                                    isPortrait ? DeviceOrientation.landscapeLeft : DeviceOrientation.portraitUp,
                                  ],
                                );
                                setState(() {
                                  isPortrait = !isPortrait;
                                });
                              },
                              icon: Icon(isPortrait ? Icons.fullscreen : Icons.fullscreen_exit, color: KColor.white)),
                        ),
                      ],
                    ),
                  ),
                  if (!isPortrait)
                    Positioned(
                      top: 4,
                      left: 8,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: SafeArea(
                          child: Container(
                            decoration: BoxDecoration(color: KColor.white.withOpacity(0.5), shape: BoxShape.circle),
                            child: Padding(
                                padding: const EdgeInsets.only(left: 13, right: 8, top: 15, bottom: 15),
                                child: Icon(Icons.arrow_back_ios, size: 18, color: KColor.black87)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
