import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsFeedSettingsScreen extends ConsumerStatefulWidget {
  const NewsFeedSettingsScreen({Key? key}) : super(key: key);

  @override
  _NewsFeedSettingsScreenState createState() => _NewsFeedSettingsScreenState();
}

class _NewsFeedSettingsScreenState extends ConsumerState<NewsFeedSettingsScreen> {
  bool personal = true;
  bool isLoading = false;

  @override
  void initState() {
    fetchNewsFeedSettings();
    super.initState();
  }

  fetchNewsFeedSettings() {
    if (ref.read(userProvider.notifier).userData!.user!.defaultFeed == "personal") {
      personal = true;
    } else {
      personal = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(title: 'Newsfeed', automaticallyImplyLeading: false, hasLeading: true),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              InkWell(
                onTap: () {
                  setState(() {
                    personal = !personal;
                  });
                },
                child: Row(
                  children: [
                    Icon(personal ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        size: 20, color: personal ? KColor.primary : KColor.black45.withOpacity(0.7)),
                    SizedBox(width: KSize.getWidth(context, 8)),
                    Expanded(
                        child: Text('Personal Newsfeed (you only get the news that you subscribed to)',
                            style: KTextStyle.subtitle2.copyWith(fontSize: 16, fontWeight: FontWeight.normal, color: KColor.black))),
                  ],
                ),
              ),
              SizedBox(height: KSize.getHeight(context, 15)),
              InkWell(
                onTap: () {
                  setState(() {
                    personal = !personal;
                  });
                },
                child: Row(
                  children: [
                    Icon(!personal ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        size: 20, color: !personal ? KColor.primary : KColor.black45.withOpacity(0.7)),
                    SizedBox(width: KSize.getWidth(context, 8)),
                    Expanded(
                        child: Text('World Newsfeed (you get news from everybody)',
                            style: KTextStyle.subtitle2.copyWith(fontSize: 16, fontWeight: FontWeight.normal, color: KColor.black))),
                  ],
                ),
              ),
            ]),
            SizedBox(height: KSize.getHeight(context, 20)),
            KButton(
              title: isLoading ? 'Please wait...' : 'Save Changes',
              color: isLoading ? KColor.grey : KColor.buttonBackground,
              onPressedCallback: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });

                      await ref.read(userProvider.notifier).feedSettings(personal);
                      setState(() {
                        isLoading = false;
                      });
                    },
            ),
          ],
        ),
      ),
    );
  }
}
