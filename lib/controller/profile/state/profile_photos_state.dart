import 'package:buddyscripts/models/profile/profile_photos_model.dart';

abstract class ProfilePhotosState {
  const ProfilePhotosState();
}

class ProfilePhotosInitialState extends ProfilePhotosState {
  const ProfilePhotosInitialState();
}

class ProfilePhotosLoadingState extends ProfilePhotosState {
  const ProfilePhotosLoadingState();
}

class ProfilePhotosSuccessState extends ProfilePhotosState {
  final ProfilePhotosModel profilePhotosModel;
  const ProfilePhotosSuccessState(this.profilePhotosModel);
}

class ProfilePhotosErrorState extends ProfilePhotosState {
  const ProfilePhotosErrorState();
}
