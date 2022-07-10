import 'package:buddyscripts/models/profile/profile_overview_model.dart';

abstract class ProfileAboutState {
  const ProfileAboutState();
}

class ProfileAboutInitialState extends ProfileAboutState {
  const ProfileAboutInitialState();
}

class ProfileAboutLoadingState extends ProfileAboutState {
  const ProfileAboutLoadingState();
}

class ProfileAboutSuccessState extends ProfileAboutState {
  final ProfileOverviewModel profileOverviewModel;
  const ProfileAboutSuccessState(this.profileOverviewModel);
}

class ProfileAboutErrorState extends ProfileAboutState {
  const ProfileAboutErrorState();
}
