import 'package:buddyscripts/models/chats/conversation_search_result_model.dart';

abstract class ConversationSearchState {
  const ConversationSearchState();
}

class ConversationSearchInitialState extends ConversationSearchState {
  const ConversationSearchInitialState();
}

class ConversationSearchLoadingState extends ConversationSearchState {
  const ConversationSearchLoadingState();
}

class ConversationSearchSuccessState extends ConversationSearchState {
  final List<ConversationSearchResultModel> conversations;
  const ConversationSearchSuccessState(this.conversations);
}

class ConversationSearchErrorState extends ConversationSearchState {
  const ConversationSearchErrorState();
}