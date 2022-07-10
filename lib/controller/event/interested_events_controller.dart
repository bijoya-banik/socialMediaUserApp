import 'package:buddyscripts/controller/event/state/interested_events_state.dart';
import 'package:buddyscripts/controller/pagination/event/interested_events_tab.dart';
import 'package:buddyscripts/models/event/events_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final interestedEventsProvider = StateNotifierProvider<InterestedEventsController,InterestedEventsState>(
  (ref) => InterestedEventsController(ref: ref),
);

class InterestedEventsController extends StateNotifier<InterestedEventsState> {
  final Ref? ref;
  InterestedEventsController({this.ref}) : super(const InterestedEventsInitialState());

  EventsModel? interestedEventsModel;
  int currentPage = 1;

  updateSuccessState(interestedEventsInstance) {
    interestedEventsModel?.data = interestedEventsInstance;
    state = InterestedEventsSuccessState(interestedEventsModel!);
  }

  Future fetchInterestedEvents() async {
    state = const InterestedEventsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.events(tab: 'interested')),
      );
      if (responseBody != null) {
        interestedEventsModel = EventsModel.fromJson(responseBody);
        currentPage = interestedEventsModel?.meta?.currentPage;
        state = InterestedEventsSuccessState(interestedEventsModel!);
      } else {
        state = const InterestedEventsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchInterestedEvents(): $error");
      print(stackTrace);
      state = const InterestedEventsErrorState();
    }
  }

  Future fetchMoreInterestedEvents() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.events(tab: 'interested', page: currentPage += 1)),
      );
      if (responseBody != null) {
        var interestedEventsModelInstance = EventsModel.fromJson(responseBody);
        interestedEventsModel?.data?.addAll(interestedEventsModelInstance.data!);
        state = InterestedEventsSuccessState(interestedEventsModel!);
        ref!.read(interestedEventsScrollProvider.notifier).resetState();
      } else {
        state = const InterestedEventsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreInterestedEvents(): $error");
      print(stackTrace);
      state = const InterestedEventsErrorState();
    }
  }
}
