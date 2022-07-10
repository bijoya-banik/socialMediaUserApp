import 'package:buddyscripts/controller/search/search_controlller.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/services/debouncer.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/screens/home/search/tabs/people_search_tab.dart';
import 'package:buddyscripts/views/screens/home/search/tabs/post_search_tab.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TabController? _tabController;
  int _activeIndex = 0;
  final debouncer = Debouncer();

  //List tabs = ['Posts', 'People', 'Groups', 'Pages', 'Events'];
  List tabs = ['Posts', 'People'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController?.addListener(onTabChange);
    resetSearchSuccessState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  resetSearchSuccessState() async {
    await Future.delayed(const Duration(seconds: 0));
    ref.read(searchProvider.notifier).resetSearchSuccessState();
  }

  onTabChange() {
    if (_tabController!.indexIsChanging || _tabController!.index != _tabController!.previousIndex) {
      print('index = ${_tabController?.index}');
      if (!mounted) return;
      setState(() {
        _activeIndex = _tabController!.index;
        ref.read(searchProvider.notifier).resetSearchSuccessState();
      });
      if (searchController.text.isNotEmpty) {
        _activeIndex == 1
            ? ref.read(searchProvider.notifier).search(searchController.text, tab: 'people')
            // : _activeIndex == 2
            //     ? ref.read(searchProvider.notifier).search(searchController.text, tab: 'group')
            //     : _activeIndex == 3
            //         ? ref.read(searchProvider.notifier).search(searchController.text, tab: 'page')
            //         : _activeIndex == 4
            //             ? ref.read(searchProvider.notifier).search(searchController.text, tab: 'event')
                        :
                         ref.read(searchProvider.notifier).search(searchController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppMode.darkMode ? KColor.blackConst : KColor.appBackground,
      appBar: AppBar(
        backgroundColor: KColor.secondary,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18, color: KColor.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          margin: const EdgeInsets.only(right: 18),
          child: KTextField(
            backgroundColor: KColor.black.withOpacity(0.075),
            controller: searchController,
            hintText: 'Search',
            hintColor: KColor.black,
            textColor: KColor.black,
            topMargin: 5,
            hasPrefixIcon: true,
            autofocus: true,
            prefixIcon: Icon(Feather.search, color: KColor.black54, size: 20),
            isClearableField: true,
            callBack: true,
            callBackFunction: (val) {
              print(val);
              if (val.isEmpty) ref.read(searchProvider.notifier).resetSearchSuccessState();

              if (val.isNotEmpty) {
                debouncer.run(() => {
                      _activeIndex == 1
                          ? ref.read(searchProvider.notifier).search(searchController.text, tab: 'people')
                          //:
                          // _activeIndex == 2
                            //  ?
                              //  ref.read(searchProvider.notifier).search(searchController.text, tab: 'group')
                              // : _activeIndex == 3
                              //     ? ref.read(searchProvider.notifier).search(searchController.text, tab: 'page')
                              //     : _activeIndex == 4
                              //         ? ref.read(searchProvider.notifier).search(searchController.text, tab: 'event')
                                      : ref.read(searchProvider.notifier).search(searchController.text)
                    });
              }
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: KSize.getHeight(context, 5)),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: const [
                PostSearchTab(),
                PeopleSearchTab(),
                // GroupSearchTab(),
                // PageSearchTab(),
                // EventSearchTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
