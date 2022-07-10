import 'package:buddyscripts/models/profile/profile_feed_model.dart';

abstract class UserProfileFeedState {
  const UserProfileFeedState();
}

class UserProfileFeedInitialState extends UserProfileFeedState {
  const UserProfileFeedInitialState();
}

class UserProfileFeedLoadingState extends UserProfileFeedState {
  const UserProfileFeedLoadingState();
}

class UserProfileFeedSuccessState extends UserProfileFeedState {
  final ProfileFeedModel profileFeedModel;
  const UserProfileFeedSuccessState(this.profileFeedModel);
}

class UserProfileFeedErrorState extends UserProfileFeedState {
  const UserProfileFeedErrorState();
}
