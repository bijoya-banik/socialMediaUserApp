import 'dart:io';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/main.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/screens/call_agora/call_user_screen.dart';
import 'package:buddyscripts/views/screens/call_agora/call_user_model.dart';
import 'package:buddyscripts/views/screens/messages/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/controller/chat/chat_friends_controller.dart';
import 'package:buddyscripts/controller/chat/conversations_controller.dart';
import 'package:buddyscripts/controller/profile/my_profile_feed_controller.dart';
import 'package:buddyscripts/controller/search/search_controlller.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:nb_utils/nb_utils.dart';

// typedef void StreamStateCallback(MediaStream stream);

// final socketServiceProvider = StateNotifierProvider<SocketService, Type>((ref) {
//   return SocketService();
// });

class SocketService {
  //  Ref? context;

  //SocketService({this.context}) : super(Type);
  static final SocketService _socketService = SocketService._internal();

  factory SocketService() {
    return _socketService;
  }

  SocketService._internal();

  Socket? socket;
  // final player = AudioPlayer();

  bool isFirstConnect = true;

  /// To avoid listening to socket channel if already connected
  bool isFromLogin = false;

  /// To check if from login, which will mean socket channels not beign listened so we need to listen on connect

  /// Place holders
  //var context = NavigationService.navigatorKey.currentContext;

  /// Initialize Socket Connection
  initialize() {
    print("SOCKET: initialize()");
    // print('socket.connected = ${socket.connected}');
    socket = io(
        API.SOCKET_BASE,
        OptionBuilder()
            .setTransports(['websocket'])
            // .enableForceNewConnection() // necessary because otherwise it would reuse old connection // bad
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionDelay(500)
            .setReconnectionAttempts(10)
            .build());

    print('socket.connected = ${socket!.connected}');
    print("API.SOCKET_BASE: " '${API.SOCKET_BASE}');
    print('socket isFirstConnect = $isFirstConnect');
    socket!.onConnect((_) {
      print('SOCKET: CONNECTED');
      print('socket.connected = ${socket!.connected}');
      print('socket isFirstConnect = $isFirstConnect');
      print('socket isFromLogin = $isFromLogin');
      if (!isFirstConnect && !isFromLogin) return;
      if (getBoolAsync(LOGGED_IN)) {
        showOnline();
        incomingNotification();
        userOnlineStatus();
        handleAudioCall();
        handleVideoCall();
      }
    });
    socket!.onDisconnect((data) {
      print('SOCKET: DISCONNECTED');
      print(data);
      if (getBoolAsync(LOGGED_IN)) {
        tryReconnect(); // if at any point socket disconnects, and user is logged in try reconnecting
      }
    });

    socket!.onReconnect((data) {
      print('SOCKET: RECONNECTED');
      print(data);
    });
    socket!.onReconnectAttempt((data) {
      print('SOCKET: RECONNECT ATTEMPT');
      print(data);
    });
    socket!.onReconnectError((data) {
      print('SOCKET: RECONNECT ATTEMPT ERROR');
      print(data);
    });
    socket!.onConnectError((data) {
      print('SOCKET: CONNECT ERROR');
      print(data);
      tryReconnect();
    });
    socket!.onReconnecting((data) {
      print('SOCKET: RECONNECTING');
      print(data);
    });
    socket!.onError((data) {
      print('SOCKET: ERROR');
      print(data);
      tryReconnect();
    });
    socket!.onConnectTimeout((data) {
      print('SOCKET: CONNECT TIMEOUT');
      print(data);
      tryReconnect();
    });
    socket!.onConnecting((data) {
      print('SOCKET: CONNECTING');
      print(data);
    });
    socket!.onPing((data) {
      print('SOCKET: PING');
      print(data);
    });
    socket!.onPong((data) {
      print('SOCKET: PONG');
      print(data);
    });
    socket!.onerror((err) {
      print('SOCKET: onerror');
      print(err);
    });
  }

