import 'dart:io';

import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/pagination/profile/profile_feed_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/controller/profile/my_profile_feed_controller.dart';
import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/my_profile_feed_state.dart';
import 'package:buddyscripts/controller/profile/profile_photos_controller.dart';
import 'package:buddyscripts/controller/profile/profile_videos_controller.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/models/profile/profile_feed_model.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/create_feed_card.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_image_view.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_profile_loading_indicator.dart';
import 'package:buddyscripts/views/screens/account/profile/profile_photos_screen.dart';
import 'package:buddyscripts/views/screens/account/profile/profile_videos_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/screens/account/profile/about_profile_screen.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  List profileTabs = [
    {'icon': Icons.person, 'title': 'About'},
    {'icon': Icons.photo_library, 'title': 'Photos'},
    {'icon': Icons.video_collection, 'title': 'Videos'},
  ];
  bool addToFeed = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final profileFeedState = ref.watch(myProfileFeedProvider);
      final profileFeedScrollState = ref.watch(profileFeedScrollProvider);

      ProfileFeedModel? profileFeedData = profileFeedState is MyProfileFeedSuccessState ? profileFeedState.profileFeedModel : null;

      ref.listen(profileFeedScrollProvider, (_, state) {
        if (state is ScrollReachedBottomState) {
          if (profileFeedData!.feedData!.isNotEmpty) {
            ref.read(myProfileFeedProvider.notifier).fetchMoreProfileFeed(profileFeedData.basicOverView!.username!);
          }
        }
      });

      return Container(
        color: KColor.darkAppBackground,
        child: (profileFeedState is MyProfileFeedSuccessState)
            ? CustomScrollView(
                controller: ref.read(profileFeedScrollProvider.notifier).controller,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  CupertinoSliverRefreshControl(onRefresh: () {
                    return ref.read(myProfileFeedProvider.notifier).fetchProfileFeed(profileFeedData!.basicOverView!.username!);
                  }),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [ 
                        Container(
                          color: KColor.textBackground,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(CupertinoPageRoute(builder: (context) => KImageView(url: profileFeedData!.basicOverView!.cover!)));
                                },
                                child: Container(
                                  color: KColor.textBackground,
                                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.035),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                    child: Image.network(
                                      API.baseUrl+ profileFeedData!.basicOverView!.cover!,
                                      height: MediaQuery.of(context).size.height * 0.34,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: (MediaQuery.of(context).size.width * 0.5) - KSize.getWidth(context, 51),
                                child: Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(builder: (context) => KImageView(url: profileFeedData.basicOverView!.profilePic)));
                                      },
                                      child: Container(
                                        height: KSize.getHeight(context, 102),
                                        width: KSize.getWidth(context, 102),
                                        decoration: BoxDecoration(
                                          color: KColor.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: KColor.textBackground, width: 3),
                                          image: DecorationImage(image: NetworkImage(profileFeedData.basicOverView!.profilePic!)),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 10,
                                      child: Material(
                                        color: KColor.white.withOpacity(0.4),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(50),
                                          onTap: () async {
                                            File? picked = await AssetService.pickMedia(true, context, false, true);
                                            if (picked != null) {
                                              await ref.read(userProvider.notifier).uploadUserPicture(image: [picked]);
                                              // KDialog.kShowDialog(
                                              //     context,
                                              //     ConfirmationDialogContent(
                                              //       title: 'Profile picture updated successfully!',
                                              //       titleShow: true,
                                              //       titleColor: KColor.primary,
                                              //       customBody: Padding(
                                              //         padding: const EdgeInsets.only(top: 20),
                                              //         child: Align(
                                              //             alignment: Alignment.center,
                                              //             child: Text(
                                              //               'Share your update to News Feed?',
                                              //               style: KTextStyle.bodyText3.copyWith(color: KColor.black87, fontWeight: FontWeight.bold),
                                              //             )),
                                              //       ),
                                              //       onPressedCallback: () async {
                                              //         ref.read(feedProvider.notifier).createFeed(
                                              //               feedText: "",
                                              //               images: [picked],
                                              //               activityType: 'feed',
                                              //               feedPrivacy: 'Public',
                                              //               feedType: FeedType.PROFILE,
                                              //               feelingsModel: FeelingsModel(name: 'updated her profile picture', icon: ""),
                                              //             );
                                              //         Navigator.pop(context);
                                              //       },
                                              //     ));
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
                              Positioned(
                                bottom: MediaQuery.of(context).size.height * 0.045,
                                right: 5,
                                child: Material(
                                  color: KColor.white.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () async {
                                      File? picked = await AssetService.pickMedia(true, context, false, true);
                                      if (picked != null) await ref.read(userProvider.notifier).uploadUserPicture(image: [picked], type: 'cover');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(border: Border.all(color: KColor.grey, width: 0.3), shape: BoxShape.circle),
                                      child: Icon(CupertinoIcons.camera_fill, size: 16, color: KColor.black87),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                left: 10,
                                child: SafeArea(
                                  child: Container(
                                    decoration: BoxDecoration(color: KColor.black.withOpacity(0.5), shape: BoxShape.circle),
                                    child: IconButton(
                                      padding: const EdgeInsets.only(left: 5),
                                      alignment: Alignment.center,
                                      icon: Icon(Icons.arrow_back_ios, size: 15, color: KColor.white),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(color: KColor.textBackground, borderRadius: const BorderRadius.all(Radius.circular(6))),
                          child: Column(
                            children: [
                              UserName(
                                  onTapNavigate: false,
                                  backgroundColor: KColor.textBackground,
                                  name: '${profileFeedData.basicOverView!.firstName} ${profileFeedData.basicOverView!.lastName}',
                                  textStyle: KTextStyle.headline4.copyWith(fontWeight: FontWeight.w700, color: KColor.black)),
                              SizedBox(height: KSize.getHeight(context, 8)),
                              Text(profileFeedData.basicOverView!.username!, style: KTextStyle.bodyText3.copyWith(color: KColor.black87)),
                              SizedBox(height: KSize.getHeight(context, 16)),
                              Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  height: 1,
                                  color: KColor.greyconst.withOpacity(AppMode.darkMode ? 0.5 : 0.3)),
                            ],
                          ),
                        ),
                        profileFeedData.basicOverView!.workData!.isEmpty
                            ? Container()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(color: KColor.textBackground, borderRadius: const BorderRadius.all(Radius.circular(6))),
                                child: Column(
                                  children: [
                                    Column(children: _showWorksList(profileFeedData.basicOverView!.workData!)),
                                    profileFeedData.basicOverView?.currentCity == null || profileFeedData.basicOverView?.currentCity == ""
                                        ? Container()
                                        : basicInfoWidget(
                                            "currentCity",
                                            "Lives in ",
                                            profileFeedData.basicOverView?.currentCity,
                                          ),
                                    profileFeedData.basicOverView?.currentCity == null || profileFeedData.basicOverView?.currentCity == ""
                                        ? Container()
                                        : basicInfoWidget(
                                            "homeTown",
                                            "From ",
                                            profileFeedData.basicOverView?.homeTown,
                                          ),
                                    SizedBox(height: KSize.getHeight(context, 16)),
                                  ],
                                )),
                        SizedBox(height: KSize.getHeight(context, 16)),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: KSize.getHeight(context, 60),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: profileTabs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (profileTabs[index]['title'] == 'About') {
                                    ref.read(profileAboutProvider.notifier).fetchProfileAbout(profileFeedData.basicOverView!.username!);
                                    Navigator.push(context, CupertinoPageRoute(builder: (context) => const AboutProfileScreen()));
                                  } else if (profileTabs[index]['title'] == 'Photos') {
                                    ref.read(profilePhotosProvider.notifier).fetchProfilePhotos(profileFeedData.basicOverView!.username!);
                                    Navigator.push(context, CupertinoPageRoute(builder: (context) => const ProfilePhotosScreen()));
                                  } else if (profileTabs[index]['title'] == 'Videos') {
                                    ref.read(profileVideosProvider.notifier).fetchProfileVideos(profileFeedData.basicOverView!.username!);
                                    Navigator.push(context, CupertinoPageRoute(builder: (context) => const ProfileVideosScreen()));
                                  }
                                },
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: KColor.appBackground,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: KColor.white, width: 4)),
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      children: [
                                        Icon(profileTabs[index]['icon'], size: 20, color: KColor.appThemeColor),
                                        SizedBox(width: KSize.getWidth(context, 5)),
                                        Text(profileTabs[index]['title'], style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: KSize.getHeight(context, 8)),
                        const CreateFeedCard(feedType: FeedType.PROFILE),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: profileFeedData.feedData!.isEmpty
                              ? const KContentUnvailableComponent(message: 'You haven\'t posted anything yet, why not add to your feed now?')
                              : Column(
                                  children: List.generate(profileFeedData.feedData!.length, (index) {
                                    return FeedCard(
                                      feedData: profileFeedData.feedData![index],
                                      feedType: FeedType.PROFILE,
                                      id: profileFeedData.basicOverView!.id!,
                                    );
                                  }),
                                ),
                        ),
                     //   if (profileFeedScrollState is ScrollReachedBottomState && profileFeedData.feedData!.isNotEmpty)
                        if (profileFeedScrollState is ScrollReachedBottomState)
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const CupertinoActivityIndicator(),
                          )
                      ],  
                    ),
                  ),
                ],
              )
            : const SafeArea(child: KProfileLoadingIndicator()),
      );
    });
  }

  ////////  works///////

  List<Widget> _showWorksList(List<WorkDatum> workData) {
    List<Widget> list = [];
    for (var d in workData) {
      list.add(
        basicInfoWidget(
          "work",
          d.position == null ? "" : d.position! + " at ",
          d.comapnyName ?? "",
        ),
      );
    }
    return list;
  }

  Container basicInfoWidget(name, title, subtitle) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Container(margin: const EdgeInsets.only(right: 10), child: Icon(name == "work" ? Icons.work : Icons.location_on, color: KColor.black45)),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(text: title, style: KTextStyle.subtitle2.copyWith(color: KColor.black, fontWeight: FontWeight.normal)),
                  TextSpan(text: subtitle ?? "", style: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
