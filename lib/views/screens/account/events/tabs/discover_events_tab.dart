import 'package:buddyscripts/controller/event/discover_events_controller.dart';
import 'package:buddyscripts/controller/event/state/discover_events_state.dart';
import 'package:buddyscripts/controller/pagination/event/discover_events_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/event_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverEventsTab extends ConsumerWidget {
  const DiscoverEventsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoverEventsState = ref.watch(discoverEventsProvider);
    final discoverEventsScrollState = ref.watch(discoverEventsScrollProvider);

    ref.listen(discoverEventsScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print('reached bottom');
        ref.read(discoverEventsProvider.notifier).fetchMoreDiscoverEvents();
      }
    });

    return CustomScrollView(
      controller: ref.read(discoverEventsScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () => ref.read(discoverEventsProvider.notifier).fetchDiscoverEvents(),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                discoverEventsState is DiscoverEventsSuccessState
                    ? discoverEventsState.eventsModel.data!.isEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 2 + 30, child: const KContentUnvailableComponent(message: 'No events'))
                        : Column(
                            children: List.generate(discoverEventsState.eventsModel.data!.length, (index) {
                              return EventCard(eventData: discoverEventsState.eventsModel.data![index]);
                            }),
                          )
                    : const KPagesLoadingIndicator(),
                if (discoverEventsScrollState is ScrollReachedBottomState)
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
