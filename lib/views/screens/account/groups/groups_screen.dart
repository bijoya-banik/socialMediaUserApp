import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/screens/account/groups/create_group_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/tabs/discover_groups_tab.dart';
import 'package:buddyscripts/views/screens/account/groups/tabs/joined_groups_tab.dart';
import 'package:buddyscripts/views/screens/account/groups/tabs/my_groups_tab.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

// ignore: must_be_immutable
class GroupsScreen extends StatelessWidget {
  GroupsScreen({Key? key}) : super(key: key);

  List tabs = ['Discover', 'Joined', 'My Groups'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: KColor.darkAppBackground,
        appBar: AppBar(
          backgroundColor: KColor.secondary,
          elevation: 1,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 18, color: KColor.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // context.read(groupCategoryProvider).fetchGroupCategory();
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(fullscreenDialog: true, builder: (context) => const CreateGroupScreen()),
                );
              },
              icon: Icon(Icons.add_circle_outline, color: KColor.black),
            )
          ],
          centerTitle: true,
          title: Text('Groups', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.black)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(46),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                isScrollable: true,
                labelColor: KColor.black,
                labelStyle: KTextStyle.subtitle2,
                tabs: List.generate(tabs.length, (index) {
                  return Tab(text: "${tabs[index]}");
                }),
                indicatorColor: KColor.buttonBackground,
                unselectedLabelColor: KColor.black45,
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
                physics: BouncingScrollPhysics(),
                children: [
                  DiscoverGroupsTab(),
                  JoinedGroupsTab(),
                  MyGroupsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
