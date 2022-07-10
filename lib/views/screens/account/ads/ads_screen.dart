import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/screens/account/ads/create_ad_screen.dart';
import 'package:buddyscripts/views/screens/account/ads/tabs/ad_policy_tab.dart';
import 'package:buddyscripts/views/screens/account/ads/tabs/campaigns_tab.dart';
import 'package:buddyscripts/views/screens/account/ads/tabs/wallet_tab.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

// ignore: must_be_immutable
class AdsScreen extends StatelessWidget {
  AdsScreen({Key? key}) : super(key: key);

  List tabs = ['Campaigns', 'Wallet', 'Advertising Policies'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: KColor.appBackground,
        appBar: AppBar(
          backgroundColor: KColor.primary,
          elevation: 1,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 18, color: KColor.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(fullscreenDialog: true, builder: (context) => const CreateAdScreen()));
              },
              icon: Icon(Icons.add_circle_outline, color: KColor.white),
            )
          ],
          centerTitle: true,
          title: Text('Advertising', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.appBarTitle)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(46),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                isScrollable: true,
                labelColor: KColor.white,
                labelStyle: KTextStyle.subtitle2,
                tabs: List.generate(tabs.length, (index) {
                  return Tab(text: "${tabs[index]}");
                }),
                indicatorColor:  KColor.buttonBackground,
                unselectedLabelColor: KColor.white54,
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: KSize.getHeight(context, 5)),
            const Expanded(
              child: TabBarView(
                physics:BouncingScrollPhysics(),
                children: [
                  CampaignsTab(),
                  WalletTab(),
                  AdPolicyTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
