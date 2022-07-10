import 'package:buddyscripts/controller/chat/state/conversation_group_people_search_state.dart';
import 'package:buddyscripts/models/chats/conversation_group_people_search_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conversationGroupPeopleSearchResultProvider =
    StateNotifierProvider<ConversationGroupPeopleSearchController, ConversationGroupPeopleSearchState>(
  (ref) => ConversationGroupPeopleSearchController(),
);

class ConversationGroupPeopleSearchController extends StateNotifier<ConversationGroupPeopleSearchState> {
  ConversationGroupPeopleSearchController() : super(const ConversationGroupPeopleSearchInitialState());

  ConversationGroupPeopleSearchModel? conversations;

  reset() {
    state = ConversationGroupPeopleSearchSuccessState(ConversationGroupPeopleSearchModel(group: [], people: []));
  }

  Future groupPeopleSearchConversation(str) async {
    state = const ConversationGroupPeopleSearchLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.conversationGroupPeopleSearch(str)),
      );
      if (responseBody != null) {
        conversations = ConversationGroupPeopleSearchModel.fromJson(responseBody);
        state = ConversationGroupPeopleSearchSuccessState(conversations);
      } else {
        state = const ConversationGroupPeopleSearchErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const ConversationGroupPeopleSearchErrorState();
    }
  }
}
