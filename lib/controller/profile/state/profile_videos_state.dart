import 'package:buddyscripts/models/profile/profile_videos_model.dart';

abstract class ProfileVideosState {
  const ProfileVideosState();
}

class ProfileVideosInitialState extends ProfileVideosState {
  const ProfileVideosInitialState();
}

class ProfileVideosLoadingState extends ProfileVideosState {
  const ProfileVideosLoadingState();
}

class ProfileVideosSuccessState extends ProfileVideosState {
  final ProfileVideosModel profileVideosModel;
  const ProfileVideosSuccessState(this.profileVideosModel);
}

class ProfileVideosErrorState extends ProfileVideosState {
  const ProfileVideosErrorState();
}
