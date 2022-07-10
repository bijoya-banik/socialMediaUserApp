import 'package:buddyscripts/models/event/events_model.dart';

abstract class InterestedEventsState {
  const InterestedEventsState();
}

class InterestedEventsInitialState extends InterestedEventsState {
  const InterestedEventsInitialState();
}

class InterestedEventsLoadingState extends InterestedEventsState {
  const InterestedEventsLoadingState();
}

class InterestedEventsSuccessState extends InterestedEventsState {
  final EventsModel eventsModel;
  const InterestedEventsSuccessState(this.eventsModel);
}

class InterestedEventsErrorState extends InterestedEventsState {
  const InterestedEventsErrorState();
}
