import 'package:buddyscripts/models/feed/feed_model.dart';

abstract class PersonalFeedState {
  const PersonalFeedState();
}

class PersonalFeedInitialState extends PersonalFeedState {
  const PersonalFeedInitialState();
}

class PersonalFeedLoadingState extends PersonalFeedState {
  const PersonalFeedLoadingState();
}

class PersonalFeedSuccessState extends PersonalFeedState {
  final List<FeedModel> feedModel;
  const PersonalFeedSuccessState(this.feedModel);
}

class PersonalFeedErrorState extends PersonalFeedState {
  const PersonalFeedErrorState();
}
