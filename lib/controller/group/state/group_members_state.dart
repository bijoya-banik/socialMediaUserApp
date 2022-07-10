import 'package:buddyscripts/models/group/group_members_model.dart';

abstract class GroupMembersState {
  const GroupMembersState();
}

class GroupMembersInitialState extends GroupMembersState {
  const GroupMembersInitialState();
}

class GroupMembersLoadingState extends GroupMembersState {
  const GroupMembersLoadingState();
}

class GroupMembersSuccessState extends GroupMembersState {
  final GroupMembersModel groupMembersModel;
  const GroupMembersSuccessState(this.groupMembersModel);
}

class GroupMembersErrorState extends GroupMembersState {
  const GroupMembersErrorState();
}
