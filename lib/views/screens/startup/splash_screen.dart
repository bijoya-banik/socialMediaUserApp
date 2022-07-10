import 'package:buddyscripts/controller/startup/init_data_controller.dart';
import 'package:buddyscripts/views/global_components/k_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/screens/auth/login_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Animation<double>? animation;
  AnimationController? controller;

  bool _isLoggedIn = false;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    initData();
  }

  initData() {
    _isLoggedIn = getBoolAsync(LOGGED_IN, defaultValue: false);

    if (_isLoggedIn) {
      ref.read(initDataProvider.notifier).fetchData();
    }
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(context, FadeRoute(page: _isLoggedIn ? const KBottomNavigationBar() : const LoginScreen())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.secondary,
      body: Column(
        children: <Widget>[
          SizedBox(height: KSize.getHeight(context, 200)),
          Image.asset(
            AssetPath.fullLogo,
            fit: BoxFit.cover,
            height: KSize.getHeight(context, 65),
          ),
          SizedBox(height: KSize.getHeight(context, 20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'BuddyScript is a modern social network script that allows you to build your own niche social networking platform.',
              textAlign: TextAlign.center,
              style: KTextStyle.bodyText2.copyWith(color: KColor.black, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
