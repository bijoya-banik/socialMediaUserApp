import 'package:buddyscripts/models/event/events_model.dart';

abstract class DiscoverEventsState {
  const DiscoverEventsState();
}

class DiscoverEventsInitialState extends DiscoverEventsState {
  const DiscoverEventsInitialState();
}

class DiscoverEventsLoadingState extends DiscoverEventsState {
  const DiscoverEventsLoadingState();
}

class DiscoverEventsSuccessState extends DiscoverEventsState {
  final EventsModel eventsModel;
  const DiscoverEventsSuccessState(this.eventsModel);
}

class DiscoverEventsErrorState extends DiscoverEventsState {
  const DiscoverEventsErrorState();
}
