import 'dart:io';

import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/main.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/personal_feed_controller.dart';
import 'package:buddyscripts/controller/feed/world_feed_controller.dart';
import 'package:buddyscripts/controller/notifications/notification_controller.dart';
import 'package:buddyscripts/controller/pagination/home/world_feed_tab.dart';
import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/startup/init_data_controller.dart';
import 'package:buddyscripts/views/screens/account/account_screen.dart';
import 'package:buddyscripts/views/screens/home/tabs/home_screen.dart';
import 'package:buddyscripts/views/screens/home/create_feed_screen.dart';
import 'package:buddyscripts/views/screens/messages/conversations_screen.dart';
import 'package:buddyscripts/views/screens/notifications/notification_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

AppLifecycleState? appLifecycleState;

class KBottomNavigationBar extends ConsumerStatefulWidget {
  const KBottomNavigationBar({this.index = 0, this.tabIndex = 0, Key? key}) : super(key: key);

  final int index;
  final int tabIndex;

  @override
  _KBottomNavigationBarState createState() => _KBottomNavigationBarState();
}

class _KBottomNavigationBarState extends ConsumerState<KBottomNavigationBar> with WidgetsBindingObserver {
  int _currentIndex = 0;
  int tab = 0;
  List<Widget>? _bottomNavPages;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    tab = widget.tabIndex;

    if (ref.read(userProvider.notifier).userData == null) {
      tab = 0;
    } else {
      if (ref.read(userProvider.notifier).userData?.user?.defaultFeed == "personal") {
        tab = 1;
      } else {
        tab = 0;
      }
    }
    _currentIndex = widget.index;
    _bottomNavPages = [
      HomeScreen(initialIndex: tab),
      // const ConversationsScreen(),
      // const NotificationScreen(),
      const AccountScreen(),
         const NotificationScreen(),
   //   const AccountScreen(),
      const AccountScreen(),
    ];
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(appLifecycleState) {
    if (appLifecycleState == AppLifecycleState.paused || appLifecycleState == AppLifecycleState.inactive) {
      // print("backkkkkkkkkkkkkkkkkkgrounddd");

    }
    if (appLifecycleState == AppLifecycleState.resumed) {
      // print("foregroundddddddddddddddddd");
      _getTheme();
    }
  }

  _getTheme() async {
    await Future.delayed(const Duration(seconds: 0));
    Brightness brightness = SchedulerBinding.instance!.window.platformBrightness;
    if (getStringAsync(DARK_MODE) == "system") {
      if (brightness == Brightness.light) {
        ref.read(themeProvider).setTheme(false);
      } else {
        ref.read(themeProvider).setTheme(true);
      }
    } else if (getStringAsync(DARK_MODE) == "true") {
      ref.read(themeProvider).setTheme(true);
    } else {
      ref.read(themeProvider).setTheme(false);
    }
  }

  Future<bool> _onWillPop() async {
    return await showPlatformDialog(
      context: context,
      builder: (_) => ConfirmationDialogContent(
          titleContent: 'Are you sure you want to exit this app?',
          onPressedCallback: () {
            timer!.cancel();
            socketTimer!.cancel();
            exit(0);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return WillPopScope(onWillPop: () {
      if (_currentIndex == 0) {
        _onWillPop();
      } else {
        setState(() {
          _currentIndex = 0;
        });
      }
      return Future.value(false);
    }, child: Consumer(builder: (context, WidgetRef ref, _) {
      // ignore: unused_local_variable
      final userState = ref.watch(userProvider);
      // ignore: unused_local_variable
      final themeState = ref.watch(themeProvider);
      return Scaffold(
        body: _bottomNavPages![_currentIndex],
        floatingActionButton: Container(
          padding: const EdgeInsets.only(top: 20, right: 10),
          child: SizedBox(
            height: 60,
            width: 60,
            child: !showFab
                ? null
                : FloatingActionButton(
                    backgroundColor: KColor.white,
                    elevation: 0,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(fullscreenDialog: true, builder: (context) => const CreateFeedScreen(feedType: FeedType.HOME)));
                    },
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: KColor.primary,
                        // gradient: LinearGradient(
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        //   colors: [
                        //     KColor.appThemeColor,
                        //     KColor.appThemeColor,
                        //     const Color(0xFF3D3F24),
                        //   ],
                        // ),
                      ),
                      child: const Icon(Icons.add, size: 30),
                    ),
                  ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            height: kBottomNavigationBarHeight,
            decoration: BoxDecoration(
              color: AppMode.darkMode ? KColor.appBackground : KColor.white,
              boxShadow: [
                BoxShadow(
                  color: KColor.shadowColor,
                  blurRadius: 44,
                  spreadRadius: 2,
                  offset: const Offset(0, -15),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(context, 'Home', AssetPath.homeIcon, AssetPath.homeFillIcon, 0),
                _buildBottomNavItem(context, 'Message', AssetPath.messageIcon, AssetPath.messageFillIcon, 1),
                const SizedBox(
                  width: 10,
                  height: 10,
                ),
                _buildBottomNavItem(context, 'Notification', AssetPath.bellIcon, AssetPath.bellFillIcon, 2),
                _buildBottomNavItem(context, 'Account', AssetPath.personIcon, AssetPath.personFillIcon, 3),
              ],
            ),
          ),
        ),
      );
    }));
  }

  Widget _buildBottomNavItem(BuildContext context, String title, String iconImage, String filledIconImage, int navIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = navIndex;
        });

