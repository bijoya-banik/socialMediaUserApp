import 'package:buddyscripts/controller/event/state/event_videos_state.dart';
import 'package:buddyscripts/models/event/event_videos_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventVideosProvider = StateNotifierProvider<EventVideosController,EventVideosState>(
  (ref) => EventVideosController(ref: ref),
);

class EventVideosController extends StateNotifier<EventVideosState> {
  final Ref? ref;
  EventVideosController({this.ref}) : super(const EventVideosInitialState());

  EventVideosModel? eventVideosModel;

  Future fetchEventVideos(String eventName) async {
    state = const EventVideosLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.eventDetails(eventName, tab: 'videos')),
      );
      if (responseBody != null) {
        eventVideosModel = EventVideosModel.fromJson(responseBody);
        state = EventVideosSuccessState(eventVideosModel!);
      } else {
        state = const EventVideosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchEventVideos(): $error");
      print(stackTrace);
      state = const EventVideosErrorState();
    }
  }
}
