import 'package:buddyscripts/controller/page/my_pages_controller.dart';
import 'package:buddyscripts/controller/page/state/my_pages_state.dart';
import 'package:buddyscripts/controller/pagination/page/my_pages_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/page_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPagesTab extends ConsumerWidget {
  const MyPagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPagesState = ref.watch(myPagesProvider);
    final myPagesScrollState = ref.watch(myPagesScrollProvider);

      ref.listen(myPagesScrollProvider, (_, state) {
     if (state is ScrollReachedBottomState) {
          ref.read(myPagesProvider.notifier).fetchMoreMyPages();
        }
    });

    return CustomScrollView(
      controller: ref.read(myPagesScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(myPagesProvider.notifier).fetchMyPages()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          sliver: SliverToBoxAdapter(
              child: Column(
            children: [
              myPagesState is MyPagesSuccessState
                  ? myPagesState.pagesModel.data!.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 2 + 20,
                          child: const KContentUnvailableComponent(message: 'You have no pages yet!'))
                      : Wrap(
                          spacing: 15,
                          alignment: WrapAlignment.center,
                          children: List.generate(myPagesState.pagesModel.data!.length, (index) {
                            return PageCard('Mine', myPagesState.pagesModel.data![index]);
                          }),
                        )
                  : const KPagesLoadingIndicator(),
              if (myPagesScrollState is ScrollReachedBottomState)
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
