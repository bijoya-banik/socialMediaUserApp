
import 'package:buddyscripts/models/group_chat/group_chat_members_model.dart';

abstract class GroupChatAdminState {
  const GroupChatAdminState();
}

class GroupChatAdminInitialState extends GroupChatAdminState {
  const GroupChatAdminInitialState();
}
  
class GroupChatAdminLoadingState extends GroupChatAdminState {
  const GroupChatAdminLoadingState();
}

class GroupChatAdminSuccessState extends GroupChatAdminState {
  final List<GroupChatMemberModel> groupChatAdminModel;
  const GroupChatAdminSuccessState(this.groupChatAdminModel);
}

class GroupChatAdminErrorState extends GroupChatAdminState {
  const GroupChatAdminErrorState();
}
