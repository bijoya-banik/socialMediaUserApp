import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/search/search_controlller.dart';
import 'package:buddyscripts/controller/search/state/search_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_feed_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostSearchTab extends ConsumerWidget {
   const PostSearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    return searchState is SearchSuccessState
        ? searchState.response.length == 0
            ? const KContentUnvailableComponent(message: 'No match found!', isSearch: true)
            : Container(
                width: MediaQuery.of(context).size.width,
                height: KSize.getHeight(context, 60),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics:const BouncingScrollPhysics(),
                    itemCount: searchState.response.length,
                    itemBuilder: (context, index) {
                      return FeedCard(feedData: searchState.response[index], feedType: FeedType.SEARCH);
                    }),
              )
        : const KFeedLoadingIndicator();
  }
}