  tryReconnect() {
    print("reconnect socket");
    if (socket != null) {
      if (socket!.connected == false) {
        print('SOCKET: MANUAL CONNECT');
        // socket.clearListeners();
        // socket.dispose();
        try {
          // print('yes inside reconnect socket try');
          socket!.connect();
        } catch (error, stackTrace) {
          print('socket connection error = $error');
          print('socket connection error stackTrace = $stackTrace');
        }
        isFirstConnect = false;
      } else {
        isFirstConnect = false;
        print('SOCKET: ALREADY CONNECTED');
      }
    } else {
      isFirstConnect = true;
      print('SOCKET: NOT INITIALISED');
    }
  }

  disconnectSocket() {
    print("disconnect socket");
    socket!.disconnect();
    // print("dispose socket");
    // socket.clearListeners();
    // socket.dispose();
  }

  /// Emit Online Status
  showOnline() {
    print("SOCKET: showOnline()");
    final data = {'id': getIntAsync(USER_ID)};
    socket!.emit('con', data);
    print(data);
  }

  msgSeen(buddyId) {
    print("SOCKET: msgSeen()");
    final data = {
      'user_id': buddyId,
      'noti_type': "msg_seen",
      'from_user': getIntAsync(USER_ID),
      'is_seen': 1,
    };
    socket!.emit('notification', data);
    container.read(userProvider.notifier).fetchseen();
    print(data);
  }

  /// emit call sysytem

