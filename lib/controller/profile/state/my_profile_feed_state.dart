import 'package:buddyscripts/models/profile/profile_feed_model.dart';

abstract class MyProfileFeedState {
  const MyProfileFeedState();
}

class MyProfileFeedInitialState extends MyProfileFeedState {
  const MyProfileFeedInitialState();
}

class MyProfileFeedLoadingState extends MyProfileFeedState {
  const MyProfileFeedLoadingState();
}

class MyProfileFeedSuccessState extends MyProfileFeedState {
  final ProfileFeedModel profileFeedModel;
  const MyProfileFeedSuccessState(this.profileFeedModel);
}

class MyProfileFeedErrorState extends MyProfileFeedState {
  const MyProfileFeedErrorState();
}
