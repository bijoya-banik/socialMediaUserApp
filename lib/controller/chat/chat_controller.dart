// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/chat/conversations_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/link_preview_controller.dart';
import 'package:buddyscripts/models/chats/chat_model.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/models/feed/feed_model.dart' as feed;
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/services/socket_service.dart';
import 'package:buddyscripts/views/screens/messages/components/reply_widget_card.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import 'state/chat_state.dart';

final chatProvider = StateNotifierProvider<ChatController, ChatState>(
  (ref) => ChatController(ref: ref),
);

class ChatController extends StateNotifier<ChatState> {
  final Ref? ref;

  ChatController({this.ref}) : super(const ChatInitialState());

  List<FileElement>? successFile = [];
  List? statusShareUserIdList = [];
  String? msgController;

  ChatModel? chatModel;
  int? moreChatInstanceLength = 1;
  int? chatLength = 0;
  int? buddyId;
  int? lastId;
  bool? isTyping = false;

  //String online="";

  resetmoreChatInstanceLength() {
    moreChatInstanceLength = 1;
  }

  resetBuddyId() {
    buddyId = null;
  }

  resetBuddyOnline() {
    chatModel?.onlineChat = "";
    state = ChatSuccessState(chatModel!);
  }

  updateBuddyOnline(onlineInstance) {
    chatModel?.onlineChat = onlineInstance;
    state = ChatSuccessState(chatModel!);
  }

  seenUpdate() {
    int? buddyIndex = chatModel?.chatLists?.indexWhere(((element) => element.userId == buddyId));

    if (buddyIndex != -1) {
      if (chatModel?.seen == 1) {
        for (var d in chatModel!.chatLists!) {
          d.isSeen = 1;
        }
      } else {
        for (int i = 0; i < buddyIndex!; i++) {
          chatModel?.chatLists![i].isSeen = 0;
        }

        for (int i = buddyIndex; i < chatModel!.chatLists!.length; i++) {
          chatModel!.chatLists![i].isSeen = 1;
        }
      }
    } else {
      for (int i = 0; i < chatModel!.chatLists!.length; i++) {
        if (chatModel?.seen == 0) {
          chatModel!.chatLists![i].isSeen = 0;
        } else {
          chatModel!.chatLists![i].isSeen = 1;
        }
      }
    }
  }

