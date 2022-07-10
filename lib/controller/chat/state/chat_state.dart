import 'package:buddyscripts/models/chats/chat_model.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitialState extends ChatState {
  const ChatInitialState();
}

class ChatLoadingState extends ChatState {
  const ChatLoadingState();
}


class ChatSuccessState extends ChatState {
  final ChatModel chat;
  const ChatSuccessState(this.chat);
}

class ChatErrorState extends ChatState {
  const ChatErrorState();
}
