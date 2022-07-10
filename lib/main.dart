import 'dart:io';

import 'package:buddyscripts/constants/custom_locale_messages.dart';
import 'package:buddyscripts/controller/theme/theme_notifier.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/notification_service.dart';
import 'package:buddyscripts/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:nb_utils/nb_utils.dart';
import 'package:buddyscripts/controller/logger/logger_controller.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/screens/startup/splash_screen.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'constants/shared_preference_constant.dart';

final container = ProviderContainer();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  NotificationService().firebaseInitialization();

  HttpOverrides.global = MyHttpOverrides(); // Override "en" locale messages with custom messages that are more precise and short
  timeago.setLocaleMessages('en_short', CustomShortLocaleMessages());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(ProviderScope(observers: [Logger()], child: const MyApp()));
  });
}

final themeProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier(true);
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _getTheme();
  }

  @override
  void dispose() {
    super.dispose();
    // disposing the globally self managed container.
    container.dispose();
  }

  _getTheme() async {
    await Future.delayed(const Duration(seconds: 0));
    Brightness brightness = SchedulerBinding.instance!.window.platformBrightness;
    if (getStringAsync(DARK_MODE) == "") {
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

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: KColor.secondary,
    //   statusBarIconBrightness: Brightness.light,
    //   statusBarBrightness: Brightness.light,
    // ));
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        title: 'BuddyScript',
        debugShowCheckedModeBanner: false,
        //  getPages: AppPages.pages,
        //  initialRoute: AppPages.INITIAL_ROUTE,
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
          primaryColor: KColor.primary,
          // ignore: deprecated_member_use
          accentColor: KColor.buttonBackground,
          textTheme: AppMode.darkMode ? Typography.material2018().white : Typography.material2018().black,
          backgroundColor: AppMode.darkMode ? KColor.black : KColor.white,
          scaffoldBackgroundColor: AppMode.darkMode ? KColor.black : KColor.white,
        ),
        builder: (context, child) {
          return CupertinoTheme(data: const CupertinoThemeData(), child: Material(child: child));
        },
        home: const SplashScreen(),
      ),
    );
  }
}
