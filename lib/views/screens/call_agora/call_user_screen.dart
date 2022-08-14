import 'dart:io';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/services/socket_service.dart';
import 'package:buddyscripts/views/screens/call_agora/call_user_model.dart';
import 'package:buddyscripts/views/screens/messages/chat_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_localview;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remoteview;
import 'package:flutter_font_icons/flutter_font_icons.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:vibration/vibration.dart';

/// Define App ID and Token
const APP_ID = 'a3240716c7be4887bb2ccb2c006daec8';
RtcEngine? engine;

// dynamic playerPointsToAdd = ValueNotifier<int>(0);

class CallUserScreen extends StatefulWidget {
  final CallUserModel? friend;
  final CallUserModel? self;
  final String? type;
  final String? token;
  final String? channel;
  final bool video;

  const CallUserScreen({Key? key, this.friend, this.self, this.type, this.token, this.channel, this.video = false}) : super(key: key);
  @override
  _CallUserScreenState createState() => _CallUserScreenState();
}

class _CallUserScreenState extends State<CallUserScreen> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switchVideo = false;
  bool _speaker = false;
  bool _video = false;
  bool _mute = false;
  bool _isHour = false;
  bool _notAnswer = false;
  bool _userVideo = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  // IncallManager incallManager = new IncallManager();

  Timer? _timer;
  Timer? _ringtoneTimer;

  final player = AudioPlayer(); 

  playRingbackTone(src) async {
    await player.setAsset(src);
    player.play();
  }

  @override
  void initState() {
    super.initState();
    callEnded.value = false;
    userGetResponse.value = false;

    if (widget.type == "calling") {
      _remoteUid = -1;

      if (Platform.isIOS) {
        _ringtoneTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
          playRingbackTone(AssetPath.samsungRingtone);
          // FlutterRingtonePlayer.playRingtone();
        });
      } else {
        //  FlutterRingtonePlayer.playRingtone();
        playRingbackTone(AssetPath.samsungRingtone);

        Vibration.vibrate(pattern: [500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000], repeat: 7);
      }
    }

    if (_remoteUid == 0) {
      print("incomingggggggggggggggg callll");
      if (widget.video) playRingbackTone(AssetPath.ringback);

      // incallManager.start(ringback: '_DTMF_', auto: false);
    }

    initPlatformState();
    _stopWatchTimer.minuteTime.listen((value) => {
          if (value > 59) {_isHour = true}
        });

    Wakelock.enable();
  }

  /// call when user close the app
  @override
  void dispose() async {
    super.dispose();

    if (_ringtoneTimer != null) _ringtoneTimer?.cancel();

    // FlutterRingtonePlayer.stop();
    Vibration.cancel();
    Wakelock.disable();
    if (player.playing) player.stop();
    await _stopWatchTimer.dispose();
    if (_timer != null) {
      _timer?.cancel();

      if (_ringtoneTimer != null) _ringtoneTimer?.cancel();
    }
    // anotherCall.value = 0;
  }

//    function fetchToken(uid, channelName, tokenRole) {

//      return new Promise(function (resolve) {
//          axios.post('http://<Your Host URL and port>/fetch_rtc_token', {
//              uid: uid,
//              channelName: channelName,
//              role: tokenRole
//          }, {
//              headers: {
//                  'Content-Type': 'application/json; charset=UTF-8'
//              }
//          })
//              .then(function (response) {
//                  const token = response.data.token;
//                  resolve(token);
//              })
//              .catch(function (error) {
//                  console.log(error);
//              });
//      })
//  }

  // Init the app
  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext context = RtcEngineContext(APP_ID);
    engine = await RtcEngine.createWithContext(context);


