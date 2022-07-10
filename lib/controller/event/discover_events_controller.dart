import 'package:buddyscripts/controller/event/state/discover_events_state.dart';
import 'package:buddyscripts/controller/pagination/event/discover_events_tab.dart';
import 'package:buddyscripts/models/event/events_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final discoverEventsProvider = StateNotifierProvider<DiscoverEventsController,DiscoverEventsState>(
  (ref) => DiscoverEventsController(ref: ref),
);

class DiscoverEventsController extends StateNotifier<DiscoverEventsState> {
  final Ref? ref;
  DiscoverEventsController({this.ref}) : super(const DiscoverEventsInitialState());

  EventsModel? discoverEventsModel;
  int currentPage = 1;


   updateSuccessState(discoverEventsInstance) {
    discoverEventsModel?.data =discoverEventsInstance;
    state = DiscoverEventsSuccessState(discoverEventsModel!);
  }


  Future fetchDiscoverEvents() async {
    state = const DiscoverEventsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.events(tab: 'discover')),
      );
      if (responseBody != null) {
        discoverEventsModel = EventsModel.fromJson(responseBody);
        currentPage = discoverEventsModel?.meta?.currentPage;
        state = DiscoverEventsSuccessState(discoverEventsModel!);
      } else {
        state = const DiscoverEventsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchDiscoverEvents(): $error");
      print(stackTrace);
      state = const DiscoverEventsErrorState();
    }
  }

  Future fetchMoreDiscoverEvents() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.events(tab: 'discover', page: currentPage += 1)),
      );
      if (responseBody != null) {
        EventsModel discoverEventsModelInstance = EventsModel.fromJson(responseBody);
       
        discoverEventsModel?.data?.addAll(discoverEventsModelInstance.data!);

        state = DiscoverEventsSuccessState(discoverEventsModel!);
        ref!.read(discoverEventsScrollProvider.notifier).resetState();
      } else {
        state = const DiscoverEventsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreDiscoverEvents(): $error");
      print(stackTrace);
      state = const DiscoverEventsErrorState();
    }
  }
}
