// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:buddyscripts/controller/story/state/story_details_state.dart';
// import 'package:buddyscripts/controller/story/story_controller.dart';
// import 'package:buddyscripts/controller/story/story_details_controller.dart';
// import 'package:buddyscripts/services/date_time_service.dart';
// import 'package:buddyscripts/views/global_components/k_bottom_navigation_bar.dart';
// import 'package:buddyscripts/views/screens/story/feed_user_story.dart';
// import 'package:buddyscripts/views/screens/story/models/story_model.dart';
// import 'package:buddyscripts/views/screens/story/models/user_model.dart';
// import 'package:buddyscripts/views/styles/b_style.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class StoryDataScreen extends StatefulWidget {
//   final UserWithStory user;
//   final List<Story> stories;
//   final int userIndex;

//   const StoryDataScreen({@required this.user, @required this.stories, this.userIndex});

//   @override
//   _StoryDataScreenState createState() => _StoryDataScreenState();
// }

// class _StoryDataScreenState extends State<StoryDataScreen> with SingleTickerProviderStateMixin {
//   PageController _pageController;
//   AnimationController _animController;
//   VideoPlayerController _videoController;
//   int _currentIndex = 0;
//   int index = 0;

//   @override
//   void initState() {
//     super.initState();

//     _pageController = PageController();
//     _animController = AnimationController(vsync: this);

//     final Story firstStory = widget.stories.first;
//     _loadStory(story: firstStory, animateToPage: false);

//     _animController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animController.stop();
//         _animController.reset();
//         setState(() {
//           if (_currentIndex + 1 < widget.stories.length) {
//             _currentIndex += 1;
//             _loadStory(story: widget.stories[_currentIndex]);
//           } else {
//             // Out of bounds - loop story
//             // You can also Navigator.of(context).pop() here

//             // print("object");
//             // _currentIndex = 0;
//             // _loadStory(story: widget.stories[_currentIndex]);

//             print(" userIndex");
//             print(widget.userIndex);

//             int storyIndex = context.read(storyProvider).storyModel.indexWhere((element) => element.id.toString() == widget.user.userId.toString());
//             print("storyIndexxxxxxxxxxxxxxxxxxx");
//             print("slideeeee");
//             print(storyIndex);

//             if (storyIndex > 0) {
//               if (storyIndex + 2 < context.read(storyProvider).storyModel.length) {
//                 if (!context.read(storyDetailsProvider).usersIdStoryList.contains(context.read(storyProvider).storyModel[storyIndex + 2].id)) {
//                   context.read(storyDetailsProvider).fetchAllStory(context.read(storyProvider).storyModel[storyIndex + 2].id);
//                 }
//               }
//             }

//             if (storyIndex == context.read(storyProvider).storyModel.length - 1) {
//               Navigator.of(context).pop();
//             } else {
//               pageUserController.animateToPage(
//                 widget.userIndex + 1,
//                 duration: const Duration(milliseconds: 1),
//                 curve: Curves.easeInOut,
//               );
//             }
//           }
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animController.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Story story = widget.stories[_currentIndex];
//     return Scaffold(
//         backgroundColor: Colors.black,
//         body: Consumer(builder: (context, watch, _) {
//           final storyDetailsState = watch(storyDetailsProvider.state);
//           return GestureDetector(
//             onLongPress: () {
//               _animController.stop();
//             },
//             // onLongPressEnd: (longPressEndDetails) {
//             //   _animController.forward();
//             // },
//             onPanUpdate: (details) async {
//               // Swiping in right direction.
//               if (details.delta.dx > 0) {
//                 print("righttttt");
//                 _rightTap();
//                 //print("righttttt");
//               }

//               // Swiping in left direction.
//               if (details.delta.dx < 0) {
//                 print("lefttttt");

//                 // if (storyDetailsState is StoryDetailsProcessingState) {
//                 //   await Future.delayed(Duration(seconds: 1), () {
//                     _leftTap();
//                  // });
//                // }
//               }

