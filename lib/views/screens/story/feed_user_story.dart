// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cube_transition/cube_transition.dart';
// import 'package:buddyscripts/controller/story/state/story_details_state.dart';
// import 'package:buddyscripts/controller/story/story_details_controller.dart';
// import 'package:buddyscripts/models/story/story_model.dart';
// import 'package:buddyscripts/services/date_time_service.dart';
// import 'package:buddyscripts/views/screens/story/feed_story.dart';
// import 'package:buddyscripts/views/screens/story/models/user_model.dart';
// import 'package:buddyscripts/views/styles/b_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_player/video_player.dart';

// PageController pageUserController;
// AnimationController animUserController;


// class StoryUserScreen extends StatefulWidget {
//   final List<UserWithStory> users;
//   final StoryModel userData;

//   const StoryUserScreen({@required this.users, @required this.userData});

//   @override
//   _StoryUserScreenState createState() => _StoryUserScreenState();
// }

// class _StoryUserScreenState extends State<StoryUserScreen> with SingleTickerProviderStateMixin {
//   VideoPlayerController _videoController;
//   var currentPageValue = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     pageUserController = PageController();
//     animUserController = AnimationController(vsync: this);
//     // pageUserController.addListener(() {
//     //   setState(() {
//     //     currentPageValue = pageUserController.page;
//     //   });
//     // });
//   }

//   @override
//   void dispose() {
//     pageUserController.dispose();
//     animUserController.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: KColor.white,
//       body: Consumer(builder: (context, watch, _) {
//         final storyDetailsState = watch(storyDetailsProvider.state);
//         return storyDetailsState is StoryDetailsSuccessState
//             ? PageView.builder(
//                 controller: pageUserController,
//                 itemCount: context.read(storyDetailsProvider).usersStory.length,
//                 itemBuilder: (context, i) {
//                   print("story.length");
//                   print(widget.users[i].story.length);
//                   return Stack(
//                     children: [
//                       // Transform(
//                       //   transform: Matrix4.identity()
//                       //     ..rotateY(currentPageValue - i)
//                       //     ..rotateZ(currentPageValue - i),
//                       //   child:
//                       StoryDataScreen(
//                         user: context.read(storyDetailsProvider).usersStory[i],
//                         stories: context.read(storyDetailsProvider).usersStory[i].story,
//                         userIndex: i,
//                         // ),
//                       ),
//                     ],
//                   );
//                 },
//               )
//             : storyDetailsState is StoryDetailsLoadingState
//                 ? Stack(
//                     children: [
//                       Container(
//                           decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                             begin: Alignment.centerLeft,
//                             end: Alignment.centerRight,
//                             colors: [
//                               KColor.storyColorLeft,
//                               KColor.storyColorRight,
//                             ],
//                           )),
//                           width: MediaQuery.of(context).size.width,
//                           child: Center(
//                               child: SizedBox(
//                             width: 30,
//                             height: 30,
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                               strokeWidth: 2,
//                             ),
//                           ))),

//                       // Positioned(
//                       //   // top: 20,
//                       //   child: Padding(
//                       //     padding: const EdgeInsets.symmetric(
//                       //       horizontal: 1.5,
//                       //       vertical: 30.0,
//                       //     ),
//                       //     child: Row(
//                       //       // mainAxisAlignment: MainAxisAlignment.start,
//                       //       // crossAxisAlignment: CrossAxisAlignment.start,
//                       //       children: <Widget>[
//                       //         CircleAvatar(
//                       //           radius: 20.0,
//                       //           backgroundColor: Colors.grey[300],
//                       //           backgroundImage: CachedNetworkImageProvider(
//                       //             widget.userData.profilePic,
//                       //           ),
//                       //         ),
//                       //         const SizedBox(width: 10.0),
//                       //         Expanded(
//                       //           child: Column(
//                       //             crossAxisAlignment: CrossAxisAlignment.start,
//                       //             children: [
//                       //               Text(
//                       //                 widget.userData.firstName,
//                       //                 style: KTextStyle.subtitle1.copyWith(color: KColor.white, fontWeight: FontWeight.bold),
//                       //               ),
//                       //               SizedBox(height: 3),
//                       //               Text(
//                       //                 DateTimeService.timeAgoLocal(widget.userData.createdAt).toString(),
//                       //                 style: KTextStyle.caption.copyWith(color: KColor.white),
//                       //               ),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //         IconButton(
//                       //           icon: const Icon(
//                       //             Icons.close,
//                       //             size: 30.0,
//                       //             color: Colors.white,
//                       //           ),
//                       //           onPressed: () => Navigator.of(context).pop(),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // )
//                     ],
//                   )
//                 : Container();
//       }),
//     );
//   }
// }
