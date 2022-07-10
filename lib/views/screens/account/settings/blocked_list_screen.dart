import 'package:buddyscripts/controller/block_user/block_user_controller.dart';
import 'package:buddyscripts/controller/block_user/state/block_user_state.dart';
import 'package:buddyscripts/controller/pagination/block_user/block_user_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:buddyscripts/views/screens/account/components/blocked_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class BlockedListScreen extends ConsumerWidget {
  BlockedListScreen({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockUserState = ref.watch(blockUserProvider);
    final blockUserScrollState = ref.watch(blockUserScrollProvider);

    ref.listen(blockUserScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        ref.read(blockUserProvider.notifier).fetchMoreBlockUser();
      }
    });
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(title: 'Block List', automaticallyImplyLeading: false, hasLeading: true),
      child: blockUserState is BlockUserSuccessState
          ? CustomScrollView(
              controller: ref.read(blockUserScrollProvider.notifier).controller,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                CupertinoSliverRefreshControl(onRefresh: () => ref.read(blockUserProvider.notifier).fetchBlockUser()),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Blocked Users List", style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                        SizedBox(height: KSize.getHeight(context, 20)),
                        if (blockUserState.blockUserModel.data!.isEmpty)
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .50,
                              child: const Center(child: KContentUnvailableComponent(message: "No users found")))
                        else
                          Column(
                            children: List.generate(blockUserState.blockUserModel.data!.length, (index) {
                              return BlockedUserCard(blockUserState.blockUserModel.data![index]);
                            }),
                          ),
                        if (blockUserScrollState is ScrollReachedBottomState)
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
          : const KPagesLoadingIndicator(),
    );
  }
}