//               // Swiping in left direction.
//               if (details.delta.dy > 0) {
//                 print("toppp down");
//                 _animController.stop();
//                 Navigator.pop(context);
//               }
//             },
//             onTapDown: (details) => _onTapDown(details, story),
//             child: Stack(
//               children: <Widget>[
//                 PageView.builder(
//                   controller: _pageController,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: widget.stories.length,
//                   itemBuilder: (context, i) {
//                     final Story story = widget.stories[i];
//                     switch (story.media) {
//                       case MediaType.image:
//                         return CachedNetworkImage(
//                           imageUrl: story.url,
//                           fit: BoxFit.contain,
//                         );
//                       case MediaType.video:
//                         return FittedBox(
//                           fit: BoxFit.contain,
//                           child: _videoController != null && _videoController.value.isInitialized
//                               ? SizedBox(
//                                   width: _videoController.value.size.width,
//                                   height: _videoController.value.size.height,
//                                   child: VideoPlayer(_videoController),
//                                 )
//                               : Container(),
//                         );

//                       case MediaType.text:
//                         return Container(
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
//                           height: MediaQuery.of(context).size.height,
//                           child: Center(
//                             child: Text(
//                               story.url,
//                               style: KTextStyle.subtitle2.copyWith(color: KColor.white),
//                             ),
//                           ),
//                         );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//                 Positioned(
//                   top: 40.0,
//                   left: 10.0,
//                   right: 10.0,
//                   child: Column(
//                     children: <Widget>[
//                       Row(
//                         children: widget.stories
//                             .asMap()
//                             .map((i, e) {
//                               return MapEntry(
//                                 i,
//                                 AnimatedBar(
//                                   animController: _animController,
//                                   position: i,
//                                   currentIndex: _currentIndex,
//                                 ),
//                               );
//                             })
//                             .values
//                             .toList(),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 1.5,
//                           vertical: 10.0,
//                         ),
//                         child: UserInfo(user: widget.user, createdAt: widget.user.createdAt),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }));
//   }

//   void _onTapDown(TapDownDetails details, Story story) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double dx = details.globalPosition.dx;
//     if (dx < screenWidth / 3) {
//       print("prevous");
//       setState(() {
//         if (_currentIndex - 1 >= 0) {
//           _currentIndex -= 1;
//           _loadStory(story: widget.stories[_currentIndex]);
//         }
//         // else if (widget.userIndex == 0) {
//         //   Navigator.of(context).pop();
//         // }
//         else {
//           _rightTap();
//         }
//       });
//     } else if (dx > 2 * screenWidth / 3) {
//       setState(() {
//         if (_currentIndex + 1 < widget.stories.length) {
//           _currentIndex += 1;
//           _loadStory(story: widget.stories[_currentIndex]);
//         } else {
//           // Out of bounds - loop story
//           // You can also Navigator.of(context).pop() here

//           // _currentIndex = 0;
//           // _loadStory(story: widget.stories[_currentIndex]);

//           if (widget.userIndex == context.read(storyProvider).storyModel.length - 1) {
//             Navigator.of(context).pop();
//           } else {
//             _leftTap();
//           }
//         }
//       });
//     } else {
//       if (story.media == MediaType.video) {
//         if (_videoController.value.isPlaying) {
//           _videoController.pause();
//           _animController.stop();
//         } else {
//           _videoController.play();
//           _animController.forward();
//         }
//       }
//     }
//   }

//   void _leftTap() {
//     int storyIndex = context.read(storyProvider).storyModel.indexWhere((element) => element.id.toString() == widget.user.userId.toString());
//     print("storyIndexxxxxxxxxxxxxxxxxxx");
//     print("tap tap");
//     print(storyIndex);
//     print(widget.userIndex);

//     if (storyIndex > 0) {
//       if (storyIndex + 2 < context.read(storyProvider).storyModel.length) {
//         if (!context.read(storyDetailsProvider).usersIdStoryList.contains(context.read(storyProvider).storyModel[storyIndex + 2].id)) {
//           context.read(storyDetailsProvider).fetchAllStory(context.read(storyProvider).storyModel[storyIndex + 2].id);
//         }
//       }
//     }

