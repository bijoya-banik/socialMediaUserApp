import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/controller/chat/conversations_controller.dart';
import 'package:buddyscripts/controller/chat/state/group_chat_state.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/screens/messages/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupChatProvider = StateNotifierProvider<GroupChatController, GroupChatState>(
  (ref) => GroupChatController(ref: ref),
);

class GroupChatController extends StateNotifier<GroupChatState> {
  final Ref? ref;

  String? groupChatNameUpdated;

  GroupChatController({this.ref}) : super(const GroupChatInitialState());

  Future createGroupChat({required groupChatName, required userIdList}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'group_name': groupChatName, 'member_list': userIdList};
    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.createGroupChat, requestBody));

      ConversationsModel conversation = ConversationsModel.fromJson(responseBody[0]);

      List<ConversationsModel>? conversationList = ref!.read(conversationsProvider.notifier).conversations;
      if (conversationList!.isNotEmpty) {
        conversationList.insert(0, conversation);
        ref!.read(conversationsProvider.notifier).refreshState();
      }
      NavigationService.popNavigate();
      NavigationService.popNavigate();
      ref!.read(chatProvider.notifier).fetchChat(
          id: conversation.isGroup == 1 ? conversation.id : conversation.buddyId,
          group: conversation.isGroup,
          onlineChat: conversation.buddy?.isOnline);
      NavigationService.navigateToReplacement(CupertinoPageRoute(
          builder: (context) => ChatScreen(
              id: conversation.id,
              firstName: conversation.groupName,
              lastName: "",
              profilePic: conversation.groupLogo,
              userName: "",
              isOnline: conversation.memberName,
              conversation: conversation)));
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future updateGroupChatName({required groupChatName, required inboxId}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'group_name': groupChatName, 'inbox_id': inboxId};
    try {
   
        responseBody = await Network.handleResponse(await Network.postRequest(API.updateGroupChatInfo, requestBody));
           if (responseBody != null) {
        List<ConversationsModel>? conversationList = ref!.read(conversationsProvider.notifier).conversations;
        var conversationIndex = ref!.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.id == inboxId);
        if (conversationList!.isNotEmpty) {
          conversationList[conversationIndex].groupName = groupChatName;
          ref!.read(conversationsProvider.notifier).refreshState();
        }
        groupChatNameUpdated = groupChatName;
          NavigationService.popNavigate();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future updateGroupChatPhoto({required image, required groupChatName, required inboxId}) async {
    dynamic responseBody;

    Map<String, String> requestBody = {'group_name': groupChatName, 'inbox_id': inboxId.toString()};
    try {
      KDialog.kShowDialog(
        NavigationService.navigatorKey.currentContext,
        const ProcessingDialogContent("Uploading..."),
        barrierDismissible: false,
      );
      responseBody = await Network.handleResponse(
        await Network.multiPartRequest(API.updateGroupChatInfo, 'POST', body: requestBody, files: image, filedName: 'file'),
      );
      if (responseBody != null) {
        int index;
        index = ref!.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.id == inboxId);

        if (index != -1) {
          ref!.read(conversationsProvider.notifier).conversations![index].groupLogo = responseBody['group_logo'];
          ref!.read(conversationsProvider.notifier).refreshState();
        }
        NavigationService.popNavigate();
        return responseBody['group_logo'];
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future leaveGroupChat({required inboxId}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'inbox_id': inboxId};
    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.leaveChatGroup, requestBody));

      int index;
      index = ref!.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.id == inboxId);

      if (index != -1) {
        ref!.read(conversationsProvider.notifier).conversations!.removeAt(index);
        ref!.read(conversationsProvider.notifier).refreshState();
      }

      NavigationService.popNavigate();
      NavigationService.popNavigate();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future muteGroupChat({required inboxId}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'inbox_id': inboxId};
    try {
      KDialog.kShowDialog(
        NavigationService.navigatorKey.currentContext,
        const ProcessingDialogContent("Processing..."),
        barrierDismissible: false,
      );
      responseBody = await Network.handleResponse(await Network.postRequest(API.muteChat, requestBody));
      if (responseBody != null) {
        int index;
        index = ref!.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.id == inboxId);

        if (index != -1) {
          ref!.read(conversationsProvider.notifier).conversations![index].isGroupMember?.muteNoti = 1;
          ref!.read(conversationsProvider.notifier).refreshState();
        }
        NavigationService.popNavigate();
        return 1;
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future unmuteGroupChat({required inboxId}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'inbox_id': inboxId};
    try {
      KDialog.kShowDialog(
        NavigationService.navigatorKey.currentContext,
        const ProcessingDialogContent("Processing..."),
        barrierDismissible: false,
      );
      responseBody = await Network.handleResponse(await Network.postRequest(API.unmuteChat, requestBody));
      if (responseBody != null) {
        int index;
        index = ref!.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.id == inboxId);

        if (index != -1) {
          ref!.read(conversationsProvider.notifier).conversations![index].isGroupMember?.muteNoti = 0;
          ref!.read(conversationsProvider.notifier).refreshState();
        }
        NavigationService.popNavigate();
        return 0;
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  Future deleteChatGroup({required inboxId}) async {
    // ignore: unused_local_variable
    dynamic responseBody;
    var requestBody = {'inbox_id': inboxId};
    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.deleteChatGroup, requestBody));

      int index;
      index = ref!.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.id == inboxId);

      if (index != -1) {
        ref!.read(conversationsProvider.notifier).conversations!.removeAt(index);
        ref!.read(conversationsProvider.notifier).refreshState();
      }

      NavigationService.popNavigate();
      NavigationService.popNavigate();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }
}
