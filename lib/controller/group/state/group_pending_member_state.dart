

import 'package:buddyscripts/models/group/group_pending_member_model.dart';

abstract class GroupPendingMemberState {
  const GroupPendingMemberState();
}

class GroupPendingMemberInitialState extends GroupPendingMemberState {
  const GroupPendingMemberInitialState();
}

class GroupPendingMemberLoadingState extends GroupPendingMemberState {
  const GroupPendingMemberLoadingState();
}

class GroupPendingMemberSuccessState extends GroupPendingMemberState {
  final List<GroupPendingMemberModel> groupPendingMemberModel;
  const GroupPendingMemberSuccessState(this.groupPendingMemberModel);
}

class GroupPendingMemberErrorState extends GroupPendingMemberState {
  const GroupPendingMemberErrorState();
}
