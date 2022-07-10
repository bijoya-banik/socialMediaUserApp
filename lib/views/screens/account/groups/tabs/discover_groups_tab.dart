import 'package:buddyscripts/controller/group/discover_groups_controller.dart';
import 'package:buddyscripts/controller/group/group_controller.dart';
import 'package:buddyscripts/controller/group/state/discover_groups_state.dart';
import 'package:buddyscripts/controller/pagination/group/discover_groups_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/group_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverGroupsTab extends ConsumerWidget {
  const DiscoverGroupsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoverGroupsState = ref.watch(discoverGroupsProvider);
    final discoverGroupsScrollState = ref.watch(discoverGroupsScrollProvider);

       ref.listen(discoverGroupsScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print('reached bottom');
        ref.read(discoverGroupsProvider.notifier).fetchMoreDiscoverGroups();
      }
    });

    return CustomScrollView(
      controller: ref.read(discoverGroupsScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(discoverGroupsProvider.notifier).fetchDiscoverGroupList()),
        SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: discoverGroupsState is DiscoverGroupsSuccessState
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        discoverGroupsState.groupsModel.data!.isNotEmpty
                            ? Wrap(
                                runSpacing: 15,
                                spacing: 15,
                                alignment: WrapAlignment.start,
                                children: List.generate(discoverGroupsState.groupsModel.data!.length, (index) {
                                  return GroupCard(discoverGroupsState.groupsModel.data![index], GroupType.DISCOVER);
                                }),
                              )
                            : Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                                child: const KContentUnvailableComponent(message: 'No Groups available')),
                        if (discoverGroupsScrollState is ScrollReachedBottomState)
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10, top: 5),
                            child: const CupertinoActivityIndicator(),
                          ),
                      ],
                    )
                  : const KPagesLoadingIndicator(),
            )),
      ],
    );
  }
}
