import 'package:buddyscripts/models/event/events_model.dart';

abstract class MyEventsState {
  const MyEventsState();
}

class MyEventsInitialState extends MyEventsState {
  const MyEventsInitialState();
}

class MyEventsLoadingState extends MyEventsState {
  const MyEventsLoadingState();
}

class MyEventsSuccessState extends MyEventsState {
  final EventsModel eventsModel;
  const MyEventsSuccessState(this.eventsModel);
}

class MyEventsErrorState extends MyEventsState {
  const MyEventsErrorState();
}
