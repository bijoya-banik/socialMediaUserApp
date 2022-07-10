import 'package:buddyscripts/controller/page/followed_pages_controller.dart';
import 'package:buddyscripts/controller/page/state/followed_pages_state.dart';
import 'package:buddyscripts/controller/pagination/page/followed_pages_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/page_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowedPagesTab extends ConsumerWidget {
  const FollowedPagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followedPagesState = ref.watch(followedPagesProvider);
    final followedPagesScrollState = ref.watch(followedPagesScrollProvider);


       ref.listen(followedPagesScrollProvider, (_, state) {
     if (state is ScrollReachedBottomState) {
          ref.read(followedPagesProvider.notifier).fetchMorefollowedPages();
        }
    });

    return CustomScrollView(
      controller: ref.read(followedPagesScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(followedPagesProvider.notifier).fetchFollowedPages()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          sliver: SliverToBoxAdapter(
              child: Column(
            children: [
              followedPagesState is FollowedPagesSuccessState
                  ? followedPagesState.pagesModel.data!.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 2 + 20, child: const KContentUnvailableComponent(message: 'No followed pages!'))
                      : Wrap(
                          spacing: 15,
                          alignment: WrapAlignment.center,
                          children: List.generate(followedPagesState.pagesModel.data!.length, (index) {
                            return PageCard('Followed', followedPagesState.pagesModel.data![index]);
                          }),
                        )
                  : const KPagesLoadingIndicator(),
              if (followedPagesScrollState is ScrollReachedBottomState)
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  child: const CupertinoActivityIndicator(),
                ),
            ],
          )),
        )
      ],
    );
  }
}
