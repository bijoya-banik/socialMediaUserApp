import 'package:buddyscripts/models/event/event_feed_model.dart';

abstract class EventFeedState {
  const EventFeedState();
}

class EventFeedInitialState extends EventFeedState {
  const EventFeedInitialState();
}

class EventFeedLoadingState extends EventFeedState {
  const EventFeedLoadingState();
}

class EventFeedSuccessState extends EventFeedState {
  final EventFeedModel eventFeedModel;
  const EventFeedSuccessState(this.eventFeedModel);
}

class EventFeedErrorState extends EventFeedState {
  const EventFeedErrorState();
}

