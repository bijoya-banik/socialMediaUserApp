import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/feed/feed_reacted_users_controller.dart';
import 'package:buddyscripts/controller/feed/state/feed_reacted_users_state.dart';
import 'package:buddyscripts/controller/feed/state/feed_reaction_types_state.dart';
import 'package:buddyscripts/controller/pagination/feed/feed_reacted_users_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_loading_indicator.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReactedUsersCountScreen extends StatefulWidget {
  final int? feedId;
  const ReactedUsersCountScreen({Key? key, this.feedId}) : super(key: key);

  @override
  _ReactedUsersCountScreenState createState() => _ReactedUsersCountScreenState();
}

class _ReactedUsersCountScreenState extends State<ReactedUsersCountScreen> with TickerProviderStateMixin {
  String reactionType = 'all';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final reactionTypesState = ref.watch(feedReactionTypesProvider);
        final reactionTypes = reactionTypesState is FeedReactionTypesSuccessState ? reactionTypesState.feedReactionTypesModel : [];

        final reactedUsersState = ref.watch(feedReactedUsersProvider);
        final reactedUsers = reactedUsersState is FeedReactedUsersSuccessState ? reactedUsersState.feedReactedUsersModel : [];
        final reactedUsersScrollState = ref.watch(feedReactedUsersScrollProvider);

        ref.listen(feedReactedUsersScrollProvider, (_, state) {
          if (state is ScrollReachedBottomState) {
            print("state is ScrollReachedBottomState");

            ref.read(feedReactedUsersProvider.notifier).fetchMoreFeedReactedUsers(widget.feedId!, reactionType: reactionType);
          }
        });

        return DefaultTabController(
          length: reactionTypes!.length,
          child: Scaffold(
            backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.white,
            appBar: AppBar(
              backgroundColor: KColor.secondary,
              elevation: 1,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 18, color: KColor.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text('People who reacted', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.black)),
              bottom: reactionTypesState is FeedReactionTypesSuccessState
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(50),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                          isScrollable: true,
                          labelColor: KColor.black,
                          labelStyle: KTextStyle.subtitle2,
                          onTap: (index) {
                            ref.read(feedReactedUsersProvider.notifier).fetchFeedReactedUsers(
                                  widget.feedId!,
                                  reactionType:
                                      ref.read(feedReactionTypesProvider.notifier).feedReactionTypesModel![index].reactionType!.toLowerCase(),
                                );
                            setState(() {
                              reactionType = reactionTypes[index].reactionType;
                            });
                          },
                          tabs: List.generate(reactionTypes.length, (index) {
                            return Tab(
                              icon: Row(
                                children: [
                                  if (index != 0)
                                    Image.asset(
                                      reactionTypes[index].reactionType == 'LOVE'
                                          ? AssetPath.loveReaction
                                          : reactionTypes[index].reactionType == 'HAHA'
                                              ? AssetPath.hahaReaction
                                              : reactionTypes[index].reactionType == 'WOW'
                                                  ? AssetPath.wowReaction
                                                  : reactionTypes[index].reactionType == 'SAD'
                                                      ? AssetPath.sadReaction
                                                      : reactionTypes[index].reactionType == 'ANGRY'
                                                          ? AssetPath.angryReaction
                                                          : AssetPath.likeReaction,
                                      height: 27,
                                    ),
                                  if (index != 0) const SizedBox(width: 8),
                                  Text(
                                    index == 0 ? 'All' : '${reactionTypes[index].meta.totalLikes}',
                                    style: KTextStyle.bodyText1.copyWith(color: KColor.black),
                                  ),
                                ],
                              ),
                            );
                          }),
                          indicatorColor: KColor.buttonBackground,
                        ),
                      ),
                    )
                  : null,
            ),
            body: reactionTypesState is FeedReactionTypesSuccessState && reactedUsersState is FeedReactedUsersSuccessState
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: KSize.getHeight(context, 5)),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(reactionTypes.length, (index) {
                            return Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    controller: ref.read(feedReactedUsersScrollProvider.notifier).controller,
                                    itemCount: reactedUsers.length,
                                    itemBuilder: (BuildContext context, i) {
                                      return Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 3),
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                UserProfilePicture(
                                                    userId: reactedUsers[i].user.id,
                                                    slug: reactedUsers[i].user.username,
                                                    profileURL: reactedUsers[i].user.profilePic,
                                                    avatarRadius: 22,
                                                    onTapNavigate: true,
                                                    iconSize: 21.5),

                                                /// Reaction img stack
                                                // if (index != 0)
                                                //   Positioned(
                                                //     right: 6,
                                                //     bottom: 1,
                                                //     child: Container(
                                                //       decoration:
                                                //           BoxDecoration(border: Border.all(color: KColor.white, width: 1.5), shape: BoxShape.circle),
                                                //       child: Image.asset(
                                                //         reactionTypes[index].reactionType == 'LOVE'
                                                //             ? AssetPath.loveReaction
                                                //             : reactionTypes[index].reactionType == 'HAHA'
                                                //                 ? AssetPath.hahaReaction
                                                //                 : reactionTypes[index].reactionType == 'WOW'
                                                //                     ? AssetPath.wowReaction
                                                //                     : reactionTypes[index].reactionType == 'SAD'
                                                //                         ? AssetPath.sadReaction
                                                //                         : reactionTypes[index].reactionType == 'ANGRY'
                                                //                             ? AssetPath.angryReaction
                                                //                             : AssetPath.likeReaction,
                                                //         height: 15,
                                                //       ),
                                                //     ),
                                                //   ),
                                              ],
                                            ),
                                            UserName(
                                              userId: reactedUsers[i].user.id,
                                              slug: reactedUsers[i].user.username,
                                              name: "${reactedUsers[i].user.firstName} ${reactedUsers[i].user.lastName}",
                                              onTapNavigate: true,
                                              backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.whiteConst,
                                              textStyle: KTextStyle.bodyText1.copyWith(color: KColor.black87, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (reactedUsersScrollState is ScrollReachedBottomState && reactedUsers.isNotEmpty)
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: const CupertinoActivityIndicator(),
                                  )
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  )
                : const Center(child: KLoadingIndicator()),
          ),
        );
      },
    );
  }
}
