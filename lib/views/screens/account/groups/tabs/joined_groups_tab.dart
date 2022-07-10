import 'package:buddyscripts/controller/group/group_controller.dart';
import 'package:buddyscripts/controller/group/joined_groups_controller.dart';
import 'package:buddyscripts/controller/group/state/joined_groups_state.dart';
import 'package:buddyscripts/controller/pagination/group/joined_groups_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/group_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinedGroupsTab extends ConsumerWidget {
  const JoinedGroupsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinedGroupsState = ref.watch(joinedGroupsProvider);
    final joinedGroupsScrollState = ref.watch(joinedGroupsScrollProvider);

    ref.listen(joinedGroupsScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print('reached bottom');
        if (ref.read(joinedGroupsProvider.notifier).joinedGroupsModel!.meta!.currentPage !=
            ref.read(joinedGroupsProvider.notifier).joinedGroupsModel!.meta!.lastPage) {
          ref.read(joinedGroupsProvider.notifier).fetchMoreJoinedGroups();
        }
      }
    });

    return CustomScrollView(
      controller: ref.read(joinedGroupsScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(joinedGroupsProvider.notifier).fetchJoinedGroupList()),
        SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: joinedGroupsState is JoinedGroupsSuccessState
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        joinedGroupsState.groupsModel.data!.isNotEmpty
                            ? Wrap(
                                runSpacing: 15,
                                spacing: 15,
                                alignment: WrapAlignment.start,
                                children: List.generate(joinedGroupsState.groupsModel.data!.length, (index) {
                                  return GroupCard(joinedGroupsState.groupsModel.data![index], GroupType.JOINED);
                                }),
                              )
                            : Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                                child: const KContentUnvailableComponent(message: 'No Groups joined')),
                        if (ref.read(joinedGroupsProvider.notifier).joinedGroupsModel!.meta!.currentPage !=
                                ref.read(joinedGroupsProvider.notifier).joinedGroupsModel!.meta!.lastPage &&
                            joinedGroupsScrollState is ScrollReachedBottomState)
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
