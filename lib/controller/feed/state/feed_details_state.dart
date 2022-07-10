import 'package:buddyscripts/models/feed/feed_model.dart';

abstract class FeedDetailsState {
  const FeedDetailsState();
}

class FeedDetailsInitialState extends FeedDetailsState {
  const FeedDetailsInitialState();
}

class FeedDetailsLoadingState extends FeedDetailsState {
  const FeedDetailsLoadingState();
}

class FeedDetailsSuccessState extends FeedDetailsState {
  final FeedModel feedModel;
  const FeedDetailsSuccessState(this.feedModel);
}

class FeedDetailsErrorState extends FeedDetailsState {
  const FeedDetailsErrorState();
}
