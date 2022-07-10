import 'package:buddyscripts/models/group_chat/group_chat_members_model.dart';

abstract class GroupChatMemberState {
  const GroupChatMemberState();
}

class GroupChatMemberInitialState extends GroupChatMemberState {
  const GroupChatMemberInitialState();
}
  
class GroupChatMemberLoadingState extends GroupChatMemberState {
  const GroupChatMemberLoadingState();
}

class GroupChatMemberSuccessState extends GroupChatMemberState {
  final List<GroupChatMemberModel> groupChatAllMemberModel;
  const GroupChatMemberSuccessState(this.groupChatAllMemberModel);
}

class GroupChatMemberErrorState extends GroupChatMemberState {
  const GroupChatMemberErrorState();
}
