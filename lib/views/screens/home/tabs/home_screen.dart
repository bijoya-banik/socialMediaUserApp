import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/chat/chat_friends_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/personal_feed_controller.dart';
import 'package:buddyscripts/controller/feed/state/personal_feed_state.dart';
import 'package:buddyscripts/controller/feed/state/world_feed_state.dart';
import 'package:buddyscripts/controller/feed/world_feed_controller.dart';
import 'package:buddyscripts/controller/pagination/home/world_feed_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/controller/story/all_story_controller.dart';
import 'package:buddyscripts/controller/story/state/story_state.dart';
import 'package:buddyscripts/controller/story/story_controller.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_feed_loading_indicator.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/screens/home/components/story_card.dart';
import 'package:buddyscripts/views/screens/home/search/search_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class HomeScreen extends ConsumerStatefulWidget {
  int? initialIndex;

  HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeScreen> {
  List tabs = ['Public Post', 'Friend\'s Post'];

  int? tabIndex = 0;

  @override
  void initState() {
    tabIndex = widget.initialIndex;

    if (ref.read(userProvider.notifier).userData == null) {
      tabIndex = 0;
    } else {
      if (ref.read(userProvider.notifier).userData?.user?.defaultFeed ==
          "personal") {
        tabIndex = 1;
      } else {
        tabIndex = 0;
      }
    }

    super.initState();
  }

  // @override
  // void dispose() {
  // context.read(worldFeedScrollProvider).controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final chatFriendsState = ref.watch(chatFriendsProvider);
      final storyState = ref.watch(storyProvider);

      final personalFeedState = ref.watch(personalFeedProvider);

      final worldFeedState = ref.watch(worldFeedProvider);
      final worldFeedScrollState = ref.watch(worldFeedScrollProvider);

      ref.listen(worldFeedScrollProvider, (_, state) {
        if (state is ScrollReachedBottomState) {
          if (tabIndex == 0) {
            ref.read(worldFeedProvider.notifier).fetchMoreWorldFeed();
          } else {
            ref.read(personalFeedProvider.notifier).fetchMorePersonalFeed();
          }
        }
      });

      return Scaffold(
        backgroundColor: KColor.darkAppBackground,
        body: NestedScrollView(
          controller: ref.read(worldFeedScrollProvider.notifier).controller,
          physics: const BouncingScrollPhysics(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: false,
                pinned: true,
                floating: true,
                leadingWidth: 0,
                backgroundColor:
                    AppMode.darkMode ? KColor.appBackground : KColor.whiteConst,
                automaticallyImplyLeading: false,
                elevation: 1,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                            AssetPath.fullLogo,
                            fit: BoxFit.cover,
                            height: KSize.getHeight(context, 38),
                          ),
                        )),
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const SearchScreen()));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(8.5),
                              decoration: BoxDecoration(
                                  color: KColor.primary.withOpacity(0.125),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Icon(Feather.search,
                                  color: KColor.primary, size: 20),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: List.generate(2, (index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: tabIndex != index
                                        ? KColor.secondary
                                        : KColor.buttonBackground,
                                    width: 2),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                if (tabIndex != index) {
                                  setState(() {
                                    tabIndex = index;
                                  });

                                  ref
                                      .read(worldFeedScrollProvider.notifier)
                                      .controller
                                      .animateTo(
                                        ref
                                            .read(worldFeedScrollProvider
                                                .notifier)
                                            .controller
                                            .position
                                            .minScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.fastOutSlowIn,
                                      );
                                }
                              },
                              child: Text(tabs[index],
                                  style: KTextStyle.subtitle2.copyWith(
                                    color: tabIndex != index
                                        ? KColor.black54
                                        : KColor.black,
                                  )),
                            ),
                          );
                        }),
                      ),
                    )),
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: () async {
              ref.read(worldFeedProvider.notifier).fetchWorldFeed();
              ref.read(personalFeedProvider.notifier).fetchPersonalFeed();
              ref.read(storyProvider.notifier).fetchStory();
              ref.read(allstoryProvider.notifier).fetchAllStory();
            },
            child: SingleChildScrollView(
              // If I add controller here instead of in nested scroll view,
              // we can get the perfect lazy load on scroll
              // but then sliver appbar won't hide on scroll down
              // controller: ref.read(worldFeedScrollProvider.notifier).controller,
              child: Column(
                //padding: EdgeInsets.zero,
                children: [
                  Column(
                    children: [
                      storyState is StorySuccessState &&
                              storyState.storyModel.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: KSize.getHeight(context, 220),
                              padding: EdgeInsets.only(
                                  left: KSize.getWidth(context, 12),
                                  top: KSize.getWidth(context, 12),
                                  bottom: KSize.getWidth(context, 12)),
                              alignment: Alignment.centerLeft,
                              color: AppMode.darkMode
                                  ? KColor.appBackground
                                  : KColor.white,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: storyState.storyModel.length,
                                  itemBuilder: (context, index) {
                                    return StoryCard(
                                        index, storyState.storyModel[index]);
                                  }),
                            )
                          : const StoryLoadingWidget(),
                      SizedBox(height: KSize.getHeight(context, 12)),
                      // chatFriendsState is ChatFriendsSuccessState && chatFriendsState.chatFriendsModel.data!.isNotEmpty
                      //     ? Container(
                      //         height: KSize.getHeight(context, 110),
                      //         margin: EdgeInsets.symmetric(vertical: KSize.getWidth(context, 12)),
                      //         padding: EdgeInsets.only(
                      //           left: KSize.getWidth(context, 12),
                      //           top: KSize.getWidth(context, 16),
                      //           bottom: KSize.getWidth(context, 10),
                      //         ),
                      //         alignment: Alignment.centerLeft,
                      //         // color: AppMode.darkMode ? KColor.darkAppBackground : KColor.white,
                      //         child: ListView.builder(
                      //             shrinkWrap: true,
                      //             physics: const BouncingScrollPhysics(),
                      //             scrollDirection: Axis.horizontal,
                      //             itemCount: chatFriendsState.chatFriendsModel.data!.length,
                      //             itemBuilder: (context, index) {
                      //               return OnlineFriendsComponent(
                      //                 friendData: chatFriendsState.chatFriendsModel.data![index],
                      //               );
                      //             }),
                      //       )
                      //     : SizedBox(height: KSize.getHeight(context, 12)),
                    ],
                  ),
                  Column(
                    children: [
                      tabIndex == 0
                          ? worldFeedState is WorldFeedSuccessState
                              ? worldFeedState.feedModel.isEmpty
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 80),
                                      child: const KContentUnvailableComponent(
                                        message: "No posts available",
                                      ),
                                    )
                                  :

                                  // Wrap(
                                  //     spacing: 15,
                                  //     alignment: WrapAlignment.center,
                                  //     children: List.generate(worldFeedState.feedModel.length, (index) {
                                  //       return
                                  ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          worldFeedState.feedModel.length,
                                      itemBuilder: (context, index) {
                                        return Hero(
                                            tag: index,
                                            child: FeedCard(
                                              feedData: worldFeedState
                                                  .feedModel[index],
                                              feedType: FeedType.HOME,
                                            ));
                                      })
                              : const KFeedLoadingIndicator()
                          : personalFeedState is PersonalFeedSuccessState
                              ? personalFeedState.feedModel.isEmpty
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 80),
                                      child: const KContentUnvailableComponent(
                                        message: "No posts available",
                                      ),
                                    )
                                  :
                                  // Wrap(
                                  //     alignment: WrapAlignment.center,
                                  //     children: List.generate(personalFeedState.feedModel.length, (index) {
                                  //       return
                                  ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          personalFeedState.feedModel.length,
                                      itemBuilder: (context, index) {
                                        return Hero(
                                            tag: index,
                                            child: FeedCard(
                                              feedData: personalFeedState
                                                  .feedModel[index],
                                              feedType: FeedType.HOME,
                                            ));
                                      })
                              : const KFeedLoadingIndicator(),
                      if (worldFeedScrollState is ScrollReachedBottomState)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const CupertinoActivityIndicator(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class StoryLoadingWidget extends ConsumerWidget {
  const StoryLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: KSize.getWidth(context, 12), top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                height: KSize.getHeight(context, 200),
                width: MediaQuery.of(context).size.width / 3.8,
                color: KColor.white,
                child: ref.read(userProvider.notifier).userData == null
                    ? Image.asset(
                        AssetPath.profilePlaceholder,
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                     API.baseUrl+    (ref
                                .read(userProvider.notifier)
                                .userData
                                ?.user
                                ?.profilePic??""),
                           
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                      )),
            Positioned(
                child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //color:KColor.white ,
                      border:
                          Border.all(width: 1.8, color: KColor.transparent!),
                    ),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                    ) //Icon(Icons.add, color: KColor.appThemeColor)

                    ))
          ],
        ),
      ),
    );
  }
}
