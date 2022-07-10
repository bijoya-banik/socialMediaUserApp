import 'package:buddyscripts/controller/event/state/event_about_state.dart';
import 'package:buddyscripts/models/event/event_about_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventAboutProvider = StateNotifierProvider<EventAboutController,EventAboutState>(
  (ref) => EventAboutController(ref: ref),
);

class EventAboutController extends StateNotifier<EventAboutState> {
  final Ref? ref;
  EventAboutController({this.ref}) : super(const EventAboutInitialState());

  EventAboutModel? eventAboutModel;

  Future fetchEventAbout(String eventName) async {
    state = const EventAboutLoadingState();

    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.eventDetails(eventName, tab: 'about')));
      if (responseBody != null) {
        eventAboutModel = EventAboutModel.fromJson(responseBody);
        state = EventAboutSuccessState(eventAboutModel!);
      } else {
        state = const EventAboutErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchEventAbout(): $error");
      print(stackTrace);
      state = const EventAboutErrorState();
    }
  }
}
