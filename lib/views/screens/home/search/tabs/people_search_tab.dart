import 'package:buddyscripts/controller/friends/all_friends_controller.dart';
import 'package:buddyscripts/controller/search/search_controlller.dart';
import 'package:buddyscripts/controller/search/state/search_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:buddyscripts/views/screens/account/components/friends_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeopleSearchTab extends ConsumerWidget {
   const PeopleSearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    return searchState is SearchSuccessState
        ? searchState.response.length == 0
            ? const KContentUnvailableComponent(message: 'No match found!', isSearch: true)
            : Container(
                width: MediaQuery.of(context).size.width,
                height: KSize.getHeight(context, 60),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics:const BouncingScrollPhysics(),
                    itemCount: searchState.response.length,
                    itemBuilder: (context, index) {
                      return FriendsCard(type: FriendType.ALL, friendData: searchState.response[index]);
                    }),
              )
        : const KPagesLoadingIndicator();
  }
}
