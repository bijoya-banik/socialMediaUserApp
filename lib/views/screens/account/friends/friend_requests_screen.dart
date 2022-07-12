import 'package:buddyscripts/controller/friends/all_friends_controller.dart';
import 'package:buddyscripts/controller/friends/friend_requests_controller.dart';
import 'package:buddyscripts/controller/friends/friend_suggestions_controller.dart';
import 'package:buddyscripts/controller/friends/state/friend_requests_state.dart';
import 'package:buddyscripts/controller/pagination/friends/friend_requests_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_friends_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/screens/account/components/friend_requests_card.dart';
import 'package:buddyscripts/views/screens/account/friends/all_friends_screen.dart';
import 'package:buddyscripts/views/screens/account/friends/friend_suggestions_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class FriendRequestsScreen extends ConsumerWidget {
  FriendRequestsScreen({Key? key}) : super(key: key);

 // List friendTabs = ['Discover', 'My Friends'];
  List friendTabs = [ 'All Friends'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRequestsState = ref.watch(friendRequestsProvider);
    final friendRequestsScrollState = ref.watch(friendRequestsScrollProvider);

   ref.listen(friendRequestsScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print('reached bottom');
        ref.read(friendRequestsProvider.notifier).fetchMoreFriendRequests();
      }
    });

    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'Friends', automaticallyImplyLeading: false, hasLeading: true),
      child: friendRequestsState is FriendRequestsSuccessState
          ? CustomScrollView(
            controller: ref.read(friendRequestsScrollProvider.notifier).controller,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverRefreshControl(onRefresh: () => ref.read(friendRequestsProvider.notifier).fetchFriendRequests()),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                sliver: SliverToBoxAdapter(
                  child: Column(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        width: MediaQuery.of(context).size.width,
                        height: KSize.getHeight(context, 50),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: friendTabs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (friendTabs[index] == 'Discover') {
                                  ref.read(friendSuggestionsprovider.notifier).fetchFriendSuggestions();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const FriendSuggestionsScreen()));
                                } else {
                                  ref.read(allFriendsprovider.notifier).fetchAllFriends();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => AllFriendsScreen()));
                                }
                              },
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: KColor.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Text(friendTabs[index], style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: KSize.getHeight(context, 15)),
                      Container(
                         alignment: Alignment.topLeft,
                        child: Text(
                          'Friend Requests', 
                        style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                      ),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      if (friendRequestsState.friendRequestsModel.data!.isEmpty)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .50,
                          child: Center(
                            child: Text("No pending requests", style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                          ),
                        )
                      else
                        Column(
                          children: List.generate(friendRequestsState.friendRequestsModel.data!.length, (index) {
                            return FriendRequestsCard(friendRequestsState.friendRequestsModel.data![index]);
                          }),
                        ),
                      if (friendRequestsScrollState is ScrollReachedBottomState)
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
