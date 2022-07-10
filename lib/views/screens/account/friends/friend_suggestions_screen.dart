// ignore: must_be_immutable
import 'package:buddyscripts/controller/friends/all_friends_controller.dart';
import 'package:buddyscripts/controller/friends/friend_suggestions_controller.dart';
import 'package:buddyscripts/controller/friends/state/friend_suggestions_state.dart';
import 'package:buddyscripts/controller/pagination/friends/friend_suggestions_scroll_provider.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:buddyscripts/views/screens/account/components/friends_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendSuggestionsScreen extends ConsumerWidget {
  const FriendSuggestionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendSuggestionsState = ref.watch(friendSuggestionsprovider);
    final friendSuggestionsScrollState = ref.watch(friendSuggestionsScrollProvider);

    
       ref.listen(friendSuggestionsScrollProvider, (_, state) {
          if (state is ScrollReachedBottomState) {
            print('reached bottom');
            ref.read(friendSuggestionsprovider.notifier).fetchMoreFriendSuggestions();
          }
        });

    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(title: 'Discover', automaticallyImplyLeading: false, hasLeading: true),
      child: friendSuggestionsState is FriendSuggestionsSuccessState
          ? CustomScrollView(
            controller: ref.read(friendSuggestionsScrollProvider.notifier).controller,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverRefreshControl(onRefresh: () => ref.read(friendSuggestionsprovider.notifier).fetchFriendSuggestions()),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('People you may know', style: KTextStyle.headline5.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                      SizedBox(height: KSize.getHeight(context, 20)),
                      Column(
                        children: List.generate(friendSuggestionsState.friendSuggestionsModel.data!.length, (index) {
                          return FriendsCard(
                              type: FriendType.SUGGESTIONS, friendData: friendSuggestionsState.friendSuggestionsModel.data![index]);
                        }),
                      ),
                      if (friendSuggestionsScrollState is ScrollReachedBottomState)
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
