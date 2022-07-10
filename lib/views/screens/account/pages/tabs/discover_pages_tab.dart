import 'package:buddyscripts/controller/page/discover_pages_controller.dart';
import 'package:buddyscripts/controller/page/state/discover_pages_state.dart';
import 'package:buddyscripts/controller/pagination/page/discover_pages_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/page_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverPagesTab extends ConsumerWidget {
  const DiscoverPagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoverPagesState = ref.watch(discoverPagesProvider);
    final discoverPagesScrollState = ref.watch(discoverPagesScrollProvider);

    ref.listen(discoverPagesScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print("object");
        print(ref.read(discoverPagesProvider.notifier).discoverPagesModel!.meta!.currentPage);
        print(ref.read(discoverPagesProvider.notifier).discoverPagesModel!.meta!.total);
        if (ref.read(discoverPagesProvider.notifier).discoverPagesModel!.meta!.currentPage <=
            ref.read(discoverPagesProvider.notifier).discoverPagesModel!.meta!.lastPage) {}
      }
    });

    return CustomScrollView(
      controller: ref.read(discoverPagesScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(discoverPagesProvider.notifier).fetchDiscoverPages()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          sliver: SliverToBoxAdapter(
              child: Column(
            children: [
              discoverPagesState is DiscoverPagesSuccessState
                  ? Wrap(
                      spacing: 15,
                      alignment: WrapAlignment.center,
                      children: List.generate(discoverPagesState.pagesModel.data!.length, (index) {
                        return PageCard('Discover', discoverPagesState.pagesModel.data![index]);
                      }),
                    )
                  : const KPagesLoadingIndicator(),
              if (ref.read(discoverPagesProvider.notifier).discoverPagesModel != null &&
                  (ref.read(discoverPagesProvider.notifier).discoverPagesModel!.meta!.currentPage !=
                          ref.read(discoverPagesProvider.notifier).discoverPagesModel!.meta!.lastPage &&
                      discoverPagesScrollState is ScrollReachedBottomState))
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
