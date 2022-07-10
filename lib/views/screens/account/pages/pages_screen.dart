import 'package:buddyscripts/controller/page/page_category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/screens/account/pages/create_page_screen.dart';
import 'package:buddyscripts/views/screens/account/pages/tabs/discover_pages_tab.dart';
import 'package:buddyscripts/views/screens/account/pages/tabs/followed_pages_tab.dart';
import 'package:buddyscripts/views/screens/account/pages/tabs/my_pages_tab.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PagesScreen extends ConsumerStatefulWidget {
  const PagesScreen({Key? key}) : super(key: key);

  @override
  _PagesScreenState createState() => _PagesScreenState();
}

class _PagesScreenState extends ConsumerState<PagesScreen> {
  List tabs = ['Discover', 'Followed', 'My Pages'];

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
                ref.read(pageCategoryProvider.notifier).fetchPageCategory();
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(fullscreenDialog: true, builder: (context) => const CreatePageScreen()),
                );
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: KColor.black87,
              ),
            )
          ],
          centerTitle: true,
          title: Text('Pages', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.black)),
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
                unselectedLabelColor: KColor.black.withOpacity(0.6),
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
                  DiscoverPagesTab(),
                  FollowedPagesTab(),
                  MyPagesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
