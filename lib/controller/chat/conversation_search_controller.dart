import 'package:buddyscripts/models/chats/conversation_search_result_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/conversation_search_state.dart';

final conversationSearchResultProvider = StateNotifierProvider<ConversationSearchController,ConversationSearchState>(
  (ref) => ConversationSearchController(),
);

class ConversationSearchController extends StateNotifier<ConversationSearchState> {
  ConversationSearchController() : super(const ConversationSearchInitialState());

  List<ConversationSearchResultModel> conversations = [];


  refresh(List<ConversationSearchResultModel> conversationsInstance){
  state = ConversationSearchSuccessState(conversationsInstance);
  }

  Future searchConversation(str) async {
    state = const ConversationSearchLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.conversationSearch(str)),
      );
      if (responseBody != null) {
        conversations = (responseBody as List<dynamic>).map((e) => ConversationSearchResultModel.fromJson(e)).toList();
        state = ConversationSearchSuccessState(conversations);
      } else {
        state = const ConversationSearchErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const ConversationSearchErrorState();
    }
  }
  Future searchForGroupMember({required str,required inboxId}) async {
    state = const ConversationSearchLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.searchForGroupMember(str: str,id: inboxId)),
      );
      if (responseBody != null) {
        conversations = (responseBody as List<dynamic>).map((e) => ConversationSearchResultModel.fromJson(e)).toList();
        state = ConversationSearchSuccessState(conversations);
      } else {
        state = const ConversationSearchErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const ConversationSearchErrorState();
    }
  }

    Future memberSearchForCreateGroupChat() async {
    state = const ConversationSearchLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.memberSearchForCreateGroupChat),
      );
      if (responseBody != null) {
        conversations = (responseBody as List<dynamic>).map((e) => ConversationSearchResultModel.fromJson(e)).toList();
        state = ConversationSearchSuccessState(conversations);
      } else {
        state = const ConversationSearchErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const ConversationSearchErrorState();
    }
  }
}
