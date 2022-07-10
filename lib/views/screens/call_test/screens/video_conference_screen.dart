


// import 'package:divine9/call_test/controllers/video_conference_controller.dart';
// import 'package:divine9/services/socket_service.dart';
// import 'package:divine9/views/styles/b_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:get/get.dart';

// class VideoConferenceScreen extends GetView<VideoConferenceController> {
//   const VideoConferenceScreen({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<VideoConferenceController>(
//       builder: (_) => Stack(
//         children: [
//           Scaffold(
//             floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//            // appBar: buildAppBar(),
//             floatingActionButton: controller.call.isVideoCall ? buildVideoCallControlButtons() : buildAudioCallControlButtons(),
//             body: buildVideoRenderers(),
//           ),
//           buildCallingScreen()
//         ],
//       ),
//     );
//   }

//   Visibility buildCallingScreen() {
//     return Visibility(
//       visible: controller.isOffer ? controller.connectionState != RTCPeerConnectionState.RTCPeerConnectionStateConnected : false,
//       child: WillPopScope(
//         onWillPop: () async {
//           return false;
//         },
//         child: Scaffold(
//           backgroundColor: Colors.grey.shade900,
//           body: Column(
//             children: [
//               Container(
//                 width: Get.width,
//                 padding: EdgeInsets.only(top: kToolbarHeight + 50, bottom: 20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     controller.user.profilePic == null
//                         ? Container(
//                             child: CircleAvatar(
//                               radius: 75,
//                               child: Text(
//                                 "${controller.user.firstName[0].toUpperCase()}${controller.user.lastName[0].toUpperCase()}",
//                                 style: TextStyle(color: Colors.red, fontSize: 50),
//                               ),
//                               backgroundColor: Colors.white,
//                             ),
//                           )
//                         : CircleAvatar(radius: 75, foregroundImage: NetworkImage(controller.user.profilePic)),
//                     SizedBox(height: 30),
//                     Text(
//                       "${controller.user.firstName} ${controller.user.lastName}",
//                       style: KTextStyle.headline4.copyWith(fontSize: 26, fontWeight: FontWeight.bold, color: KColor.whiteConst),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 15),
//                     Text(controller.call.isVideoCall ? "video calling..." : "calling...",
//                         style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.normal, color: KColor.whiteConst)),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.only(bottom: 50),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       FloatingActionButton(
//                         backgroundColor: Colors.red,
//                         child: Icon(
//                           Icons.call_end,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           // controller.socketService.hangupCall(controller.call);
//                           controller.socketService.makecall(call: controller.call, type: "hang-up");
//                           controller.hangUp(userId: controller.call.to.userId);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Row buildVideoCallControlButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         FloatingActionButton(
//           heroTag: "switch-camera",
//           backgroundColor: controller.mediaDevices.length > 1 ? Colors.grey.shade800 : Colors.grey.shade400,
//           onPressed: controller.mediaDevices.length > 1 ? controller.switchCamera : null,
//           child: Icon(
//             Icons.switch_camera,
//             color: Colors.white,
//           ),
//         ),
//         FloatingActionButton(
//           heroTag: "hangup",
//           backgroundColor: Colors.red,
//           onPressed: () {
//             if (controller.call != null) {
//               Get.find<SocketService>().makecall(call: controller.call, type: "hang-up");
//               // Get.find<SocketService>().hangupCall(controller.call);
//             }
//             controller.hangUp();
//           },
//           child: Icon(
//             Icons.call_end,
//             color: Colors.white,
//           ),
//         ),
//         FloatingActionButton(
//           heroTag: "mute",
//           backgroundColor: controller.isMuted ? Colors.white : Colors.grey.shade800,
//           onPressed: controller.muteMicrophone,
//           child: controller.isMuted
//               ? Icon(
//                   Icons.mic,
//                   color: Colors.grey.shade800,
//                 )
//               : Icon(
//                   Icons.mic_off,
//                   color: Colors.white,
//                 ),
//         ),
//       ],
//     );
//   }

