import 'package:buddyscripts/models/group/group_about_model.dart';

abstract class GroupAboutState {
  const GroupAboutState();
}

class GroupAboutInitialState extends GroupAboutState {
  const GroupAboutInitialState();
}

class GroupAboutLoadingState extends GroupAboutState {
  const GroupAboutLoadingState();
}

class GroupAboutSuccessState extends GroupAboutState {
  final GroupAboutModel groupAboutModel;
  const GroupAboutSuccessState(this.groupAboutModel);
}

class GroupAboutErrorState extends GroupAboutState {
  const GroupAboutErrorState();
}
