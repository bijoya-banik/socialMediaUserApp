import 'package:buddyscripts/controller/event/interested_events_controller.dart';
import 'package:buddyscripts/controller/event/state/interested_events_state.dart';
import 'package:buddyscripts/controller/pagination/event/interested_events_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/event_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterestedEventsTab extends ConsumerWidget {
  const InterestedEventsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestedEventsState = ref.watch(interestedEventsProvider);
    final interestedEventsScrollState = ref.watch(interestedEventsScrollProvider);

      ref.listen(interestedEventsScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print('reached bottom');
        ref.read(interestedEventsProvider.notifier).fetchMoreInterestedEvents();
      }
    });

    return CustomScrollView(
      controller: ref.read(interestedEventsScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(interestedEventsProvider.notifier).fetchInterestedEvents()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                interestedEventsState is InterestedEventsSuccessState
                    ? interestedEventsState.eventsModel.data!.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                            child: const KContentUnvailableComponent(message: 'No events'))
                        : Column(
                            children: List.generate(interestedEventsState.eventsModel.data!.length, (index) {
                              return EventCard(eventData: interestedEventsState.eventsModel.data![index]);
                            }),
                          )
                    : const KPagesLoadingIndicator(),
                if (interestedEventsScrollState is ScrollReachedBottomState)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 5),
                    child: const CupertinoActivityIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
