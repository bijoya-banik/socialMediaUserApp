import 'package:buddyscripts/models/feed/feed_model.dart';

abstract class WorldFeedState {
  const WorldFeedState();
}

class WorldFeedInitialState extends WorldFeedState {
  const WorldFeedInitialState();
}

class WorldFeedLoadingState extends WorldFeedState {
  const WorldFeedLoadingState();
}

class WorldFeedSuccessState extends WorldFeedState {
  final List<FeedModel> feedModel;
  const WorldFeedSuccessState(this.feedModel);
}

class WorldFeedErrorState extends WorldFeedState {
  const WorldFeedErrorState();
}
