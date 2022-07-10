import 'package:buddyscripts/models/chats/conversations_model.dart';

abstract class ConversationsState {
  const ConversationsState();
}

class ConversationsInitialState extends ConversationsState {
  const ConversationsInitialState();
}

class ConversationsLoadingState extends ConversationsState {
  const ConversationsLoadingState();
}

class ConversationsSuccessState extends ConversationsState {
  final List<ConversationsModel> conversations;
  const ConversationsSuccessState(this.conversations);
}

class ConversationsErrorState extends ConversationsState {
  const ConversationsErrorState();
}
