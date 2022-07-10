abstract class GroupState {
  const GroupState();
}

class GroupInitialState extends GroupState {
  const GroupInitialState();
}

class GroupLoadingState extends GroupState {
  const GroupLoadingState();
}

class GroupErrorState extends GroupState {
  const GroupErrorState();
}

/// Create Group

class CreateGroupSuccessState extends GroupState {
  const CreateGroupSuccessState();
}

class CreateGroupErrorState extends GroupState {
  const CreateGroupErrorState();
}

/// Edit Group

class EditGroupSuccessState extends GroupState {
  const EditGroupSuccessState();
}

class EditGroupErrorState extends GroupState {
  const EditGroupErrorState();
}

/// Delete Group

class DeleteGroupSuccessState extends GroupState {
  const DeleteGroupSuccessState();
}

class DeleteGroupErrorState extends GroupState {
  const DeleteGroupErrorState();
}

/// leave Group

class LeaveGroupSuccessState extends GroupState {
  const LeaveGroupSuccessState();
}

class LeaveGroupErrorState extends GroupState {
  const LeaveGroupErrorState();
}

/// join Group

class JoinGroupSuccessState extends GroupState {
  const JoinGroupSuccessState();
}

class JoinGroupErrorState extends GroupState {
  const JoinGroupErrorState();
}
