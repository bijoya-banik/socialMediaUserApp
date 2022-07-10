import 'package:buddyscripts/controller/profile/my_profile_feed_controller.dart';
import 'package:buddyscripts/controller/profile/user_profile_feed_controller.dart';
import 'package:buddyscripts/views/screens/account/profile/my_profile_screen.dart';
import 'package:buddyscripts/views/screens/account/profile/user_profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/story/all_story_controller.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/screens/story/models/story_model.dart';
import 'package:buddyscripts/views/screens/story/models/story_user_model.dart';
import 'package:buddyscripts/views/screens/story/story_optional_model.dart';
import 'package:buddyscripts/views/screens/story/story_user_slider_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

VideoPlayerController? videoController;
//AnimationController animController;
bool disposeBottomSheet = true;

class StorySliderScreen extends ConsumerStatefulWidget {
  final UserWithStory? user;
  final List<Story>? stories;
  final int? userIndex;

  const StorySliderScreen({Key? key, @required this.user, @required this.stories, this.userIndex}) : super(key: key);

  @override
  _StorySliderScreenState createState() => _StorySliderScreenState();
}

class _StorySliderScreenState extends ConsumerState<StorySliderScreen> with SingleTickerProviderStateMixin {
  PageController? _pageController;
  AnimationController? animController;

  int _currentIndex = 0;
  int index = 0;
  String initVideo = "notInitialized";
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    animController = AnimationController(vsync: this);

    final Story firstStory = widget.stories!.first;
    _loadStory(story: firstStory, animateToPage: false);

