

abstract class GroupChatState {
  const GroupChatState();
}

class GroupChatInitialState extends GroupChatState {
  const GroupChatInitialState();
}

class GroupChatLoadingState extends GroupChatState {
  const GroupChatLoadingState();
}


// class GroupChatSuccessState extends GroupChatState {
//   final GroupChatModel Groupchat;
//   const GroupChatSuccessState(this.Groupchat);
// }

class GroupChatErrorState extends GroupChatState {
  const GroupChatErrorState();
}
