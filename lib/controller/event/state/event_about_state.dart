import 'package:buddyscripts/models/event/event_about_model.dart';

abstract class EventAboutState {
  const EventAboutState();
}

class EventAboutInitialState extends EventAboutState {
  const EventAboutInitialState();
}

class EventAboutLoadingState extends EventAboutState {
  const EventAboutLoadingState();
}

class EventAboutSuccessState extends EventAboutState {
  final EventAboutModel eventAboutModel;
  const EventAboutSuccessState(this.eventAboutModel);
}

class EventAboutErrorState extends EventAboutState {
  const EventAboutErrorState();
}
