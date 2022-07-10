import 'package:buddyscripts/controller/group/group_controller.dart';
import 'package:buddyscripts/controller/group/my_groups_controller.dart';
import 'package:buddyscripts/controller/group/state/my_groups_state.dart';
import 'package:buddyscripts/controller/pagination/group/my_groups_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/group_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyGroupsTab extends ConsumerWidget {
  const MyGroupsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myGroupsState = ref.watch(myGroupsProvider);
    final myGroupsScrollState = ref.watch(myGroupsScrollProvider);

    ref.listen(myGroupsScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print('reached bottom');
        if (ref.read(myGroupsProvider.notifier).myGroupsModel!.meta!.currentPage !=
            ref.read(myGroupsProvider.notifier).myGroupsModel!.meta!.lastPage) {
          ref.read(myGroupsProvider.notifier).fetchMoreMyGroups();
        }
      }
    });

    return CustomScrollView(
      controller: ref.read(myGroupsScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(myGroupsProvider.notifier).fetchMyGroupList()),
        SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: myGroupsState is MyGroupsSuccessState
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        myGroupsState.groupsModel.data!.isNotEmpty
                            ? Wrap(
                                runSpacing: 15,
                                spacing: 15,
                                alignment: WrapAlignment.start,
                                children: List.generate(myGroupsState.groupsModel.data!.length, (index) {
                                  return GroupCard(myGroupsState.groupsModel.data![index], GroupType.MYGROUP);
                                }),
                              )
                            : Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                                child: const KContentUnvailableComponent(message: 'No Groups created')),
                        if (ref.read(myGroupsProvider.notifier).myGroupsModel!.meta!.currentPage !=
                                ref.read(myGroupsProvider.notifier).myGroupsModel!.meta!.lastPage &&
                            myGroupsScrollState is ScrollReachedBottomState)
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
