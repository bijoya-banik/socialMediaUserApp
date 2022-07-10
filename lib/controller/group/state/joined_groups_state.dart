import 'package:buddyscripts/models/group/groups_model.dart';

abstract class JoinedGroupsState {
  const JoinedGroupsState();
}

class JoinedGroupsInitialState extends JoinedGroupsState {
  const JoinedGroupsInitialState();
}

class JoinedGroupsLoadingState extends JoinedGroupsState {
  const JoinedGroupsLoadingState();
}

class JoinedGroupsSuccessState extends JoinedGroupsState {
  final GroupsModel groupsModel;
  const JoinedGroupsSuccessState(this.groupsModel);
}

class JoinedGroupsErrorState extends JoinedGroupsState {
  const JoinedGroupsErrorState();
}
