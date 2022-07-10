import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/feed_details_controller.dart';
import 'package:buddyscripts/controller/feed/state/feed_details_state.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_feed_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedDetailsScreen extends ConsumerWidget {
  final bool showCommentModal;
  final int? id;

  const FeedDetailsScreen({Key? key, this.showCommentModal = false, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedDetailsState = ref.watch(feedDetailsProvider);
    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(
        title: "Posts",
        automaticallyImplyLeading: false),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: KSize.getHeight(context, 10)),
              feedDetailsState is FeedDetailsSuccessState
                  ? FeedCard(
                      feedData: feedDetailsState.feedModel,
                      onTapNavigate: false,
                      feedType: FeedType.DETAILS,
                      showCommentModal: showCommentModal,
                    )
                  : const KFeedLoadingIndicator(feedItemCount: 1),
            ],
          ),
        ),
      ),
    );
  }
}
