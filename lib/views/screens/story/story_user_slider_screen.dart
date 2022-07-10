import 'package:buddyscripts/controller/story/all_story_controller.dart';
import 'package:buddyscripts/controller/story/state/all_story_state.dart';
import 'package:buddyscripts/models/story/story_model.dart';
import 'package:buddyscripts/views/screens/story/story_slider_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

PageController? pageUserController;
AnimationController? animUserController;

const kDuration = Duration(milliseconds: 300);
const kCurve = Curves.ease;

class StoryUserSliderScreen extends StatefulWidget {
  final StoryModel? userData;
  final int? index;

  const StoryUserSliderScreen({Key? key, @required this.userData, @required this.index}) : super(key: key);

  @override
  _StoryUserSliderScreenState createState() => _StoryUserSliderScreenState();
}

class _StoryUserSliderScreenState extends State<StoryUserSliderScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  var currentPageValue = 0.0;
  int userIndex = 0;

  @override
  void initState() {
    super.initState();
    pageUserController = PageController(initialPage: widget.index!);
    userIndex = widget.index!;
    animUserController = AnimationController(vsync: this);

    pageUserController?.addListener(() {
      setState(() {
        currentPageValue = pageUserController!.page!;
      });
    });
  }

  @override
  void dispose() {
    pageUserController?.dispose();
    animUserController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.white,
      body: Consumer(builder: (context, ref, _) {
        final allStoryDetailsState = ref.watch(allstoryProvider);
        return allStoryDetailsState is AllStorySuccessState
            ? PageView.builder(
                controller: pageUserController,
                physics: const ClampingScrollPhysics(),
                pageSnapping: true,
                itemCount: ref.read(allstoryProvider.notifier).usersStoryDetails!.length,
                itemBuilder: (context, i) {
                  // userIndex = i;
                  return Stack(
                    children: [
                      // Transform(
                      //   transform: Matrix4.identity()
                      //     ..rotateY(currentPageValue - i- widget.index)
                      //     ..rotateZ(currentPageValue - i-widget.index),
                      //   child:
                      StorySliderScreen(
                        user: ref.read(allstoryProvider.notifier).usersStoryDetails![i],
                        stories: ref.read(allstoryProvider.notifier).usersStoryDetails![i].story,
                        userIndex: i,
                      ),
                      // ),
                    ],
                  );
                },
              )
            : allStoryDetailsState is AllStoryLoadingState
                ? Stack(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              KColor.storyColorLeft,
                              KColor.storyColorRight,
                            ],
                          )),
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                              child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          ))),
                    ],
                  )
                : Container();
      }),
    );
  }
}
