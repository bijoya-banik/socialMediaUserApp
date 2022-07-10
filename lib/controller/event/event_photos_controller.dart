import 'package:buddyscripts/controller/event/state/event_photos_state.dart';
import 'package:buddyscripts/models/event/event_photos_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventPhotosProvider = StateNotifierProvider<EventPhotosController,EventPhotosState>(
  (ref) => EventPhotosController(ref: ref),
);

class EventPhotosController extends StateNotifier<EventPhotosState> {
  final Ref? ref;
  EventPhotosController({this.ref}) : super(const EventPhotosInitialState());

  EventPhotosModel? eventPhotosModel;

  Future fetchEventPhotos(String eventName) async {
    state = const EventPhotosLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.eventDetails(eventName, tab: 'photos')),
      );
      if (responseBody != null) {
        eventPhotosModel = EventPhotosModel.fromJson(responseBody);
        state = EventPhotosSuccessState(eventPhotosModel!);
      } else {
        state = const EventPhotosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchEventPhotos(): $error");
      print(stackTrace);
      state = const EventPhotosErrorState();
    }
  }
}
