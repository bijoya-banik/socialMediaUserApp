import 'package:buddyscripts/controller/event/going_events_controller.dart';
import 'package:buddyscripts/controller/event/state/going_events_state.dart';
import 'package:buddyscripts/controller/pagination/event/going_events_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/event_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoingEventsTab extends ConsumerWidget {
  const GoingEventsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goingEventsState = ref.watch(goingEventsProvider);
    final goingEventsScrollState = ref.watch(goingEventsScrollProvider);

    ref.listen(goingEventsScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        // print('reached bottom');
        ref.read(goingEventsProvider.notifier).fetchMoreGoingEvents();
      }
    });

    return CustomScrollView(
      controller: ref.read(goingEventsScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(goingEventsProvider.notifier).fetchGoingEvents()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                goingEventsState is GoingEventsSuccessState
                    ? goingEventsState.eventsModel.data!.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                            child: const KContentUnvailableComponent(message: 'No events'))
                        : Column(
                            children: List.generate(goingEventsState.eventsModel.data!.length, (index) {
                              return EventCard(eventData: goingEventsState.eventsModel.data![index]);
                            }),
                          )
                    : const KPagesLoadingIndicator(),
                if (goingEventsScrollState is ScrollReachedBottomState)
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
