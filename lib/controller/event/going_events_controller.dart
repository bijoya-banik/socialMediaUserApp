import 'package:buddyscripts/controller/event/state/going_events_state.dart';
import 'package:buddyscripts/controller/pagination/event/going_events_tab.dart';
import 'package:buddyscripts/models/event/events_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goingEventsProvider = StateNotifierProvider<GoingEventsController,GoingEventsState>(
  (ref) => GoingEventsController(ref: ref),
);

class GoingEventsController extends StateNotifier<GoingEventsState> {
  final Ref? ref;
  GoingEventsController({this.ref}) : super(const GoingEventsInitialState());

  EventsModel? goingEventsModel;
  int currentPage = 1;

  updateSuccessState(goingEventsInstance) {
    goingEventsModel?.data = goingEventsInstance;
    state = GoingEventsSuccessState(goingEventsModel!);
  }

  Future fetchGoingEvents() async {
    state = const GoingEventsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.events(tab: 'going')),
      );
      if (responseBody != null) {
        goingEventsModel = EventsModel.fromJson(responseBody);
        currentPage = goingEventsModel?.meta?.currentPage;
        state = GoingEventsSuccessState(goingEventsModel!);
      } else {
        state = const GoingEventsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchGoingEvents(): $error");
      print(stackTrace);
      state = const GoingEventsErrorState();
    }
  }

  Future fetchMoreGoingEvents() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.events(tab: 'going', page: currentPage += 1)),
      );
      if (responseBody != null) {
        var goingEventsModelInstance = EventsModel.fromJson(responseBody);
        goingEventsModel?.data?.addAll(goingEventsModelInstance.data!);
        state = GoingEventsSuccessState(goingEventsModel!);
        ref!.read(goingEventsScrollProvider.notifier).resetState();
      } else {
        state = const GoingEventsErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreGoingEvents(): $error");
      print(stackTrace);
      state = const GoingEventsErrorState();
    }
  }
}
