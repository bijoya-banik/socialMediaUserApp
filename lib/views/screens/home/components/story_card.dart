import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/story/state/story_state.dart';
import 'package:buddyscripts/controller/story/story_controller.dart';
import 'package:buddyscripts/custom_plugin/video_thumbnail_generator.dart';
import 'package:buddyscripts/models/story/story_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/screens/home/create_feed_screen.dart';
import 'package:buddyscripts/views/screens/story/story_user_slider_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryCard extends StatefulWidget {
  final int index;
  final StoryModel storyData;
  const StoryCard(this.index, this.storyData, {Key? key}) : super(key: key);

  @override
  _StoryCardState createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  // @override
  // void initState() {
  //   super.initState();
  //   print('widget.storyData.bgColor =  ${widget.storyData.bgColor}');
  //   print('widget.storyData.bgColor.runtimeType =  ${widget.storyData.bgColor.runtimeType}');
  //   // print(widget.storyData.firstName);
  // }

  int? nxtId;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final storyState = ref.watch(storyProvider);
      return Container(
        height: KSize.getHeight(context, 200),
        width: 115,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: AppMode.darkMode ? KColor.grey600! : KColor.grey350!),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  if (widget.index == 0) {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(fullscreenDialog: true, builder: (context) => const CreateFeedScreen(feedType: FeedType.STORY, story: true)),
                    );
                  } else {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => StoryUserSliderScreen(userData: widget.storyData, index: widget.index - 1)));
                  }
                },
                child: Container(
                    height: KSize.getHeight(context, 200),
                    width: 115,
                    color: KColor.white,
                    child: widget.index == 0
                        ? ref.read(userProvider.notifier).userData == null
                            ? Image.asset(
                                AssetPath.profilePlaceholder,
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                               API.baseUrl+  ref.read(userProvider.notifier).userData!.user!.profilePic!,
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              )
                        : widget.storyData.type == "text"
                            ? Container(
                                decoration: BoxDecoration(
                                    gradient: widget.storyData.bgColor == null || widget.storyData.bgColor == '' || widget.storyData.bgColor == 'null'
                                        ? LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              KColor.storyColorLeft,
                                              KColor.storyColorRight,
                                            ],
                                          )
                                        : KColor.gradientsColor[
                                            KColor.feedBackGroundGradientColors.indexWhere((element) => element == widget.storyData.bgColor) + 2]),
                                height: KSize.getHeight(context, 200),
                                width: 115,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                child: Center(
                                    child: Text(widget.storyData.data,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: KTextStyle.bodyText2.copyWith(color: KColor.whiteConst))),
                              )
                            : widget.storyData.type == "image"
                                ? Image.network(
                                   API.baseUrl+  widget.storyData.data,
                                    height: KSize.getHeight(context, 200),
                                    width: 115,
                                    fit: BoxFit.cover,
                                  )
                                : widget.storyData.type == "video"
                                    ? ThumbnailImage(
                                        type: "story",
                                        videoUrl: widget.storyData.data,
                                        height: KSize.getHeight(context, 200),
                                        width: 115,
                                        fit: BoxFit.cover,
                                      )
                                    : Container()),
              ),
              storyState is StorySuccessState
                  ? widget.index == 0
                      ? Container()
                      : Positioned(
                          left: 6,
                          top: 6,
                          child: Container(
                            height: widget.index == 0 ? 35 : 38,
                            width: widget.index == 0 ? 35 : 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.index == 0 ? KColor.white : KColor.transparent,
                              border: Border.all(width: 1.8, color: widget.index == 0 ? KColor.transparent! : KColor.white54Const),
                            ),
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.all(3),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                API.baseUrl+   widget.storyData.profilePic,
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ))
                  : const Positioned(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
              widget.index == 0
                  ? Positioned(
                      bottom: 0,
                      child: Container(
                        width: 115,
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                          color: KColor.appBackground,
                        ),
                        child: Text("Add to story",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: KTextStyle.caption.copyWith(color: KColor.black, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    )
                  : Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Text('${widget.storyData.firstName} ${widget.storyData.lastName}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: KTextStyle.caption.copyWith(color: KColor.whiteConst, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
              if (widget.index == 0)
                Positioned(
                  bottom: 40,
                  child: Container(
                      height: widget.index == 0 ? 35 : 38,
                      width: widget.index == 0 ? 35 : 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: KColor.grey600!,
                            blurRadius: 66,
                            spreadRadius: 1,
                            offset: const Offset(0, -0.5),
                          ),
                        ],
                        color: widget.index == 0
                            ? AppMode.darkMode
                                ? KColor.grey850
                                : KColor.white
                            : KColor.transparent,
                        border: Border.all(width: 1.8, color: widget.index == 0 ? KColor.transparent! : KColor.white),
                      ),
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                  fullscreenDialog: true, builder: (context) => const CreateFeedScreen(feedType: FeedType.STORY, story: true)),
                            );
                          },
                          child: Icon(Icons.add, color: KColor.appThemeColor))),
                ),
            ],
          ),
        ),
      );
    });
  }
}
