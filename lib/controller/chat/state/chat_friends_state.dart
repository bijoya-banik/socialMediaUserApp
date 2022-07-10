import 'package:buddyscripts/models/chats/chat_friends_model.dart';


abstract class ChatFriendsState {
  const ChatFriendsState();
}

class ChatFriendsInitialState extends ChatFriendsState {
  const ChatFriendsInitialState();
}

class ChatFriendsLoadingState extends ChatFriendsState {
  const ChatFriendsLoadingState();
}

class ChatFriendsSuccessState extends ChatFriendsState {
  final ChatFriendsModel chatFriendsModel;
  const ChatFriendsSuccessState(this.chatFriendsModel);
}

class ChatFriendsErrorState extends ChatFriendsState {
  const ChatFriendsErrorState();
}
