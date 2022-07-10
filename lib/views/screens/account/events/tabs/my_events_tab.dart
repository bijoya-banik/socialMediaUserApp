import 'package:buddyscripts/controller/event/my_events_controller.dart';
import 'package:buddyscripts/controller/event/state/my_events_state.dart';
import 'package:buddyscripts/controller/pagination/event/my_events_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/screens/account/components/event_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyEventsTab extends ConsumerWidget {
  const MyEventsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myEventsState = ref.watch(myEventsProvider);
    final myEventsScrollState = ref.watch(myEventsScrollProvider);

    
      ref.listen(myEventsScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print('reached bottom');
        ref.read(myEventsProvider.notifier).fetchMoreMyEvents();
      }
    });

    return CustomScrollView(
      controller: ref.read(myEventsScrollProvider.notifier).controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: () => ref.read(myEventsProvider.notifier).fetchMyEvents()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                myEventsState is MyEventsSuccessState
                    ? myEventsState.eventsModel.data!.isEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 2 + 30,
                            child: const KContentUnvailableComponent(message: 'You have no events yet!'))
                        : Column(
                            children: List.generate(myEventsState.eventsModel.data!.length, (index) {
                              return EventCard(eventData: myEventsState.eventsModel.data![index]);
                            }),
                          )
                    : const KPagesLoadingIndicator(),
                if (myEventsScrollState is ScrollReachedBottomState)
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
