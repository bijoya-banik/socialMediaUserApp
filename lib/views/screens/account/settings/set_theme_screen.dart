import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:nb_utils/nb_utils.dart';

class SetThemeScreen extends ConsumerStatefulWidget {
  const SetThemeScreen({Key? key}) : super(key: key);

  @override
  _SetThemeScreenState createState() => _SetThemeScreenState();
}

class _SetThemeScreenState extends ConsumerState<SetThemeScreen> {
  bool isLightTheme = false;
  bool isDarkTheme = false;
  bool isSystemTheme = false;

  @override
  void initState() {
    super.initState();
    _getTheme();
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

      setState(() {
        isSystemTheme = true;
      });
    } else if (getStringAsync(DARK_MODE) == "true") {
      ref.read(themeProvider).setTheme(true);

      setState(() {
        isDarkTheme = true;
      });
    } else {
      ref.read(themeProvider).setTheme(false);

      setState(() {
        isLightTheme = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: KColor.appBackground,
        navigationBar: KCupertinoNavBar(title: 'Set Theme', automaticallyImplyLeading: false, hasLeading: true),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              color:  KColor.appBackground,
              padding: EdgeInsets.symmetric(horizontal: KSize.getWidth(context, 20),
               vertical: KSize.getHeight(context, 15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildThemeOption(
                        context,
                        title: 'Light',
                        imagePath: AssetPath.lightThemeApp,
                        isSelected: isLightTheme,
                        onTap: () {
                          if (!isLightTheme) {
                            setState(() {
                              isLightTheme = !isLightTheme;
                              isDarkTheme = false;
                              isSystemTheme = false;
                              ref.read(themeProvider).setTheme(false);
                            });

                            setValue(DARK_MODE, 'false');
                          }
                        },
                      ),
                      buildThemeOption(
                        context,
                        title: 'Dark',
                        imagePath: AssetPath.darkThemeApp,
                        isSelected: isDarkTheme,
                        onTap: () {
                          if (!isDarkTheme) {
                            setState(() {
                              isDarkTheme = !isDarkTheme;
                              isLightTheme = false;
                              isSystemTheme = false;

                              ref.read(themeProvider).setTheme(true);
                            });

                            setValue(DARK_MODE, 'true');
                          }
                        },
                      ),
                      buildThemeOption(
                        context,
                        title: 'System',
                        imagePath: AssetPath.systemThemeApp,
                        isSelected: isSystemTheme,
                        onTap: () {
                          if (!isSystemTheme) {
                            setState(() {
                              isSystemTheme = !isSystemTheme;
                              isDarkTheme = false;
                              isLightTheme = false;

                              // context.read(themeProvider).setTheme(false);
                            });

                            if (SchedulerBinding.instance!.window.platformBrightness == Brightness.light) {
                              ref.read(themeProvider).setTheme(false);
                              setState(() {});
                            } else {
                              ref.read(themeProvider).setTheme(true);
                              setState(() {});
                            }

                            setValue(DARK_MODE, 'system');
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: KSize.getHeight(context, 24)),
                  Text(
                    'If \'system\' is selected, Buddy Script app will automatically adjust the theme based on your device\'s system settings.',
                    style: KTextStyle.bodyText3.copyWith(fontSize: 12, color: KColor.grey),
                  ),
                ],
              ),
            )));
  }

  buildThemeOption(BuildContext context, {String? title, String? imagePath, bool? isSelected, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: AppMode.darkMode ? KColor.grey850! : KColor.grey200!, width: 5),
            ),
            child: Image.asset(
              imagePath!,
              height: KSize.getHeight(context, 165),
            ),
          ),
          SizedBox(height: KSize.getHeight(context, 16)),
          Text(title!, style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.black87)),
          SizedBox(height: KSize.getHeight(context, 8)),
          Icon(isSelected! ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 22.5, color: isSelected ? KColor.primary : KColor.black45.withOpacity(0.7)),
        ],
      ),
    );
  }
}
