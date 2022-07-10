import 'package:buddyscripts/models/event/event_videos_model.dart';

abstract class EventVideosState {
  const EventVideosState();
}

class EventVideosInitialState extends EventVideosState {
  const EventVideosInitialState();
}

class EventVideosLoadingState extends EventVideosState {
  const EventVideosLoadingState();
}

class EventVideosSuccessState extends EventVideosState {
  final EventVideosModel eventVideosModel;
  const EventVideosSuccessState(this.eventVideosModel);
}

class EventVideosErrorState extends EventVideosState {
  const EventVideosErrorState();
}