  Future fetchChat({required id, required group, onlineChat, more}) async {
    moreChatInstanceLength = 1;
    chatLength = 0;
    //  this.buddyId = buddyId;
    state = const ChatLoadingState();
    dynamic responseBody;
    var requestBody = {
      if (group == 0) 'buddy_id': id,
      if (group == 1) 'inbox_id': id,
      'more': more,
    };
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.chat, requestBody),
      );
      if (responseBody != null) {
        chatModel = ChatModel.fromJson(responseBody);

        SocketService().msgSeen(buddyId);
        onlineChat ??= "";
        chatModel?.onlineChat = onlineChat;
        seenUpdate();

        final List<ConversationsModel> conList = ref!.read(conversationsProvider.notifier).conversations!;

        dynamic index;
        if (group == 0) index = conList.indexWhere((element) => element.buddyId == id);
        if (group == 1) index = conList.indexWhere((element) => element.id == id);
        if(index!=-1){
 if (conList[index].isSeen == 0) {
          ref!.read(userProvider.notifier).decreaseMessageCount();
        }
          conList[index].isSeen = 1;
        }
       

      

        // for (var element in conList) {
        //   element.isSeen = 1;
        //   }
        ref!.read(conversationsProvider.notifier).refreshState();
        chatLength = chatModel?.chatLists!.length;
        state = ChatSuccessState(chatModel!);
      } else {
        state = const ChatErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const ChatErrorState();
    }
  }

  Future fetchMoreChat() async {
    moreChatInstanceLength = -1;
    lastId = chatModel?.chatLists?.last.id;
    dynamic responseBody;
    var requestBody = {
      'buddy_id': buddyId,
      'more': lastId,
    };
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.chat, requestBody),
      );
      if (responseBody != null) {
        ChatModel _chatModel = ChatModel.fromJson(responseBody);
        moreChatInstanceLength = _chatModel.chatLists?.length;
        if (_chatModel.chatLists!.isNotEmpty) {
          lastId = _chatModel.chatLists!.last.id;
          chatModel!.chatLists?.addAll(_chatModel.chatLists!);
          seenUpdate();
        }
        chatLength = chatModel?.chatLists!.length;
        state = ChatSuccessState(chatModel!);
      } else {
        state = const ChatErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const ChatErrorState();
    }
  }

  refreshState() {
    state = ChatSuccessState(chatModel!);
  }

  Future uploadMedia(
    buddyId,
    inboxId,
    files,
    Message replyMessage,
    //msg
  ) async {
    successFile?.clear();
    print("successFile.length");
    print(successFile?.length);
    //state = ChatLoadingState();
    dynamic responseBody;
    Map<String, String> requestBody = {
      'uploadType': ref!.read(assetManagerProvider).isVideoSelected
          ? 'video'
          : ref!.read(assetManagerProvider).isDocumentSelected
              ? 'application'
              : 'image'
    };

    /// Upload media and take the response stringify it and
    /// send it using sendMessage() function.
    try {
      ref!.read(assetManagerProvider).updateMediaUploadFlag(true);
      responseBody = await Network.handleResponse(
        await Network.multiPartRequest(API.mediaUpload, "POST", body: requestBody, files: files, filedName: 'images'),
      );
      if (responseBody != null) {
        ref!.read(assetManagerProvider).updateMediaUploadFlag(false);

        if (responseBody.isNotEmpty) {
          responseBody.forEach((response) {
            successFile?.add(FileElement(
              fileLoc: response["fileLoc"],
              originalName: response["originalName"],
              extname: response["extname"],
              size: response["size"],
              type: response["type"],
              isLocal: false,
            ));
          });
        }
        sendMessage(
          "Attachment",
          buddyId,
          inboxId,
          replyMessage,
          files: jsonEncode(responseBody),
        );
      } else {
        ref!.read(assetManagerProvider).updateMediaUploadFlag(false);
        state = const ChatErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      ref!.read(assetManagerProvider).updateMediaUploadFlag(false);
      state = const ChatErrorState();
    }
  }

  Future sendMessage(
    msg,
    buddyId,
    inboxId,
    Message? replyMessage, {
    replyFiles,
    files,
    feed.FeedModel? feed,
    FeedType? feedType,
  }) async {
    print("msggggggggggggg");
    print(msg);
    //state = ChatLoadingState();
    dynamic responseBody;

    if (feed == null) {
      RegExp regExp = RegExp(r'(?:(?:https?|ftp|www):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
      if (regExp.hasMatch(msg) && msg.length > 0) {
        await ref!.read(linkPreviewProvider.notifier).getLinkPreview(msg);
      } else {
        ref!.read(linkPreviewProvider.notifier).updateState();
      }
    }

    dynamic linkData;

    var name = "";
    if (feed != null) {
      if (feedType == FeedType.GROUP || feedType == FeedType.EVENT) {
        String firstName = feed.user?.firstName ?? "";
        String lastName = feed.user?.lastName ?? "";
        name = firstName + lastName;
      } else {
        name = feed.name!;
      }

      if (msg != "") {
        msg = msgController;
      }
    } else {
      if (ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel != null) {
        linkData = {
          "title": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.title,
          "url": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.url,
          "image": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.image,
          "description": ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel?.description
        };
      } else {
        linkData = null;
      }
    }

    var requestBody = {
      'msg': msg,
      'buddy_id': buddyId,
      'inbox_id': inboxId,
      'files': files,
      "meta_data": {
        "link_meta": linkData,
        "feed_meta": feed == null
            ? null
            : {
                "id": feed.id,
                "title": name,
                "desc": feed.feedTxt,
                "fileLoc": feed.files!.isNotEmpty ? feed.files![0].fileLoc : feed.user?.profilePic,
                "type": feed.files!.isNotEmpty ? feed.files![0].type : "image",
                "link_meta": feed.metaData?.linkMeta,
              }
      },
      if (replyMessage != null) 'reply_id': replyMessage.id,
      if (replyMessage != null) 'reply_msg': replyMessage.message,
    };

    // await Future.delayed(Duration(seconds: 3));

    // /// Need to show message instantly in the chat
    // /// like whatsapp. So gotta find a way to properly
    // /// add messages in the list without duplication.

    // chatModel.chatLists.insert(
    //   0,
    //   ChatList(
    //       id: -1,
    //       msg: msg,
    //       userId: getIntAsync(USER_ID),
    //       files: successFile,
    //       createdAt: DateTime.now(),
    //       updatedAt: DateTime.now(),
    //       isDeleted: 0,
    //       isSeen: 0),
    // );
    // state = ChatSuccessState(chatModel);

    int conversationIndex;
    if (buddyId == null) {
      conversationIndex = ref!.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.id == inboxId);
    } else {
      conversationIndex = ref!.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.buddyId == buddyId);
    }

    print("buddy id");
    print(buddyId);
    print(conversationIndex);

    /// Update last message
    ///

    if (conversationIndex != -1) {
      ref!.read(conversationsProvider.notifier).conversations![conversationIndex].lastmsg = Lastmsg(
        id: -1,
        msg: msg,
        userId: getIntAsync(USER_ID),
        files: successFile,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: 0,
      );
      ref!.read(conversationsProvider.notifier).conversations![conversationIndex].updatedAt = DateTime.now();
      var temp = ref!.read(conversationsProvider.notifier).conversations![conversationIndex];
      ref!.read(conversationsProvider.notifier).conversations!.removeAt(conversationIndex);
      ref!.read(conversationsProvider.notifier).conversations!.insert(0, temp);
      ref!.read(conversationsProvider.notifier).refreshState();
    } else {
      await ref!.read(conversationsProvider.notifier).fetchConversations();
    }

    /// Update chat list conversation order based on latest incoming message

    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.sendMessage, requestBody),
      );
      if (responseBody != null) {
        linkData = null;
        ref!.read(linkPreviewProvider.notifier).linkPreviewModelModel = null;

        statusShareUserIdList!.add(buddyId ?? inboxId);

        // if (buddyId == null) {
        //   statusShareUserIdList!.add(inboxId);
        // } else {
        //   statusShareUserIdList!.add(buddyId);
        // }

        print(statusShareUserIdList);

        ChatList chatList = ChatList.fromJson(responseBody);
        if (feed != null) {
          toast("Sent suceessfully", bgColor: KColor.green);
        } else {
          chatModel?.chatLists!.removeWhere((element) => element.id == -1);
          successFile?.clear();
          chatModel?.chatLists!.insert(0, chatList);
        }

        var conversationIndex = ref!.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.buddyId == buddyId);

        print('conversationIndex');
        print(conversationIndex);

        if (conversationIndex != -1) {
          ref!.read(conversationsProvider.notifier).conversations![conversationIndex].lastmsg = Lastmsg(
            id: chatList.id,
            msg: msg,
            userId: getIntAsync(USER_ID),
            files: successFile,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isDeleted: 0,
          );
          ref!.read(conversationsProvider.notifier).conversations![conversationIndex].updatedAt = DateTime.now();

          /// Update chat list conversation order based on latest incoming message
          var temp = ref!.read(conversationsProvider.notifier).conversations![conversationIndex];
          ref!.read(conversationsProvider.notifier).conversations!.removeAt(conversationIndex);
          ref!.read(conversationsProvider.notifier).conversations!.insert(0, temp);
          ref!.read(conversationsProvider.notifier).refreshState();
        } else {
          ref!.read(conversationsProvider.notifier).fetchConversations();
        }

        state = ChatSuccessState(chatModel ?? ChatModel());
      } else {
        state = const ChatErrorState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      state = const ChatErrorState();
    }
  }

  insertNewIncomingChat(newChat) {
    print("insertNewIncomingChat()");
    try {
      ChatList chatList = ChatList.fromJson(newChat);

      print(chatList.userId);
      print(chatList.msg);

      print(chatList.isSeen);
      if (buddyId == chatList.userId) {
        print(chatModel?.chatLists!.length);
        chatModel?.chatLists!.insert(0, chatList);
        print(chatModel?.chatLists!.length);

        for (int i = 0; i < chatModel!.chatLists!.length; i++) {
          chatModel?.chatLists![i].isSeen = 1;
        }

        state = ChatSuccessState(chatModel!);
      } else {
        ref!.read(userProvider.notifier).userData?.msgCount?.totalUnseen == (ref!.read(userProvider.notifier).userData?.msgCount?.totalUnseen)! + 1;
        ref!.read(userProvider.notifier).refreshState();
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      // state = ChatErrorState();
    }
  }

  Future deleteChatMessage(chatId, {isGroup = false, inboxId}) async {
    dynamic responseBody;
    var requestBody = {
      'chat_id': chatId,
      'buddy_id': isGroup ? -1 : buddyId,
      'inbox_id': isGroup ? inboxId : -1,
      'user_id': getIntAsync(USER_ID),
    };

    /// Remove the message instantly

    chatModel?.chatLists!.removeWhere((chat) => chat.id == chatId);
    // dynamic chatIndex = chatModel?.chatLists!.indexWhere((chat) => chat.id == chatId);
    // chatModel?.chatLists!.removeAt(chatIndex);
    state = ChatSuccessState(chatModel!);

    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.deleteMessage, requestBody),
      );
      if (responseBody != null) {
        final List<ConversationsModel> conList = ref!.read(conversationsProvider.notifier).conversations!;
        print("conversation");
        print(conList.length);
        dynamic index;
        if (!isGroup) index = conList.indexWhere((element) => element.buddyId == buddyId);
        if (isGroup) index = conList.indexWhere((element) => element.id == inboxId);

        print("indexxxxxxxxxxxxxxxxxx");
        print(index);

        print("chatModel!.chatLists!.length");
        print(chatModel!.chatLists!.length);

        conList[index].lastmsg = Lastmsg(
          msg: chatModel!.chatLists![0].msg,
          id: chatModel!.chatLists![0].id,
          userId: chatModel!.chatLists![0].userId,
          inboxKey: chatModel!.chatLists![0].inboxKey,
          files: chatModel!.chatLists![0].files,
          isDeleted: chatModel!.chatLists![0].isDeleted,
          createdAt: chatModel!.chatLists![0].createdAt,
          updatedAt: chatModel!.chatLists![0].updatedAt,
        );

        ref!.read(conversationsProvider.notifier).updateState(conList);
      } else {
        // state = ChatErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      // state = ChatErrorState();
    }
  }
}
