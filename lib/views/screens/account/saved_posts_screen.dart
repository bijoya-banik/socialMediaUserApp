import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/pagination/saved_posts/saved_posts_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/controller/saved_posts/saved_post_controller.dart';
import 'package:buddyscripts/controller/saved_posts/state/saved_posts_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_feed_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedPostsScreen extends ConsumerWidget {
  const SavedPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPostsState = ref.watch(savedPostsProvider);
    final savedPostsScrollState = ref.watch(savedPostsScrollProvider);

    ref.listen(savedPostsScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print('reached bottom');
        ref.read(savedPostsProvider.notifier).fetchMoreSavedPosts();
      }
    });
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'Saved Posts', automaticallyImplyLeading: false, hasLeading: true),
      child: savedPostsState is SavedPostsSuccessState
          ? savedPostsState.savedPostsModel.feedData!.data!.isEmpty
              ? const Center(
                  child: KContentUnvailableComponent(message: 'You haven\'t saved any posts yet!'),
                )
              : CustomScrollView(
                  controller: ref.read(savedPostsScrollProvider.notifier).controller,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    CupertinoSliverRefreshControl(onRefresh: () => ref.read(savedPostsProvider.notifier).fetchSavedPosts()),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Column(
                              children: List.generate(savedPostsState.savedPostsModel.feedData!.data!.length, (index) {
                                return FeedCard(feedType: FeedType.SAVED, feedData: savedPostsState.savedPostsModel.feedData!.data![index]);
                              }),
                            ),
                            if (savedPostsScrollState is ScrollReachedBottomState)
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 15, top: 5),
                                child: const CupertinoActivityIndicator(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
          : const KFeedLoadingIndicator(),
    );
  }
}
