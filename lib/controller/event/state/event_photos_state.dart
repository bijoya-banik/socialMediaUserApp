import 'package:buddyscripts/models/event/event_photos_model.dart';

abstract class EventPhotosState {
  const EventPhotosState();
}

class EventPhotosInitialState extends EventPhotosState {
  const EventPhotosInitialState();
}

class EventPhotosLoadingState extends EventPhotosState {
  const EventPhotosLoadingState();
}

class EventPhotosSuccessState extends EventPhotosState {
  final EventPhotosModel eventPhotosModel;
  const EventPhotosSuccessState(this.eventPhotosModel);
}

class EventPhotosErrorState extends EventPhotosState {
  const EventPhotosErrorState();
}