    animController?.addStatusListener((status) {
      // print(animController!.status);
      // print(animController!.duration);
      if (status == AnimationStatus.completed) {
        animController?.stop();
        animController?.reset();
        setState(() {
          if (_currentIndex + 1 < widget.stories!.length) {
            _currentIndex += 1;
            _loadStory(story: widget.stories![_currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here

            // print("object");
            // _currentIndex = 0;
            // _loadStory(story: widget.stories[_currentIndex]);

            print("slider");

            if ((widget.userIndex)! + 1 == ref.read(allstoryProvider.notifier).usersStoryDetails!.length) {
              // print('in  auto pop');
              if (Navigator.canPop(context)) {
                // print('pop from auto pop');
                Navigator.of(context).pop();
              }
            } else {
              pageUserController?.animateToPage(
                widget.userIndex! + 1,
                duration: const Duration(milliseconds: 1),
                curve: Curves.easeInOut,
              );
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    animController?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story story = widget.stories![_currentIndex];
    return Scaffold(
        backgroundColor: KColor.blackConst,
        body: Consumer(builder: (context, watch, _) {
          return GestureDetector(
            onLongPress: () {
              animController?.stop();
              if (story.media == MediaType.video) {
                if (videoController!.value.isPlaying) {
                  videoController?.pause();
                }
              }
            },
            onLongPressEnd: (longPressEndDetails) {
              animController?.forward();
              if (story.media == MediaType.video) {
                videoController?.play();
              }
            },
            onPanUpdate: (details) async {
              // Swiping in left direction.
              if (details.delta.dy > 0) {
                print("toppp down");
                animController?.stop();
                Navigator.pop(context);
              }
            },
            onTapUp: (details) {
              _onTapDown(details, story);
            },
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.stories!.length,
                  itemBuilder: (context, i) {
                    final Story story = widget.stories![i];
                    switch (story.media) {
                      case MediaType.image:
                        return CachedNetworkImage(
                          imageUrl: story.url!,
                          fit: BoxFit.contain,
                        );
                      case MediaType.video:
                        return FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return FittedBox(
                                fit: BoxFit.contain,
                                child: SizedBox(
                                  width: videoController?.value.size.width,
                                  height: videoController?.value.size.height,
                                  child: VideoPlayer(videoController!),
                                ),
                              );
                            } else {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(color: KColor.black38),
                                child: const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )),
                              );
                            }
                          },
                        );

                      case MediaType.text:
                        return Container(
                          decoration: BoxDecoration(
                              gradient: story.bgColor == null || story.bgColor == ''
                                  ? LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        KColor.storyColorLeft,
                                        KColor.storyColorRight,
                                      ],
                                    )
                                  : KColor.gradientsColor[KColor.feedBackGroundGradientColors.indexWhere((element) => element == story.bgColor) + 2]
                              //     gradient: LinearGradient(
                              //   begin: Alignment.centerLeft,
                              //   end: Alignment.centerRight,
                              //   colors: [
                              //     KColor.storyColorLeft,
                              //     KColor.storyColorRight,
                              //   ],
                              // )
                              ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                            child: Text(
                              story.url!,
                              textAlign: TextAlign.center,
                              style: KTextStyle.subtitle2.copyWith(color: KColor.whiteConst),
                            ),
                          ),
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
                Positioned(
                  top: 40.0,
                  left: 10.0,
                  right: 10.0,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: widget.stories!
                            .asMap()
                            .map((i, e) {
                              return MapEntry(
                                i,
                                AnimatedBar(
                                  animBarController: animController,
                                  position: i,
                                  currentIndex: _currentIndex,
                                ),
                              );
                            })
                            .values
                            .toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 1.5,
                          vertical: 10.0,
                        ),
                        child: UserInfo(
                          animBarController: animController,
                          user: widget.user,
                          createdAt: widget.stories![_currentIndex].createTime,
                          story: widget.stories![_currentIndex],
                          index: _currentIndex,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }

  void _onTapDown(details, Story story) {
    print('on tap down');
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      print("previous");
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: widget.stories![_currentIndex]);
        } else {
          _rightTap();
        }
      });
    } else {
      //if (dx > 2 * screenWidth / 3) {
      print('next');
      setState(() {
        if (_currentIndex + 1 < widget.stories!.length) {
          _currentIndex += 1;
          _loadStory(story: widget.stories![_currentIndex]);
        } else {
          _leftTap();
        }
      });
    }

    //  else {
    //     if (story.media == MediaType.video) {
    //       if (_videoController.value.isPlaying) {
    //         _videoController.pause();
    //         animController.stop();
    //       } else {
    //         _videoController.play();
    //         animController.forward();
    //       }
    //     }
    //  }
  }

  void _leftTap() {
    print("tap next");

    pageUserController?.animateToPage(widget.userIndex! + 1, duration: kDuration, curve: kCurve);
  }

  void _rightTap() {
    print("tap  prev page");

    pageUserController?.animateToPage((widget.userIndex)! - 1, duration: kDuration, curve: kCurve);
  }

  void _loadStory({Story? story, bool animateToPage = true}) {
    animController?.stop();
    animController?.reset();

    print("initVideo");
    print(initVideo);

    if (initVideo == "notInitialized") {
      if (story?.media == MediaType.video) {
        initVideo = "initialized";
      }
    }

    if (story?.media == MediaType.video && initVideo == "") {
      if (videoController != null) {
        if (videoController!.value.isPlaying) {
          videoController?.pause();
        }
      }
      //if (videoController.value.isInitialized == true) {
      //videoController?.dispose();

      // }
    }

    initVideo = "";

    switch (story!.media!) {
      case MediaType.image:
        animController?.duration = story.duration;
        animController?.forward();
        break;
      case MediaType.video:
        // _videoController = null;
        // _videoController?.dispose();
        // print("_videoControllerrrrrrrrrrrrrrrrrrrrrrrrr");
        // print(_videoController);
        _initializeVideoPlayerFuture = VideoPlayerController.network(story.url!).initialize();
        videoController = VideoPlayerController.network(story.url!)
          ..initialize().then((_) {
            setState(() {});

            if (videoController!.value.isInitialized) {
              animController?.duration = videoController?.value.duration;
              videoController?.play();
              animController?.forward();
            }
          });

        break;
      case MediaType.text:
        animController?.duration = story.duration;
        animController?.forward();
        break;
    }
    if (animateToPage) {
      _pageController?.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController? animBarController;
  final int? position;
  final int? currentIndex;

  const AnimatedBar({
    Key? key,
    @required this.animBarController,
    @required this.position,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  (position)! < (currentIndex)! ? KColor.whiteConst : KColor.whiteConst.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animBarController!,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animBarController!.value,
                            KColor.whiteConst,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: KColor.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}

class UserInfo extends ConsumerWidget {
  final AnimationController? animBarController;
  final UserWithStory? user;
  final String? createdAt;
  final Story? story;
  final int? index;

  const UserInfo(
      {Key? key, @required this.animBarController, @required this.user, @required this.createdAt, @required this.story, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        animBarController?.stop();
        if (story?.media == MediaType.video) {
          if (videoController!.value.isPlaying) {
            videoController?.pause();
          }
        }
        user!.userId == getIntAsync(USER_ID)
            ? ref.read(myProfileFeedProvider.notifier).fetchProfileFeed(user!.username!)
            : ref.read(userProfileFeedProvider.notifier).fetchProfileFeed(user!.username!);
        await Navigator.push(context,
            CupertinoPageRoute(builder: (context) => user!.userId == getIntAsync(USER_ID) ? const MyProfileScreen() : const UserProfileScreen()));
        animBarController?.forward();
        if (story?.media == MediaType.video) {
          videoController?.play();
        }
      },
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundColor: KColor.grey300,
            backgroundImage: CachedNetworkImageProvider(
              user!.profileImageUrl!,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user!.name!,
                  style: KTextStyle.subtitle1.copyWith(color: KColor.whiteConst, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  createdAt == "" ? "" : DateTimeService.timeAgoLocal(createdAt),
                  style: KTextStyle.caption.copyWith(color: KColor.whiteConst),
                ),
              ],
            ),
          ),
          Visibility(
            visible: user!.userId == getIntAsync(USER_ID),
            child: IconButton(
                icon: const Icon(MaterialIcons.more_vert, size: 30.0, color: KColor.whiteConst),
                onPressed: () {
                  animBarController?.stop();

                  _showOptionsModal(context, story, animBarController, index);
                }),
          ),
          IconButton(
              icon: const Icon(Icons.close, size: 30.0, color: KColor.whiteConst),
              onPressed: () {
                // print('in  canpop');
                if (Navigator.canPop(context)) {
                  // print('pop from canpop');
                  Navigator.pop(context);
                }
              }),
        ],
      ),
    );
  }

  void _showOptionsModal(context, story, animBarController, index) {
    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        elevation: 5,
        isScrollControlled: true,
        useRootNavigator: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
      ),
      builder: (_) => InkWell(
        onTap: () {
          print("object");
        },
        child: PlatformWidget(
          material: (_, __) => StoryOptionsModal(animBarController, story, index),
          cupertino: (_, __) => StoryOptionsModal(animBarController, story, index, isPlatformIos: true),
        ),
      ),
    ).whenComplete(() {
      if (disposeBottomSheet) {
        animBarController.forward();
      }
    });
  }
}
