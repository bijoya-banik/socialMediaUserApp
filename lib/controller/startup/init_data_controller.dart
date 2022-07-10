// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/chat/chat_friends_controller.dart';
import 'package:buddyscripts/controller/chat/conversations_controller.dart';
import 'package:buddyscripts/controller/country/country_controller.dart';
import 'package:buddyscripts/controller/feed/personal_feed_controller.dart';
import 'package:buddyscripts/controller/feed/world_feed_controller.dart';
import 'package:buddyscripts/controller/notifications/notification_controller.dart';
import 'package:buddyscripts/controller/story/all_story_controller.dart';
import 'package:buddyscripts/controller/story/story_controller.dart';
import 'package:buddyscripts/main.dart';
import 'package:buddyscripts/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

Timer? timer, socketTimer;
final initDataProvider = StateNotifierProvider<InitDataController, Type>(
  (ref) => InitDataController(ref: ref),
);

class InitDataController extends StateNotifier<Type> {
  final Ref? ref;
  InitDataController({this.ref}) : super(Type);

  Future fetchData() async {
    try {
      await ref!.read(userProvider.notifier).fetchUserData();

      SocketService().initialize();
      if (SocketService().socket != null && SocketService().socket!.connected == false) {
        print('reconnecting socket in init');
        SocketService().socket!.disconnect();
        SocketService().socket!.clearListeners();

        SocketService().isFirstConnect = true;
        SocketService().isFromLogin = true;
        SocketService().initialize();
      } else {
        if (SocketService().socket == null) {
          print('reinitialising socket in init');

          SocketService().isFirstConnect = true;
          SocketService().isFromLogin = true;
          SocketService().initialize();
        }
      }

      ref!.read(worldFeedProvider.notifier).fetchWorldFeed();
      ref!.read(personalFeedProvider.notifier).fetchPersonalFeed();
      ref!.read(conversationsProvider.notifier).fetchConversations();
      ref!.read(chatFriendsProvider.notifier).fetchChatFriends();
      ref!.read(storyProvider.notifier).fetchStory();
      ref!.read(allstoryProvider.notifier).fetchAllStory();
      ref!.read(notificationsProvider.notifier).fetchNotifications();
      ref!.read(countryProvider.notifier).fetchCountries();

      await Future.delayed(const Duration(seconds: 0));
      Brightness brightness = SchedulerBinding.instance!.window.platformBrightness;
      if (getStringAsync(DARK_MODE) == "system") {
        if (brightness == Brightness.light) {
          ref!.read(themeProvider).setTheme(false);
        } else {
          ref!.read(themeProvider).setTheme(true);
        }
      } else if (getStringAsync(DARK_MODE) == "true") {
        ref!.read(themeProvider).setTheme(true);
      } else {
        ref!.read(themeProvider).setTheme(false);
      }

      if (getStringAsync(DARK_MODE) == '') {
        setValue(DARK_MODE, 'system');
        if (brightness == Brightness.light) {
          ref!.read(themeProvider).setTheme(false);
        } else {
          ref!.read(themeProvider).setTheme(true);
        }
      }

      timer = Timer.periodic(const Duration(seconds: 30), (t) {
        if (getBoolAsync(LOGGED_IN, defaultValue: false)) {
          ref!.read(userProvider.notifier).fetchOnline();
        }
      });

      socketTimer = Timer.periodic(const Duration(seconds: 5), (t) {
        // ignore: prefer_null_aware_operators
        print('SOCKET CONNECTION CHECK: ${SocketService().socket != null ? SocketService().socket!.connected : null}');
        if (getBoolAsync(LOGGED_IN, defaultValue: false)) {
          if (SocketService().socket != null && SocketService().socket!.connected == false) {
            print('reconnecting socket in check');
            SocketService().socket!.disconnect();
            SocketService().socket!.clearListeners();

            SocketService().isFirstConnect = true;
            SocketService().isFromLogin = true;
            SocketService().initialize();
          } else if (SocketService().socket == null) {
            print('reinitialising socket in check');

            SocketService().isFirstConnect = true;
            SocketService().isFromLogin = true;
            SocketService().initialize();
          }
        }
      });
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }
}
