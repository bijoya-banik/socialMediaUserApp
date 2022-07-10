import 'package:buddyscripts/models/feed/feed_reacted_users_model.dart';

abstract class FeedReactedUsersState {
  const FeedReactedUsersState();
}

class FeedReactedUsersInitialState extends FeedReactedUsersState {
  const FeedReactedUsersInitialState();
}

class FeedReactedUsersLoadingState extends FeedReactedUsersState {
  const FeedReactedUsersLoadingState();
}

class FeedReactedUsersSuccessState extends FeedReactedUsersState {
  final List<FeedReactedUsersModel> feedReactedUsersModel;
  const FeedReactedUsersSuccessState(this.feedReactedUsersModel);
}

class FeedReactedUsersErrorState extends FeedReactedUsersState {
  const FeedReactedUsersErrorState();
}
