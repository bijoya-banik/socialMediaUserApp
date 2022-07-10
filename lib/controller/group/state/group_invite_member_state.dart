

import 'package:buddyscripts/models/group/group_invite_member_model.dart';

abstract class GroupInviteMemberState {
  const GroupInviteMemberState();
}

class GroupInviteMemberInitialState extends GroupInviteMemberState {
  const GroupInviteMemberInitialState();
}

class GroupInviteMemberLoadingState extends GroupInviteMemberState {
  const GroupInviteMemberLoadingState();
}

class GroupInviteMemberSuccessState extends GroupInviteMemberState {
   final List<GroupInviteMemberModel> groupinviteMemberModel;
  const GroupInviteMemberSuccessState(this.groupinviteMemberModel);
}

class GroupInviteMemberSearchResultSuccessState extends GroupInviteMemberState {
  final List<GroupInviteMemberModel> groupinviteMemberSearchResultModel;
  const GroupInviteMemberSearchResultSuccessState(this.groupinviteMemberSearchResultModel);
}

class GroupInviteMemberErrorState extends GroupInviteMemberState {
  const GroupInviteMemberErrorState();
}
