import 'dart:convert';
import 'dart:developer';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/controller/event/event_feed_controller.dart';
import 'package:buddyscripts/controller/feed/feed_details_controller.dart';
import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/controller/page/page_feed_controller.dart';
import 'package:buddyscripts/controller/profile/user_profile_feed_controller.dart';
import 'package:buddyscripts/main.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/k_bottom_navigation_bar.dart';
import 'package:buddyscripts/views/screens/account/events/event_details_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/group_details_screen.dart';
import 'package:buddyscripts/views/screens/account/pages/page_details_screen.dart';
import 'package:buddyscripts/views/screens/account/profile/user_profile_screen.dart';
import 'package:buddyscripts/views/screens/home/feed_details_screen.dart';
import 'package:buddyscripts/views/screens/messages/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/chats/chat_model.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  static RemoteMessage? remoteMessage;

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  NotificationSettings? settings;

  firebaseInitialization() async {
    await Firebase.initializeApp();
    checkPermissionStatus();
  }

  checkPermissionStatus() async {
    settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission status: ${settings?.authorizationStatus}');
    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      print('Authorized, initializing listeners');

      /// For iOS Foreground notification
      messaging.setForegroundNotificationPresentationOptions(
        badge: false,
        alert: false,
        sound: false,
      );

      /// Background
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      init();
      getToken();
    }
  }

  static Future getToken() async {
    String fcmToken = await messaging.getToken() ?? 'No FCM Token';
    print('fcmToken = $fcmToken');
    return fcmToken;
  }

  Future<void> init() async {
    /// Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(
            'Foreground (onMessage): Title:${message.notification?.title}, Subtitle:${message.notification?.body}, Data:${message.data.toString()}');
        remoteMessage = message;
        var data = json.decode(message.data['metadata']);

        if (data['noti_type'] == "new_chat") {
          print(data['noti_type']);
          if (container.read(chatProvider.notifier).buddyId == data['from_id']) {
            return;
          } else {
            container.read(userProvider.notifier).userData?.msgCount?.totalUnseen++;
            container.read(userProvider.notifier).refreshState();
          }
        }

        /// Detect if a chat is open / closed based on the chatProvider buddyId
        //  {

        /// Update unseen counter in Bottom Nav Bar

        //   return;
        // }
        else if (data['noti_type'] == "feed_like" && data['is_deleted'] == true) {
          container.read(userProvider.notifier).decreaseNotificationCount();
        } else if (data['noti_type'] == "feed_like" && data['is_deleted'] == false) {
          container.read(userProvider.notifier).increaseNotificationCount();
        } else if (data['noti_type'] == "new_friend") {
          container.read(userProvider.notifier).increaseNotificationCount();
          container.read(userProvider.notifier).increaseFriendRequestCount();
        } else {
          container.read(userProvider.notifier).increaseNotificationCount();
        }

        showNotification(
          1234,
          // "GET title FROM message OBJECT",
          "${message.notification?.title}",
          // "GET description FROM message OBJECT",
          "${message.notification?.body}",
          // "GET PAYLOAD FROM message OBJECT",
          "$message",
          // "${message.data.toString()}",
        );
      }
    });

    /// Background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      handleMessageReceive(message);
    });

    /// Background and terminated
    fetchInitialMessages();

    // local notif initialisation //
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  /// Background and terminated
  fetchInitialMessages() {
    messaging.getInitialMessage().then((message) {
      if (message != null) {
        print(
            'Background (Terminated): Title:${message.notification?.title}, Subtitle:${message.notification?.body}, Data:${message.data.toString()}');
        handleMessageReceive(message);
      }
    });
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      'firebaseMessagingBackgroundHandler: Title:${message.notification?.title}, Subtitle:${message.notification?.body}, Data:${message.data.toString()}');
}