//fetchToken();
    // Define event handling logic
    engine?.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        print('joinChannelSuccesssssssssssssssssssssssssssssssssssssssssssssssssssssssssss $channel $uid');
        if (widget.type == "call-made") {
          SocketService().makecall(
              sender: widget.self, receiver: widget.friend, type: "call-made", token: widget.token, channel: widget.channel, video: widget.video);
        }

        setState(() {
          _joined = true;
        });
        
      },
      userJoined: (int uid, int elapsed) {
        print('userJoinedddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd $uid');

        setState(() {
          _remoteUid = uid;
        });

        //  incallManager.stop(busytone: '');
        if (player.playing) player.stop();
        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      },
      userOffline: (int uid, UserOfflineReason reason) {
        print('userOfflineeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $uid');

        if (engine != null) engine?.leaveChannel();

        // incallManager.stop(busytone: '');
        if (player.playing) player.stop();
      },
      userEnableVideo: (int uid, bool video) {
        print("userMuteVideoooooooooooooooooooooooooooooooooo  $video");
        setState(() {
          _userVideo = video;
        });
      },
    ));
    // Enable video
    if (widget.video) {
      setState(() {
        _video = true;
      });
      await engine?.enableVideo();

      print("video oooooooooooooooooooooooooooooooooo");
      print(_video);
    }

    // Join channel with channel name as 123

    if (_remoteUid == 0) {
      // if(anotherCall.value>=2){

      //   print("another callllllllllllllllllllllllllll");
      //   anotherCall.value=3;

      // }
      // else{
      print(widget.token);
      await engine?.joinChannel(widget.token, widget.channel!, null, 0);
      // anotherCall.value = 1;
      _timer = Timer(const Duration(minutes: 1), () async {
        if (_remoteUid == -1 || _remoteUid == 0) {
          if (engine != null) {
            engine?.leaveChannel();
          }
          setState(() {
            _notAnswer = true;
          });

          if (_ringtoneTimer != null) _ringtoneTimer?.cancel();
          SocketService().makecall(sender: widget.self, receiver: widget.friend, type: "busy", video: widget.video);
          Wakelock.disable();
          if (player.playing) player.stop();
          // incallManager.stop(busytone: '');
          await Future.delayed(const Duration(milliseconds: 500));
          NavigationService.popNavigate();
        }
      });
      // }
    }
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: KColor.blackConst,
          body: ////////////////   call a friend //////////////
              _remoteUid == 0
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        widget.video
                            ? rtc_localview.SurfaceView()
                            : ColorFiltered(
                                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                                child: Image.network(
                                 API.baseUrl+  widget.friend?.profilePic,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        //_renderLocalPreview(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.only(top: 70),
                                    child: CircleAvatar(radius: 75, foregroundImage: NetworkImage(widget.friend?.profilePic)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "${widget.friend?.firstName} ${widget.friend?.lastName}",
                                  style: KTextStyle.headline4.copyWith(fontSize: 26, fontWeight: FontWeight.normal, color: KColor.whiteConst),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                _notAnswer
                                    ? Text("Not answered",
                                        style: KTextStyle.headline7.copyWith(fontWeight: FontWeight.normal, color: KColor.whiteConst))
                                    : ValueListenableBuilder(
                                        valueListenable: userGetResponse,
                                        builder: (context, value, w) {
                                          return value == null
                                              ? Text("Ringing...",
                                                  style: KTextStyle.headline7.copyWith(fontWeight: FontWeight.normal, color: KColor.whiteConst))
                                              : ValueListenableBuilder(
                                                  valueListenable: callEnded,
                                                  builder: (context, val, w) {
                                                    return Text(
                                                        val == null
                                                            ? "Call ended"
                                                            : widget.video
                                                                ? "Video calling..."
                                                                : "Calling...",
                                                        style:
                                                            KTextStyle.headline7.copyWith(fontWeight: FontWeight.normal, color: KColor.whiteConst));
                                                  });

                                          // ValueListenableBuilder(
                                          //     valueListenable: anotherCall,
                                          //     builder: (context, v, w) {
                                          //       return v==3
                                          //           ? Text("is on another call",
                                          //               style: KTextStyle.headline7
                                          //                   .copyWith(fontWeight: FontWeight.normal, color: KColor.whiteConst))
                                          //           : ValueListenableBuilder(
                                          //               valueListenable: callEnded,
                                          //               builder: (context, val, w) {
                                          //                 return Text(
                                          //                     val
                                          //                         ? "Call ended"
                                          //                         : widget.video
                                          //                             ? "Video calling..."
                                          //                             : "Calling...",
                                          //                     style: KTextStyle.headline7
                                          //                         .copyWith(fontWeight: FontWeight.normal, color: KColor.whiteConst));
                                          //               });
                                          //     });
                                        })
                              ],
                            ),
                            _notAnswer
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.only(bottom: 30),
                                    child: FloatingActionButton(
                                      heroTag: "busy",
                                      backgroundColor: KColor.red,
                                      onPressed: () async {
                                        if (engine != null) {
                                          setState(() {
                                            callEnded.value = true;
                                            // userGetResponse.value = false;
                                          });

                                          engine?.leaveChannel();
                                          if (player.playing) player.stop();
                                          //incallManager.stop(busytone: '');
                                        }
                                        SocketService().makecall(sender: widget.self, receiver: widget.friend, type: "busy", video: widget.video);
                                        Wakelock.disable();
                                        await Future.delayed(const Duration(milliseconds: 500));
                                        Navigator.of(context).pop();
                                      },
                                      child: const Icon(
                                        Icons.call_end,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    )
                  : ////////////////////  answer or reject
                  _remoteUid == -1
                      ? Stack(
                          children: [
                            widget.video
                                ? rtc_localview.SurfaceView()
                                : ColorFiltered(
                                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                                    child: Image.network(
                                      API.baseUrl+ widget.friend?.profilePic,
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        margin: const EdgeInsets.only(top: 70),
                                        child: CircleAvatar(radius: 75, foregroundImage: NetworkImage(widget.friend?.profilePic)),
                                      ),
                                      const SizedBox(height: 30),
                                      Text(
                                        "${widget.friend?.firstName} ${widget.friend?.lastName}",
                                        style: KTextStyle.headline4.copyWith(fontSize: 26, fontWeight: FontWeight.normal, color: KColor.whiteConst),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 20),
                                      ValueListenableBuilder(
                                          valueListenable: callEnded,
                                          builder: (context, value, w) {
                                            return Text(
                                                // value
                                                //     ? "Call ended"
                                                //     : widget.video
                                                //         ? "Video chatting from BuddyScript"
                                                //         : "is calling you on BuddyScript",
                                                value == null
                                                    ? "Call ended"
                                                    : widget.video
                                                        ? "Video chatting from BuddyScript"
                                                        : "is calling you on BuddyScript",
                                                style: KTextStyle.headline7.copyWith(fontWeight: FontWeight.normal, color: KColor.whiteConst));
                                          }),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      FloatingActionButton(
                                        heroTag: "busy",
                                        backgroundColor: Colors.red,
                                        child: const Icon(
                                          Icons.call_end,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          Vibration.cancel();
                                          // FlutterRingtonePlayer.stop();

                                          if (_ringtoneTimer != null) _ringtoneTimer?.cancel();

                                          if (player.playing) player.stop();
                                          // incallManager.stop(busytone: '');
                                          SocketService().makecall(sender: widget.self, receiver: widget.friend, type: "busy", video: widget.video);
                                          Wakelock.disable();
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FloatingActionButton(
                                        heroTag: "answer",
                                        backgroundColor: Colors.green,
                                        child: const Icon(
                                          Icons.call,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          Vibration.cancel();
                                          // FlutterRingtonePlayer.stop();
                                          if (player.playing) player.stop();

                                          if (_ringtoneTimer != null) _ringtoneTimer?.cancel();
                                          await engine?.joinChannel(widget.token, widget.channel!, null, 00);
                                          // anotherCall.value = 2;
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      : /////////////  receive call
                      widget.video
                          ? Stack(
                              children: [
                                Center(
                                  child: !_switchVideo ? _renderRemoteVideo() : _renderLocalPreview(),
                                ),
                                receiveCallBottomButtons(context),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    width: KSize.getWidth(context, 120),
                                    height: KSize.getHeight(context, 180),
                                    color: KColor.grey,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _switchVideo = !_switchVideo;
                                        });
                                      },
                                      child: Center(
                                        child: !_switchVideo ? _renderLocalPreview() : _renderRemoteVideo(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                                  child: Image.network(
                                   API.baseUrl+  widget.friend?.profilePic,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        margin: const EdgeInsets.only(top: 70),
                                        child: CircleAvatar(radius: 75, foregroundImage: NetworkImage(widget.friend?.profilePic)),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "${widget.friend?.firstName} ${widget.friend?.lastName}",
                                      style: KTextStyle.headline4.copyWith(fontSize: 26, fontWeight: FontWeight.normal, color: KColor.whiteConst),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),

                                    //!userGetResponse?

                                    ValueListenableBuilder(
                                        valueListenable: callEnded,
                                        builder: (context, value, w) {
                                          return value == null
                                              ? Text("Call ended",
                                                  style: KTextStyle.headline7.copyWith(fontWeight: FontWeight.normal, color: KColor.whiteConst))
                                              : StreamBuilder<int>(
                                                  stream: _stopWatchTimer.rawTime,
                                                  initialData: _stopWatchTimer.rawTime.value,
                                                  builder: (context, snap) {
                                                    final value = snap.data;
                                                    final displayTime = StopWatchTimer.getDisplayTime(value!, hours: _isHour, milliSecond: false);
                                                    return Text(displayTime,
                                                        style:
                                                            KTextStyle.headline7.copyWith(fontWeight: FontWeight.normal, color: KColor.whiteConst));
                                                  },
                                                );
                                        }),
                                  ],
                                ),
                                receiveCallBottomButtons(context),
                              ],
                            )),
    ));
  }

  Align receiveCallBottomButtons(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!widget.video)
              FloatingActionButton(
                heroTag: "speaker",
                backgroundColor: _speaker ? Colors.grey[100]!.withOpacity(0.6) : Colors.grey[100]!.withOpacity(0.2),
                child: const Icon(
                  Icons.volume_down,
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    _speaker = !_speaker;
                  });
                  await engine?.setEnableSpeakerphone(_speaker);
                },
              ),
            if (widget.video)
              FloatingActionButton(
                heroTag: "video-off-on",
                backgroundColor: _video ? Colors.grey[100]!.withOpacity(0.2) : Colors.grey[100]!.withOpacity(0.6),
                child: const Icon(
                  MaterialIcons.videocam_off,
                  color: Colors.white,
                ),
                onPressed: () async {
                  print("_video0000000000000000000");
                  print(_video);

                   setState(() {
                      _video = !_video;
                    });
                    await engine?.enableLocalVideo(_video);

                  // if (_video) {
                  //   // await engine?.disableVideo();
                  //   await engine?.enableLocalVideo(false);
                  //   setState(() {
                  //     _video = false;
                  //   });
                  // } else {
                  //  // await engine?.enableVideo();
                  //   await engine?.enableLocalVideo(true);
                  //   setState(() {
                  //     _video = true;
                  //   });
                //  }
                },
              ),
            if (widget.video)
              FloatingActionButton(
                heroTag: "swipe_camera",
                backgroundColor: Colors.grey[100]!.withOpacity(0.2),
                child: const Icon(
                  MaterialIcons.switch_camera,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await engine?.switchCamera();
                },
              ),
            FloatingActionButton(
              heroTag: "mute",
              backgroundColor: _mute ? Colors.grey[100]!.withOpacity(0.6) : Colors.grey[100]!.withOpacity(0.2),
              child: const Icon(Icons.mic_off, color: KColor.whiteConst),
              onPressed: () async {
                setState(() {
                  _mute = !_mute;
                });
                await engine?.muteLocalAudioStream(_mute);
              },
            ),
            FloatingActionButton(
              heroTag: "hang-up",
              backgroundColor: KColor.red,
              child: const Icon(Icons.call_end, color: KColor.whiteConst),
              onPressed: () async {
                if (engine != null) {
                  setState(() {
                    callEnded.value = true;
                  });
                  engine?.leaveChannel();

                  if (player.playing) player.stop();
                  //incallManager.stop(busytone: '');
                }
                SocketService().makecall(sender: widget.self, receiver: widget.friend, type: "hang-up", video: widget.video);
                Wakelock.disable();
                _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Local preview
  Widget _renderLocalPreview() {
    if (_joined) {
      if (_video) {
        return rtc_localview.SurfaceView();
      } else {
        return Stack(
          alignment: Alignment.center,
          children: [
            rtc_localview.SurfaceView(),
            const Icon(
              MaterialIcons.videocam_off,
              color: Colors.white,
            )
          ],
        );
      }
    } else {
      return const CircularProgressIndicator();
    }
  }

  // Remote preview
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      if (_userVideo) {
        return rtc_remoteview.SurfaceView(
          mirrorMode: VideoMirrorMode.Disabled,
          uid: _remoteUid,
          channelId: widget.channel!,
        );
      } else {
        return Stack(
          alignment: Alignment.center,
          children: [
            rtc_remoteview.SurfaceView(
              mirrorMode: VideoMirrorMode.Disabled,
              uid: _remoteUid,
              channelId: widget.channel!,
            ),
            const Icon(
              MaterialIcons.videocam_off,
              color: Colors.white,
            )
          ],
        );
      }
    } else {
      return const Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }
}