  makecall({CallUserModel? sender, CallUserModel? receiver, token, channel, String? type, bool video = false}) {
    var data = {
      'user_id': receiver?.userId,
      'noti_type': type,
      'from_user': sender?.userId,
      if (type != "hang-up" || type != "busy")
        'call_data': {'sender': sender?.toJson(), 'receiver': receiver?.toJson(), 'token': token, 'channel': channel}
    };
    print(data);
    print("typeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print(type);

    print('socket callllllllllllll');
    print(userGetCall);

    if (userGetCall || userGetResponse.value || type == "call-made") {
      print('socket callllllllllllll');
      print(userGetCall);
      video ? socket!.emit('video-call', data) : socket!.emit('audio-call', data);
    }
  }

  /// Typing status
  /// WARNING!!!! - There is a flow in the socket event. I should not get noti-
  /// -fication event if I am the one typing. Now this causes the typing status
  /// change even if I'm the one typing.
  bool? _tempTypingSate;

  showTyping(buddyId, bool isTyping) async {
    if (_tempTypingSate != isTyping) {
      print("SOCKET: showTyping()");
      final data = {
        'user_id': buddyId,
        'buddy_id': getIntAsync(USER_ID),
        'noti_type': 'typing',
        'isTyping': isTyping,
      };
      socket!.emit('notification', data);
      _tempTypingSate = isTyping;
      print(data);
    }
  }

  /// Listen to incoming notification
  incomingNotification() {
    print("SOCKET: incomingNotification() noti:${getIntAsync(USER_ID)}");
    socket!.on('noti:${getIntAsync(USER_ID)}', (data) {
      print("incomingNotification() : $data");

      if (data['noti_type'] == "new_chat") {
        if (container.read(conversationsProvider.notifier).conversations!.isEmpty) {
          /// If the conversation list is 0 (first time) refresh the list
          container.read(conversationsProvider.notifier).fetchConversations();
        } else {
          dynamic isFoundIndex = container.read(conversationsProvider.notifier).conversations!.indexWhere((element) => 
          element.buddyId == data['from_id']);
          print("conversation indexxxxxxxxxxxxxxxxxxxxxx");
          if (isFoundIndex == -1) {
            /// If chat not found in the conversation list refresh the list
            container.read(conversationsProvider.notifier).fetchConversations(isLoading: false);
          } else {
            /// Detect if a chat is open / closed based on the chatProvider buddyId
            if (container.read(chatProvider.notifier).buddyId == data['from_id']) {
              /// Update on going chat in real time
              print('inserttttttttttttt');
              container.read(chatProvider.notifier).insertNewIncomingChat(data['chatObj']);
              container.read(conversationsProvider.notifier).fetchConversations(isLoading: false, socket: true);

              msgSeen(container.read(chatProvider.notifier).buddyId);
            } else {
              var conversationIndex =
                  container.read(conversationsProvider.notifier).conversations!.indexWhere((element) => element.buddyId == data['from_id']);

              /// Update last message
              container.read(conversationsProvider.notifier).conversations![conversationIndex].lastmsg = Lastmsg.fromJson(data['chatObj']);
              container.read(conversationsProvider.notifier).conversations![conversationIndex].isSeen = 0;
              container.read(conversationsProvider.notifier).conversations![conversationIndex].updatedAt = DateTime.now();

              /// Update chat list conversation order based on latest incoming message
              var temp = container.read(conversationsProvider.notifier).conversations![conversationIndex];
              container.read(conversationsProvider.notifier).conversations!.removeAt(conversationIndex);
              container.read(conversationsProvider.notifier).conversations!.insert(0, temp);
              container.read(userProvider.notifier).refreshState();

              container.read(conversationsProvider.notifier).refreshState();
            }
          }
        }
      } else if (data['noti_type'] == "typing") {
        if (container.read(chatProvider.notifier).buddyId == data['buddy_id']) {
          container.read(chatProvider.notifier).isTyping = data['isTyping'];
          container.read(chatProvider.notifier).refreshState();
        }
      } else if (data['noti_type'] == "msg_seen") {
        container.read(conversationsProvider.notifier).conversations?.forEach((element) {
          if (element.buddyId == data['from_user']) {
            element.isSeen = data['is_seen'];
            container.read(conversationsProvider.notifier).refreshState();
          }
        });
        if (container.read(chatProvider.notifier).buddyId == data['from_user']) {
          print("budddy iddddddddddddd");
          container.read(chatProvider.notifier).chatModel!.seen = 1;

          container.read(chatProvider.notifier).seenUpdate();
          container.read(chatProvider.notifier).refreshState();
        }
      } else if (data['noti_type'] == "video_call") {
        //
      } else {
        // if (data['noti_type'] == "feed_like" && data['is_deleted'] == true) {
        //   context.read(userProvider).decreaseNotificationCount();
        // } else {
        //   context.read(userProvider).increaseNotificationCount();
        // }

        // if (data['noti_type'] == "event_invitation") {
        //   //
        // } else if (data['noti_type'] == "new_group_member") {
        //   //
        // } else if (data['noti_type'] == "new_group_request") {
        // } else if (data['noti_type'] == "page_follow") {
        //   //
        // } else if (data['noti_type'] == "accept_friend") {
        //   //
        // } else if (data['noti_type'] == "new_friend") {
        //   context.read(userProvider).increaseFriendRequestCount();
        // } else if (data['noti_type'] == "feed_like" || data['noti_type'] == "share_post") {
        // } else if (data['noti_type'] == "feed_comment") {
        //   //
        // }
      }
    });
  }

  /// Listen to user Online status
  userOnlineStatus() {
    print("SOCKET: userOnlineStatus()");

    socket!.on('online', (data) async {
      print("userOnlineStatus(): $data");

      /// Update Chat Friend List widget in Home Tab
      if (container.read(chatFriendsProvider.notifier).chatFriendsModel != null) {
        container.read(chatFriendsProvider.notifier).chatFriendsModel!.data?.forEach((element) {
          if (element.id == data['id']) {
            element.isOnline = data['is_online'];
            print("Home Tab: Online Status - ${element.isOnline}");
            container.read(chatFriendsProvider.notifier).refreshState();
          }
        });
      }

      /// Update Messages tab
      if (container.read(conversationsProvider.notifier).conversations!.isNotEmpty) {
        container.read(conversationsProvider.notifier).conversations?.forEach((element) {
          if (element.buddyId == data['id']) {
            element.buddy!.isOnline = data['is_online'];
            print("Message: Online Status - ${element.buddy!.isOnline}");
            container.read(conversationsProvider.notifier).refreshState();
          }
        });
      }

      /////////  /// Update chat screen
      if (data['id'] == container.read(chatProvider.notifier).buddyId) {
        container.read(chatProvider.notifier).chatModel!.onlineChat = data['is_online'];
        print("Chat: Online Status - ${container.read(chatProvider.notifier).chatModel!.onlineChat}");
        container.read(chatProvider.notifier).updateBuddyOnline(data['is_online']);
      }

      /// Update home tab
      if (container.read(chatFriendsProvider.notifier).chatFriendsModel != null) {
        if (container.read(chatFriendsProvider.notifier).chatFriendsModel!.data!.isNotEmpty) {
          container.read(chatFriendsProvider.notifier).chatFriendsModel!.data?.forEach((element) {
            if (element.id == data['id']) {
              element.isOnline = data['is_online'];
              print("Message: hometab Status - ${element.isOnline}");
              container.read(chatFriendsProvider.notifier).refreshState();
            }
          });
        }
      }

      /// Update from search screen to chat
      if (container.read(searchProvider.notifier).response != null) {
        if (container.read(searchProvider.notifier).response.length != 0) {
          container.read(searchProvider.notifier).response.forEach((element) {
            if (element.id == data['id']) {
              element.isOnline = data['is_online'];
              print("Message: search Status - ${element.isOnline}");
              container.read(chatFriendsProvider.notifier).refreshState();
            }
          });
        }
      }

      /// Update from profile
      if (container.read(myProfileFeedProvider.notifier).myProfileFeedList != null) {
        if (container.read(myProfileFeedProvider.notifier).myProfileFeedList?.basicOverView != null) {
          if (container.read(myProfileFeedProvider.notifier).myProfileFeedList?.basicOverView!.id == data['id']) {
            container.read(myProfileFeedProvider.notifier).myProfileFeedList?.basicOverView!.isOnline = data['is_online'];
            print("Message: profile Status - ${container.read(myProfileFeedProvider.notifier).myProfileFeedList?.basicOverView!.isOnline}");
            container
                .read(myProfileFeedProvider.notifier)
                .refreshBasicInfoState(container.read(myProfileFeedProvider.notifier).myProfileFeedList?.basicOverView);
          }
        }
      }
    });
  }

  /// Listen to incoming call

  handleAudioCall() {
    print("SOCKET: audio-call() audio-call:${getIntAsync(USER_ID)}");

    socket!.on('audio-call:${getIntAsync(USER_ID)}', (data) async {
      print("audio-call() : $data");

      if (data['noti_type'] == "call-made") {
        print('SOCKETT CALL MADE $data');
        userGetCall = true;

        // print("anotherCall.value   sssssssssssssssssssssse");
        // print(anotherCall.value);

        // if (anotherCall.value==2) {
        //   makecall(
        //       sender: User.fromJson(data["call_data"]['receiver']),
        //       receiver: User.fromJson(data["call_data"]['sender']),
        //       type: "another-call",
        //       token: data["call_data"]['token'],
        //       channel: data["call_data"]['channel'],
        //       video: false);
        // anotherCall.value = 3;

        // } else {
        makecall(
            sender: CallUserModel.fromJson(data["call_data"]['receiver']),
            receiver: CallUserModel.fromJson(data["call_data"]['sender']),
            type: "get-call",
            token: data["call_data"]['token'],
            channel: data["call_data"]['channel'],
            video: false);

        userGetResponse.value = true;
        NavigationService.navigateTo(CupertinoPageRoute(
          builder: (context) => CallUserScreen(
              friend: CallUserModel.fromJson(data["call_data"]['sender']),
              self: CallUserModel.fromJson(data["call_data"]['receiver']),
              type: "calling",
              token: data["call_data"]['token'],
              channel: data["call_data"]['channel'],
              video: false),
        ));

        // Navigator.push(
        //     container,
        //     CupertinoPageRoute(
        //       builder: (context) => CallUser(
        //           friend: User.fromJson(data["call_data"]['sender']),
        //           self: User.fromJson(data["call_data"]['receiver']),
        //           type: "calling",
        //           token: data["call_data"]['token'],
        //           channel: data["call_data"]['channel'],
        //           video: false),
        //     ));

      }
      if (data['noti_type'] == "get-call") {
        print('SOCKETT Get call $data');

        userGetResponse.value = true;
      }
      // if (data['noti_type'] == "another-call") {
      //   print('SOCKETT another call $data');
      //   anotherCall.value = 3;
      //   if (engine != null) {
      //     engine.leaveChannel();
      //   }
      //   await Future.delayed(Duration(milliseconds: 500));
      //   Navigator.of(context).pop();
      //   userGetResponse.value = false;
      //   userGetCall = false;
      // }
      if (data['noti_type'] == "hang-up") {
        print('SOCKETT Hangup $data');
        callEnded.value = true;
        userGetResponse.value = false;
        await Future.delayed(const Duration(milliseconds: 500));
        NavigationService.popNavigate();
        //  Navigator.of(container).pop();
        userGetCall = false;
      }
      if (data['noti_type'] == "busy") {
        print('SOCKETT busy $data');

        if (engine != null) {
          engine?.leaveChannel();
        }
        callEnded.value = true;
        userGetResponse.value = false;
        // Vibration.cancel();
        // if (player.playing) player.stop();
        // FlutterRingtonePlayer.stop();
        await Future.delayed(const Duration(milliseconds: 500));
        NavigationService.popNavigate();
        //  Navigator.of(container).pop();
        userGetCall = false;
      }
    });
  }

  handleVideoCall() {
    print("SOCKET: video-call() video-call:${getIntAsync(USER_ID)}");

    socket!.on('video-call:${getIntAsync(USER_ID)}', (data) async {
      print("video-call() : $data");

      if (data['noti_type'] == "call-made") {
        print('SOCKETT CALL MADE $data');
        userGetCall = true;

        makecall(
            sender: CallUserModel.fromJson(data["call_data"]['receiver']),
            receiver: CallUserModel.fromJson(data["call_data"]['sender']),
            type: "get-call",
            token: data["call_data"]['token'],
            channel: data["call_data"]['channel'],
            video: true);

        userGetResponse.value = true;

        // Navigator.push(
        //     container,
        //     CupertinoPageRoute(
        //       builder: (context) => CallUser(
        //           friend: User.fromJson(data["call_data"]['sender']),
        //           self: User.fromJson(data["call_data"]['receiver']),
        //           type: "calling",
        //           token: data["call_data"]['token'],
        //           channel: data["call_data"]['channel'],
        //           video: true
        //           ),
        //     ));

        NavigationService.navigateTo(CupertinoPageRoute(
          builder: (context) => CallUserScreen(
              friend: CallUserModel.fromJson(data["call_data"]['sender']),
              self: CallUserModel.fromJson(data["call_data"]['receiver']),
              type: "calling",
              token: data["call_data"]['token'],
              channel: data["call_data"]['channel'],
              video: true),
        ));
      }
      if (data['noti_type'] == "get-call") {
        print('SOCKETT Get call $data');

        userGetResponse.value = true;
      }
      if (data['noti_type'] == "hang-up") {
        print('SOCKETT Hangup $data');
        callEnded.value = true;
        userGetResponse.value = false;
        await Future.delayed(const Duration(milliseconds: 500));
         NavigationService.popNavigate();
        //Navigator.of(container).pop();
        userGetCall = false;
      }
      if (data['noti_type'] == "busy") {
        print('SOCKETT busy $data');

        if (engine != null) {
          engine?.leaveChannel();
        }
        callEnded.value = true;
        userGetResponse.value = false;
        // Vibration.cancel();
        // if (player.playing) player.stop();
        // FlutterRingtonePlayer.stop();
        await Future.delayed(const Duration(milliseconds: 500));
         NavigationService.popNavigate();
        //Navigator.of(container).pop();
        userGetCall = false;
      }
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