handleMessageReceive(message) async {
  if (message.notification != null) {
    print('onMessageOpenedApp: Title:${message.notification.title}, Subtitle:${message.notification.body}, Data:${message.data.toString()}');
    var data = json.decode(message.data['metadata']);

    print("object");

    /// Deep-linking
    if (data['noti_type'] == "feed_like" || data['noti_type'] == "share_post") {
      container.read(feedDetailsProvider.notifier).fetchFeedDetails(data['feed_id']);
      await NavigationService.navigateTo(CupertinoPageRoute(builder: (_) => const FeedDetailsScreen()));
    } else if (data['noti_type'] == "feed_comment") {
      container.read(feedDetailsProvider.notifier).fetchFeedDetails(data['feed_id']);
      await NavigationService.navigateTo(CupertinoPageRoute(builder: (_) => const FeedDetailsScreen(showCommentModal: true)));
    } else if (data['noti_type'] == "event_invitation") {
      container.read(eventFeedProvider.notifier).fetchEventFeed(data['noti_meta']['slug']);
      NavigationService.navigateTo(CupertinoPageRoute(builder: (_) => EventDetailsScreen()));
    } else if (data['noti_type'] == "new_group_member" || data['noti_type'] == "new_group_request") {
      container.read(groupFeedProvider.notifier).fetchGroupFeed(data['noti_meta']['slug']);
      NavigationService.navigateTo(CupertinoPageRoute(builder: (_) => GroupDetailsScreen()));
    } else if (data['noti_type'] == "page_follow") {
      container.read(pageFeedProvider.notifier).fetchPageFeed(data['noti_meta']['slug']);
      NavigationService.navigateTo(CupertinoPageRoute(builder: (_) => PageDetailsScreen()));
    } else if (data['noti_type'] == "accept_friend" || data['noti_type'] == "new_friend") {
      container.read(userProfileFeedProvider.notifier).fetchProfileFeed(data['noti_meta']['username']);
      NavigationService.navigateTo(CupertinoPageRoute(builder: (_) => const UserProfileScreen()));
    } else if (data['noti_type'] == "new_chat") {
      print("objectttttttttttttttttttttttttttttt");
      print(data);
      log('data: $data');
      print(data['chatObj']['conversation']);
      print(data['chatObj']['user']);
      // TODO :: Sth for group chat
      //  container.read(chatProvider.notifier).fetchChat(data['from_id'], data['user']['is_online']);
      // NavigationService.navigateTo(CupertinoPageRoute(
      //     builder: (_) => ChatScreen(
      //           id: data['from_id'],
      //           firstName: data['user']['first_name'],
      //           lastName: data['user']['last_name'],
      //           profilePic: data['user']['profile_pic'],
      //           userName: data['user']['username'],
      //           isOnline: data['user']['is_online'],
      //         )));

      ConversationsModel conversation = ConversationsModel.fromJson(data['chatObj']['conversation']);
      User user = User.fromJson(data['chatObj']['user']);

      container.read(chatProvider.notifier).fetchChat(
          id: conversation.isGroup == 1 ? conversation.id : data['from_id'],
          group: conversation.isGroup,
          onlineChat: conversation.isGroup == 1 ? conversation.memberName ?? "" : user.isOnline);
      NavigationService.navigateTo(CupertinoPageRoute(
          builder: (context) => ChatScreen(
              id: conversation.isGroup == 1 ? conversation.id : data['from_id'],
              firstName: conversation.isGroup == 1 ? conversation.groupName ?? "" : user.firstName ?? "",
              lastName: conversation.isGroup == 1 ? "" : user.lastName ?? "",
              profilePic: conversation.isGroup == 1 ? conversation.groupLogo : user.profilePic,
              userName: conversation.isGroup == 1 ? "" : user.username ?? "",
              isOnline: conversation.isGroup == 1 ? conversation.memberName ?? "" : user.isOnline,
              conversation: conversation)));
    } else {
      NavigationService.navigateTo(CupertinoPageRoute(builder: (_) => const KBottomNavigationBar()));
    }
  }
}

Future<void> showNotification(
  int notificationId,
  String notificationTitle,
  String notificationContent,
  String payload, {
  String channelId = '1234',
  String channelTitle = 'Android Channel',
  String channelDescription = 'Default Android Channel for notifications',
  Priority notificationPriority = Priority.high,
  Importance notificationImportance = Importance.max,
}) async {
  print('inside show local notification');
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelTitle,
    channelDescription: channelDescription,
    playSound: true,
    enableVibration: true,
    importance: notificationImportance,
    priority: notificationPriority,
  );
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails(presentSound: true, presentBadge: true, presentAlert: true);
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin?.show(
    notificationId,
    notificationTitle,
    notificationContent,
    platformChannelSpecifics,
    payload: payload,
  );
}

Future<dynamic> onSelectNotification(msg) async {
  handleMessageReceive(NotificationService.remoteMessage);
}
