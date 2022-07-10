import 'package:buddyscripts/models/group/groups_model.dart';

abstract class MyGroupsState {
  const MyGroupsState();
}

class MyGroupsInitialState extends MyGroupsState {
  const MyGroupsInitialState();
}

class MyGroupsLoadingState extends MyGroupsState {
  const MyGroupsLoadingState();
}

class MyGroupsSuccessState extends MyGroupsState {
  final GroupsModel groupsModel;
  const MyGroupsSuccessState(this.groupsModel);
}

class MyGroupsErrorState extends MyGroupsState {
  const MyGroupsErrorState();
}
