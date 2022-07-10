import 'package:buddyscripts/controller/feelings_activities/feelings_controller.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/views/screens/home/feeling_activity/feeling_activity_tab/activity_tab.dart';
import 'package:buddyscripts/views/screens/home/feeling_activity/feeling_activity_tab/feeling_tab.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeelingActivityScreen extends ConsumerStatefulWidget {
  final FeelingsModel? feelingsModeldata;
  const FeelingActivityScreen({this.feelingsModeldata, Key? key}) : super(key: key);

  @override
  _FeelingActivityScreenState createState() => _FeelingActivityScreenState();
}

class _FeelingActivityScreenState extends ConsumerState<FeelingActivityScreen> with SingleTickerProviderStateMixin {
  List tabs = ['FEELINGS', 'ACTIVITIES'];

  TabController? _tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);

    if (widget.feelingsModeldata == null) {
      tabIndex = 0;
    } else {
      if (widget.feelingsModeldata?.type == "FEELINGS") {
        tabIndex = 0;
      } else {
        tabIndex = 1;
      }
    }

    print("tabIndexxxxxxxxxxxxxxxxxx");
    print(tabIndex);

    _tabController?.animateTo(tabIndex);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

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
              onPressed: () {
                Navigator.of(context).pop(ref.read(feelingsProvider.notifier).selectedfeelingData);
              }),
          centerTitle: true,
          title: Text("Feelings/Activities", style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.black)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(46),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                isScrollable: true,
                labelColor: KColor.black,
                labelStyle: KTextStyle.subtitle2,
                tabs: List.generate(tabs.length, (index) {
                  return Tab(text: "${tabs[index]}");
                }),
                indicatorColor: KColor.buttonBackground,
                unselectedLabelColor: KColor.black54,
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            FeelingTab(feelingsModeldata: widget.feelingsModeldata),
            ActivityTab(feelingsModeldata: widget.feelingsModeldata),
          ],
        ),
      ),
    );
  }
}
