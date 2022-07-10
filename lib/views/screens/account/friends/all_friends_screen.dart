import 'package:buddyscripts/controller/friends/all_friends_controller.dart';
import 'package:buddyscripts/controller/friends/state/all_friends_state.dart';
import 'package:buddyscripts/controller/pagination/friends/all_friends_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_friends_loading_indicator.dart';
import 'package:buddyscripts/views/screens/account/components/friends_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class AllFriendsScreen extends ConsumerWidget {
  AllFriendsScreen({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allFriendsState = ref.watch(allFriendsprovider);
    final allFriendsScrollState = ref.watch(allFriendsScrollProvider);


       ref.listen(allFriendsScrollProvider, (_, state) {
          if (state is ScrollReachedBottomState) {
            print('reached bottom');
            ref.read(allFriendsprovider.notifier).fetchMoreAllFriends();
          }
        });


    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'All Friends', automaticallyImplyLeading: false, hasLeading: true),
      child: allFriendsState is AllFriendsSuccessState
          ? CustomScrollView(
            controller: ref.read(allFriendsScrollProvider.notifier).controller,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverRefreshControl(onRefresh: () => ref.read(allFriendsprovider.notifier).fetchAllFriends()),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*
                        * Search TextField UI code snippet
                      */
                      //  KTextField(
                      //   controller: searchController,
                      //   hintText: 'Search',
                      //   topMargin: 5,
                      //   hasPrefixIcon: true,
                      //   prefixIcon: Icon(Feather.search, color: KColor.black54, size: 20),
                      //   isClearableField: true,
                      // ),
                      // SizedBox(height: KSize.getHeight(context, 20)),
                      Text(
                          allFriendsState.allFriendsModel.data!.isEmpty
                              ? ""
                              : allFriendsState.allFriendsModel.data!.length > 1
                                  ? '${allFriendsState.allFriendsModel.data!.length} Friends'
                                  : '${allFriendsState.allFriendsModel.data!.length} Friend',
                          style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      if (allFriendsState.allFriendsModel.data!.isEmpty)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .50,
                          child: Center(
                            child: Text("No friends yet!", style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                          ),
                        )
                      else
                        Column(
                          children: List.generate(allFriendsState.allFriendsModel.data!.length, (index) {
                            return FriendsCard(type: FriendType.ALL, friendData: allFriendsState.allFriendsModel.data![index]);
                          }),
                        ),
                      if (allFriendsScrollState is ScrollReachedBottomState)
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
          : const KFriendsLoadingIndicator(),
    );
  }
}