//   Container buildAudioCallControlButtons() {
//     return Container(
//       padding: const EdgeInsets.only(bottom: 50),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           FloatingActionButton(
//             heroTag: "mute",
//             backgroundColor: controller.isMuted ? Colors.white : Colors.grey.shade800,
//             onPressed: controller.muteMicrophone,
//             child: controller.isMuted
//                 ? Icon(
//                     Icons.mic,
//                     color: Colors.grey.shade800,
//                   )
//                 : Icon(
//                     Icons.mic_off,
//                     color: Colors.white,
//                   ),
//           ),
//           SizedBox(height: 15),
//           FloatingActionButton(
//             heroTag: "hangup",
//             backgroundColor: Colors.red,
//             onPressed: () {
//               if (controller.call != null) {
//                 //  Get.find<SocketService>().hangupCall(controller.call);
//                 Get.find<SocketService>().makecall(call: controller.call, type: "hang-up");
//               }
//               controller.hangUp(userId: controller.call.to.userId);
//             },
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Stack buildVideoRenderers() {
//     return Stack(
//       children: [
//         Container(
//           width: Get.width,
//           height: Get.height,
//           child: controller.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateConnected
//               ? RTCVideoView(
//                   controller.remoteRenderer,
//                   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                 )
//               : RTCVideoView(
//                   controller.localRenderer,
//                   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                   mirror: controller.isFrontCamera ? true : false,
//                 ),
//         ),
//         Visibility(
//           visible: !controller.call.isVideoCall,
//           child:
//            Container(
//             width: Get.width,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 75,
//                 width: 75,
//                   margin: EdgeInsets.only(top: kToolbarHeight + 80),
//                   child: controller.user.profilePic == null
//                       ? CircleAvatar(
//                           radius: 75,
//                           child: Text(
//                             "${controller.user.firstName[0].toUpperCase()}${controller.user.lastName[0].toUpperCase()}",
//                             style: KTextStyle.headline5.copyWith(fontSize: 24, color: KColor.whiteConst)
//                           ),
//                           backgroundColor: KColor.appThemeColorConst
//                         )
//                       : CircleAvatar(radius: 75, foregroundImage: NetworkImage(controller.user.profilePic)),

//                   // Center(
//                   //   child: Icon(
//                   //     Icons.volume_up,
//                   //     color: Colors.white,
//                   //     size: 100,
//                   //   ),
//                   // ),
//                 ),
//                  SizedBox(height: 20),
//                  Text(
//                     "${controller.user.firstName} ${controller.user.lastName}",
//                    style: KTextStyle.headline4.copyWith(fontSize: 26, fontWeight: FontWeight.bold, color: KColor.whiteConst),
//                       overflow: TextOverflow.ellipsis,
//                   ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           right: 10,
//           top: 10,
//           child: Visibility(
//             visible: controller.call.isVideoCall,
//             child: Container(
//               width: 125,
//               height: 187.5,
//               child: Stack(
//                 children: [
//                   RTCVideoView(
//                     controller.localRenderer,
//                     objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                     mirror: controller.isFrontCamera ? true : false,
//                   ),
//                   Visibility(
//                     visible: controller.connectionState != RTCPeerConnectionState.RTCPeerConnectionStateConnected,
//                     child: Container(
//                       width: 125,
//                       height: 187.5,
//                       color: Colors.black,
//                       child: Center(child: CircularProgressIndicator(color: Colors.red)),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   AppBar buildAppBar() {
//     return AppBar(
//       leadingWidth: 0.0,
//       automaticallyImplyLeading: false,
//       title: Row(
//         children: [
//           controller.user.profilePic == null
//               ? CircleAvatar(
//                   radius: 18,
//                   child: Text(
//                     "${controller.user.firstName[0]}${controller.user.lastName[0]}",
//                     style: TextStyle(color: Colors.red, fontSize: 16),
//                   ),
//                   backgroundColor: Colors.white,
//                 )
//               : CircleAvatar(radius: 75, foregroundImage: NetworkImage(controller.user.profilePic)),
//           SizedBox(width: 10),
//           Text(
//             "${controller.user.firstName} ${controller.user.lastName}",
//             style: KTextStyle.headline4.copyWith(fontSize: 26, fontWeight: FontWeight.bold, color: KColor.whiteConst),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//       backgroundColor: Colors.blue,
//     );
//   }
// }
