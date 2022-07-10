import 'package:buddyscripts/models/chats/conversation_group_people_search_model.dart';

abstract class ConversationGroupPeopleSearchState {
  const ConversationGroupPeopleSearchState();
}

class ConversationGroupPeopleSearchInitialState extends ConversationGroupPeopleSearchState {
  const ConversationGroupPeopleSearchInitialState();
}

class ConversationGroupPeopleSearchLoadingState extends ConversationGroupPeopleSearchState {
  const ConversationGroupPeopleSearchLoadingState();
}

class ConversationGroupPeopleSearchSuccessState extends ConversationGroupPeopleSearchState {
  final ConversationGroupPeopleSearchModel? conversations;
  const ConversationGroupPeopleSearchSuccessState(this.conversations);
}

class ConversationGroupPeopleSearchErrorState extends ConversationGroupPeopleSearchState {
  const ConversationGroupPeopleSearchErrorState();
}