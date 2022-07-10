import 'package:buddyscripts/models/group/groups_model.dart';

abstract class DiscoverGroupsState {
  const DiscoverGroupsState();
}

class DiscoverGroupsInitialState extends DiscoverGroupsState {
  const DiscoverGroupsInitialState();
}

class DiscoverGroupsLoadingState extends DiscoverGroupsState {
  const DiscoverGroupsLoadingState();
}

class DiscoverGroupsSuccessState extends DiscoverGroupsState {
  final GroupsModel groupsModel;
  const DiscoverGroupsSuccessState(this.groupsModel);
}

class DiscoverGroupsErrorState extends DiscoverGroupsState {
  const DiscoverGroupsErrorState();
}
