import 'package:buddyscripts/models/event/events_model.dart';

abstract class GoingEventsState {
  const GoingEventsState();
}

class GoingEventsInitialState extends GoingEventsState {
  const GoingEventsInitialState();
}

class GoingEventsLoadingState extends GoingEventsState {
  const GoingEventsLoadingState();
}

class GoingEventsSuccessState extends GoingEventsState {
  final EventsModel eventsModel;
  const GoingEventsSuccessState(this.eventsModel);
}

class GoingEventsErrorState extends GoingEventsState {
  const GoingEventsErrorState();
}
