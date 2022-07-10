import 'dart:io';

import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/country/country_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/page/page_about_controller.dart';
import 'package:buddyscripts/controller/page/page_category_controller.dart';
import 'package:buddyscripts/controller/page/page_controller.dart';
import 'package:buddyscripts/controller/page/page_feed_controller.dart';
import 'package:buddyscripts/controller/page/page_photos_controller.dart';
import 'package:buddyscripts/controller/page/page_videos_controller.dart';
import 'package:buddyscripts/controller/page/state/page_feed_state.dart';
import 'package:buddyscripts/controller/page/state/page_state.dart';
import 'package:buddyscripts/controller/pagination/page/page_feed_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/models/auth/user_model.dart';
import 'package:buddyscripts/models/page/page_feed_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_image_view.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_profile_loading_indicator.dart';
import 'package:buddyscripts/views/screens/account/pages/edit_page_screen.dart';
import 'package:buddyscripts/views/screens/account/pages/page_photos_screen.dart';
import 'package:buddyscripts/views/screens/account/pages/page_videos_screen.dart';
import 'package:buddyscripts/views/screens/home/report_feed_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/global_components/create_feed_card.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/screens/account/pages/page_about_screen.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class PageDetailsScreen extends ConsumerWidget {
  PageDetailsScreen({Key? key}) : super(key: key);

  List pageTabs = [
    {'icon': Icons.info, 'title': 'About'},
    {'icon': Icons.photo_library, 'title': 'Photos'},
    {'icon': Icons.video_collection, 'title': 'Videos'},
  ];
  double top = 0.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final pageFeedState = ref.watch(pageFeedProvider);
    final pageState = ref.watch(pageProvider);
    final pageFeedScrollState = ref.watch(pageFeedScrollProvider);
    User? userData = userState is UserSuccessState ? userState.userModel.user : null;

    PageFeedModel? pageFeedData = pageFeedState is PageFeedSuccessState ? pageFeedState.pageFeedModel : null;

    ref.listen(pageFeedScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        if (ref.read(pageFeedProvider.notifier).pageFeedList!.feedData!.isNotEmpty) {
          ref.read(pageFeedProvider.notifier).fetchMorePageFeed(pageFeedData!.basicOverView!.slug!);
        }
      }
    });
    return CupertinoPageScaffold(
        backgroundColor: KColor.appBackground,
        navigationBar: pageFeedData == null ? KCupertinoNavBar() : null,
        child: pageFeedState is PageFeedLoadingState
            ? const KProfileLoadingIndicator()
            : pageFeedData == null
                ? const KContentUnvailableComponent(message: 'Page not found!', isUnavailablePage: true)
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    controller: ref.read(pageFeedScrollProvider.notifier).controller,
                    slivers: [
                        CupertinoSliverRefreshControl(onRefresh: () {
                          return ref.read(pageFeedProvider.notifier).fetchPageFeed(pageFeedData.basicOverView!.slug!);
                        }),
                        SliverAppBar(
                          pinned: true,
                          floating: true,
                          backgroundColor: KColor.primary,
                          automaticallyImplyLeading: false,
                          titleSpacing: 0,
                          leadingWidth: 66,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 20, color: KColor.whiteConst),
                            onPressed: () => Navigator.pop(context),
                          ),
                          elevation: 0,
                          expandedHeight: MediaQuery.of(context).size.height * 0.345,
                          flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                            print('constraints=' + constraints.toString());
                            top = constraints.biggest.height;
                            return FlexibleSpaceBar(
                              collapseMode: CollapseMode.none,
                              centerTitle: true,
                              title: Text(
                                top <= 80 ? '${pageFeedData.basicOverView?.pageName}' : "",
                                style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.whiteConst),
                              ),
                              background: Container(
                                color: KColor.white,
                                child: Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(CupertinoPageRoute(builder: (context) => KImageView(url: pageFeedData.basicOverView?.cover)));
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                        child: Image.network(
                                          pageFeedData.basicOverView!.cover!,
                                          height: MediaQuery.of(context).size.height * 0.35,
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      left: 8,
                                      child: SafeArea(
                                        child: Container(
                                          decoration: BoxDecoration(color: KColor.blackConst.withOpacity(0.5), shape: BoxShape.circle),
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_back_ios, size: 18, color: KColor.black87),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 8,
                                      child: SafeArea(
                                        child: Container(
                                          decoration: BoxDecoration(color: KColor.blackConst.withOpacity(0.5), shape: BoxShape.circle),
                                          child: PopupMenuButton(
                                              tooltip: '',
                                              onSelected: (selected) {
                                                if (selected == 'edit') {
                                                  ref.read(pageCategoryProvider.notifier).fetchPageCategory();
                                                  ref.read(countryProvider.notifier).fetchCountries();
                                                  Navigator.of(context, rootNavigator: true).push(
                                                    CupertinoPageRoute(builder: (context) => EditPageScreen(pageFeedData.basicOverView)),
                                                  );
                                                } else if (selected == 'delete') {
                                                  KDialog.kShowDialog(
                                                      context,
                                                      ConfirmationDialogContent(
                                                          titleContent: 'Are you sure want to delete this page?',
                                                          onPressedCallback: () async => {
                                                                Navigator.pop(context),
                                                                KDialog.kShowDialog(
                                                                  context,
                                                                  const ProcessingDialogContent("Processing..."),
                                                                  barrierDismissible: false,
                                                                ),
                                                                await ref.read(pageProvider.notifier).deletePage(pageFeedData.basicOverView!.id!),
                                                                Navigator.pop(context),
                                                              }),
                                                      useRootNavigator: false);
                                                } else if (selected == 'report') {
                                                  Navigator.of(context, rootNavigator: true).push(
                                                      CupertinoPageRoute(builder: (context) => ReportFeedScreen(pageFeedData.basicOverView, "page")));
                                                }
                                              },
                                              color: AppMode.darkMode ? KColor.feedActionCircle : KColor.appBackground,
                                              icon: const Icon(MaterialIcons.more_horiz, size: 18, color: KColor.whiteConst),
                                              itemBuilder: (_) {
                                                return userData!.id == pageFeedData.basicOverView!.userId!
                                                    ? <PopupMenuItem<String>>[
                                                        PopupMenuItem<String>(
                                                            value: "edit",
                                                            child: Text(
                                                              'Edit',
                                                              style:
                                                                  KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                                            )),
                                                        PopupMenuItem<String>(
                                                            value: "delete",
                                                            child: Text(
                                                              'Delete',
                                                              style:
                                                                  KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                                            )),
                                                      ]
                                                    : <PopupMenuItem<String>>[
                                                        PopupMenuItem<String>(
                                                            value: "report",
                                                            child: Text(
                                                              'Report',
                                                              style:
                                                                  KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                                            )),
                                                      ];
                                              }),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: (MediaQuery.of(context).size.width * 0.5) - KSize.getWidth(context, 75),
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  CupertinoPageRoute(builder: (context) => KImageView(url: pageFeedData.basicOverView!.profilePic)));
                                            },
                                            child: Container(
                                              height: KSize.getHeight(context, 150),
                                              width: KSize.getWidth(context, 150),
                                              decoration: BoxDecoration(
                                                color: KColor.white,
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: KColor.appBackground, width: 3),
                                                image:
                                                    DecorationImage(image: NetworkImage(pageFeedData.basicOverView!.profilePic!), fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                          if (pageFeedData.basicOverView!.userId == getIntAsync(USER_ID))
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Material(
                                                color: KColor.white.withOpacity(0.4),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(50),
                                                  onTap: () async {
                                                    File? picked = await AssetService.pickMedia(true, context, false, true);
                                                    if (picked != null) {
                                                      await ref.read(pageProvider.notifier).uploadPagePicture(
                                                        image: [picked],
                                                        pageId: pageFeedData.basicOverView!.id,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(10),
                                                    decoration:
                                                        BoxDecoration(border: Border.all(color: KColor.grey, width: 0.3), shape: BoxShape.circle),
                                                    child: Icon(CupertinoIcons.camera_fill, size: 16, color: KColor.black87),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (pageFeedData.basicOverView!.userId == getIntAsync(USER_ID))
                                      Positioned(
                                        bottom: 30,
                                        right: 10,
                                        child: Material(
                                          color: KColor.white.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(50),
                                            onTap: () async {
                                              File? picked = await AssetService.pickMedia(true, context, false, true);
                                              if (picked != null) {
                                                await ref.read(pageProvider.notifier).uploadPagePicture(
                                                  image: [picked],
                                                  pageId: pageFeedData.basicOverView!.id,
                                                  type: 'cover',
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(border: Border.all(color: KColor.grey, width: 0.3), shape: BoxShape.circle),
                                              child: Icon(CupertinoIcons.camera_fill, size: 16, color: KColor.black87),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        SliverToBoxAdapter(
                            child: Column(
                          children: [
                            Container(
                              color: KColor.white,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: KSize.getHeight(context, 15)),
                                          Text(pageFeedData.basicOverView?.pageName ?? '',
                                              style: KTextStyle.headline4.copyWith(fontWeight: FontWeight.w700, color: KColor.black)),
                                          SizedBox(height: KSize.getHeight(context, 8)),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(pageFeedData.basicOverView?.categoryName ?? '',
                                                  style: KTextStyle.subtitle2.copyWith(color: KColor.black54)),
                                              if (pageFeedData.basicOverView?.categoryName != '')
                                                Row(
                                                  children: [
                                                    SizedBox(width: KSize.getWidth(context, 5)),
                                                    Icon(Icons.circle, size: 4, color: KColor.black54),
                                                    SizedBox(width: KSize.getWidth(context, 5)),
                                                  ],
                                                ),
                                              Text(
                                                  pageFeedData.basicOverView!.totalPageLikes! > 1
                                                      ? '${pageFeedData.basicOverView!.totalPageLikes} followers'
                                                      : '${pageFeedData.basicOverView!.totalPageLikes} follower',
                                                  style: KTextStyle.subtitle2.copyWith(color: KColor.black54)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: KSize.getHeight(context, 20)),
                                  Visibility(
                                    visible: userData!.id != pageFeedData.basicOverView!.userId,
                                    child: KButton(
                                      title: pageState is PageLoadingState
                                          ? "Please wait..."
                                          : pageFeedData.basicOverView!.isFollow!
                                              ? 'Unfollow'
                                              : 'Follow',
                                      innerPadding: 10,
                                      leadingTitleIcon: const Icon(Icons.rss_feed, color: KColor.whiteConst),
                                      onPressedCallback: () {
                                        pageFeedData.basicOverView!.isFollow!
                                            ? ref.read(pageProvider.notifier).unfollowPage(pageFeedData.basicOverView!.id)
                                            : ref.read(pageProvider.notifier).followPage(pageFeedData.basicOverView!.id);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: KSize.getHeight(context, 16)),
                                ],
                              ),
                            ),
                            SizedBox(height: KSize.getHeight(context, 10)),
                            Container(
                              color: KColor.darkAppBackground,
                              width: MediaQuery.of(context).size.width,
                              height: KSize.getHeight(context, 80),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: pageTabs.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      if (pageTabs[index]['title'] == 'About') {
                                        ref.read(pageAboutProvider.notifier).fetchPageAbout(pageFeedData.basicOverView!.slug!);
                                        Navigator.push(context, CupertinoPageRoute(builder: (context) => const PageAboutScreen()));
                                      } else if (pageTabs[index]['title'] == 'Photos') {
                                        ref.read(pagePhotosProvider.notifier).fetchPagePhotos(pageFeedData.basicOverView!.slug!);
                                        Navigator.push(context, CupertinoPageRoute(builder: (context) => const PagePhotosScreen()));
                                      } else if (pageTabs[index]['title'] == 'Videos') {
                                        ref.read(pageVideosProvider.notifier).fetchPageVideos(pageFeedData.basicOverView!.slug!);
                                        Navigator.push(context, CupertinoPageRoute(builder: (context) => const PageVideosScreen()));
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: KColor.textBackground,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: KColor.white, width: 4)),
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                        margin: const EdgeInsets.only(right: 10),
                                        child: Row(
                                          children: [
                                            Icon(pageTabs[index]['icon'], size: 20, color: KColor.appThemeColor),
                                            SizedBox(width: KSize.getWidth(context, 5)),
                                            Text(pageTabs[index]['title'], style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (pageFeedData.basicOverView!.userId == userData.id)
                              CreateFeedCard(feedType: FeedType.PAGE, id: pageFeedData.basicOverView!.id),
                          ],
                        )),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          sliver: pageFeedData.feedData!.isEmpty
                              ? const SliverToBoxAdapter(
                                  child: KContentUnvailableComponent(message: 'End of feed! Keep checking back later!'),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) => FeedCard(
                                            feedData: pageFeedData.feedData![index],
                                            feedType: FeedType.PAGE,
                                            id: pageFeedData.basicOverView!.id!,
                                          ),
                                      childCount: pageFeedData.feedData!.length),
                                ),
                        ),
                        if (pageFeedScrollState is ScrollReachedBottomState && ref.read(pageFeedProvider.notifier).pageFeedList!.feedData!.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const CupertinoActivityIndicator(),
                            ),
                          ),
                      ]));
  }
}