//     if (storyIndex == context.read(storyProvider).storyModel.length - 1) {
//       //  && (!(storyDetailsState is StoryDetailsProcessingState))) {

//       Navigator.of(context).pop();
//     } else {
//       pageUserController.animateToPage(
//         widget.userIndex + 1,
//         duration: const Duration(milliseconds: 1),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _rightTap() {
//     int storyIndex = context.read(storyProvider).storyModel.indexWhere((element) => element.id.toString() == widget.user.userId.toString());
//     print("storyIndexxxxxxxxxxxxxxxxxxx");
//     print("tap tap prev page");
//     print(storyIndex);

//     // if (storyIndex == context.read(storyProvider).storyModel.length - 1) {
//     //   Navigator.of(context).pop();
//     // } //else
//     pageUserController.animateToPage(
//       widget.userIndex - 1,
//       duration: const Duration(milliseconds: 1),
//       curve: Curves.easeInOut,
//     );

//     if (storyIndex > 0) {
//       if (storyIndex - 1 > 0) {
//         if (!context.read(storyDetailsProvider).usersIdStoryList.contains(context.read(storyProvider).storyModel[storyIndex - 1].id)) {
//           context.read(storyDetailsProvider).fetchAllStory(context.read(storyProvider).storyModel[storyIndex - 1].id, prev: true);
//         }
//       }
//     }
//   }

//   void _loadStory({Story story, bool animateToPage = true}) {
//     _animController.stop();
//     _animController.reset();
//     switch (story.media) {
//       case MediaType.image:
//         _animController.duration = story.duration;
//         _animController.forward();
//         break;
//       case MediaType.video:
//         _videoController = null;
//         _videoController?.dispose();
//         _videoController = VideoPlayerController.network(story.url)
//           ..initialize().then((_) {
//             setState(() {});
//             if (_videoController.value.isInitialized) {
//               _animController.duration = _videoController.value.duration;
//               _videoController.play();
//               _animController.forward();
//             }
//           });
//         break;
//       case MediaType.text:
//         _animController.duration = story.duration;
//         _animController.forward();
//         break;
//     }
//     if (animateToPage) {
//       _pageController.animateToPage(
//         _currentIndex,
//         duration: const Duration(milliseconds: 1),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
// }

// class AnimatedBar extends StatelessWidget {
//   final AnimationController animController;
//   final int position;
//   final int currentIndex;

//   const AnimatedBar({
//     Key key,
//     @required this.animController,
//     @required this.position,
//     @required this.currentIndex,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 1.5),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               children: <Widget>[
//                 _buildContainer(
//                   double.infinity,
//                   position < currentIndex ? Colors.white : Colors.white.withOpacity(0.5),
//                 ),
//                 position == currentIndex
//                     ? AnimatedBuilder(
//                         animation: animController,
//                         builder: (context, child) {
//                           return _buildContainer(
//                             constraints.maxWidth * animController.value,
//                             Colors.white,
//                           );
//                         },
//                       )
//                     : const SizedBox.shrink(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Container _buildContainer(double width, Color color) {
//     return Container(
//       height: 5.0,
//       width: width,
//       decoration: BoxDecoration(
//         color: color,
//         border: Border.all(
//           color: Colors.black26,
//           width: 0.8,
//         ),
//         borderRadius: BorderRadius.circular(3.0),
//       ),
//     );
//   }
// }

// class UserInfo extends StatelessWidget {
//   final UserWithStory user;
//   final String createdAt;

//   const UserInfo({
//     Key key,
//     @required this.user,
//     @required this.createdAt,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         CircleAvatar(
//           radius: 20.0,
//           backgroundColor: Colors.grey[300],
//           backgroundImage: CachedNetworkImageProvider(
//             user.profileImageUrl,
//           ),
//         ),
//         const SizedBox(width: 10.0),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 user.name,
//                 style: KTextStyle.subtitle1.copyWith(color: KColor.white, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 3),
//               Text(
//                 DateTimeService.timeAgoLocal(createdAt),
//                 style: KTextStyle.caption.copyWith(color: KColor.white),
//               ),
//             ],
//           ),
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.close,
//             size: 30.0,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ],
//     );
//   }
// }
