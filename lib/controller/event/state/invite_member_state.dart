import 'package:buddyscripts/models/event/invite/invite_member_model.dart';
import 'package:buddyscripts/models/event/invite/search_result_model.dart';

abstract class InviteMemberState {
  const InviteMemberState();
}

class InviteMemberInitialState extends InviteMemberState {
  const InviteMemberInitialState();
}

class InviteMemberLoadingState extends InviteMemberState {
  const InviteMemberLoadingState();
}

class InviteMemberSuccessState extends InviteMemberState {
  final InviteMemberModel inviteMemberModel;
  const InviteMemberSuccessState(this.inviteMemberModel);
}

class InviteMemberSearchResultSuccessState extends InviteMemberState {
  final List<InviteMemberSearchResultModel> inviteMemberSearchResultModel;
  const InviteMemberSearchResultSuccessState(this.inviteMemberSearchResultModel);
}

class InviteMemberErrorState extends InviteMemberState {
  const InviteMemberErrorState();
}