        if (_currentIndex == 0) {
          if (ref.read(worldFeedScrollProvider.notifier).controller.hasClients) {
            if (ref.read(worldFeedScrollProvider.notifier).controller.offset >=
                    ref.read(worldFeedScrollProvider.notifier).controller.position.maxScrollExtent &&
                !ref.read(worldFeedScrollProvider.notifier).controller.position.outOfRange) {
              print("go to top");
              ref.read(worldFeedScrollProvider.notifier).controller.animateTo(
                    ref.read(worldFeedScrollProvider.notifier).controller.position.minScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
            } else {
              ref.read(worldFeedProvider.notifier).fetchWorldFeed();
              ref.read(personalFeedProvider.notifier).fetchPersonalFeed();
            }
          }
        } else if (_currentIndex == 1) {
          /// reset message unseen counter on tap
          ref.read(userProvider.notifier).updateMessageSeen();
        } else if (_currentIndex == 2) {
          /// Reset notification counter on tap
          ref.read(userProvider.notifier).updateNotificationCount();

          /// refresh notification on tap
          ref.read(notificationsProvider.notifier).fetchNotifications(reload: false);

          //else {
          // context.read(coursesProvider).fetchCourses();
          // context.read(coursesProvider).fetchCourseCount();
          // }
        } else if (_currentIndex == 3) {
          ref.read(profileAboutProvider.notifier).fetchProfileAbout(ref.read(userProvider.notifier).userData!.user!.username!);
        }
      },
      child: Container(
        height: kBottomNavigationBarHeight,
        color: KColor.transparent,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: KSize.getHeight(context, title == "Courses" ? 3 : 5)),
                Image.asset(
                  _currentIndex == navIndex ? filledIconImage : iconImage,
                  color: _currentIndex == navIndex ? KColor.primary : KColor.black87,
                  colorBlendMode: navIndex == 1 && _currentIndex == 1 ? BlendMode.dstATop : BlendMode.srcATop,
                  height: KSize.getHeight(context, 19.5),
                  width: KSize.getWidth(context, 21),
                ),
                SizedBox(height: KSize.getHeight(context, title == "Courses" ? 2 : 5)),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: KTextStyle.caption.copyWith(
                    letterSpacing: 0,
                    fontSize: 12,
                    fontWeight: _currentIndex == navIndex ? FontWeight.w700 : FontWeight.normal,
                    color: _currentIndex == navIndex ? KColor.primary : KColor.black87,
                  ),
                ),
              ],
            ),
            if (navIndex == 1 || navIndex == 2)
              if (ref.read(userProvider.notifier).userData != null)
                Positioned(
                  top: 5,
                  right: navIndex == 1 ? 5 : 17,
                  child: Visibility(
                    visible: navIndex == 1
                        ? ref.read(userProvider.notifier).userData!.msgCount!.totalUnseen > 0
                        : ref.read(userProvider.notifier).userData!.notiCount!.totalNoti! > 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(color: KColor.red, shape: BoxShape.circle),
                      child: Text(
                        navIndex == 1
                            ? ref.read(userProvider.notifier).userData!.msgCount!.totalUnseen > 9
                                ? "9+"
                                : ref.read(userProvider.notifier).userData!.msgCount!.totalUnseen.toString()
                            : ref.read(userProvider.notifier).userData!.notiCount!.totalNoti! > 9
                                ? "9+"
                                : ref.read(userProvider.notifier).userData!.notiCount!.totalNoti!.toString(),
                        textAlign: TextAlign.center,
                        style: KTextStyle.overline.copyWith(fontWeight: FontWeight.bold, color: KColor.whiteConst),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
