import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/block_user/block_user_controller.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/friends/friend_requests_controller.dart';
import 'package:buddyscripts/controller/pagination/profile/profile_feed_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/user_profile_feed_controller.dart';
import 'package:buddyscripts/controller/profile/profile_photos_controller.dart';
import 'package:buddyscripts/controller/profile/profile_videos_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_feed_state.dart';
import 'package:buddyscripts/models/chats/conversations_model.dart';
import 'package:buddyscripts/models/profile/profile_feed_model.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_image_view.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_profile_loading_indicator.dart';
import 'package:buddyscripts/views/screens/account/profile/profile_photos_screen.dart';
import 'package:buddyscripts/views/screens/account/profile/profile_videos_screen.dart';
import 'package:buddyscripts/views/screens/home/report_feed_screen.dart';
import 'package:buddyscripts/views/screens/messages/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/screens/account/profile/about_profile_screen.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List profileTabs = [
    {'icon': Icons.person, 'title': 'About'},
    {'icon': Icons.photo_library, 'title': 'Photos'},
    {'icon': Icons.video_collection, 'title': 'Videos'},
  ];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final profileFeedState = ref.watch(userProfileFeedProvider);
      final profileFeedScrollState = ref.watch(profileFeedScrollProvider);
      ProfileFeedModel? profileFeedData = profileFeedState is UserProfileFeedSuccessState ? profileFeedState.profileFeedModel : null;

      ref.listen(profileFeedScrollProvider, (_, state) {
        if (state is ScrollReachedBottomState) {
          if (profileFeedData!.feedData!.isNotEmpty) {
            ref.read(userProfileFeedProvider.notifier).fetchMoreProfileFeed(profileFeedData.basicOverView!.username!);
          }
        }
      });

      return Container(
        color: KColor.darkAppBackground,
        child: profileFeedState is UserProfileFeedLoadingState
            ? const SafeArea(child: KProfileLoadingIndicator())
            : profileFeedData == null
                ? const KContentUnvailableComponent(message: 'User not found!', isUnavailablePage: true)
                : CustomScrollView(
                    controller: ref.read(profileFeedScrollProvider.notifier).controller,
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      CupertinoSliverRefreshControl(onRefresh: () {
                        return ref.read(userProfileFeedProvider.notifier).fetchProfileFeed(profileFeedData.basicOverView!.username!);
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
                                          .push(CupertinoPageRoute(builder: (context) => KImageView(url: profileFeedData.basicOverView!.cover!)));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.035),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                        child: Image.network(
                                          profileFeedData.basicOverView!.cover!,
                                          height: MediaQuery.of(context).size.height * 0.34,
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    left: 8,
                                    child: SafeArea(
                                      child: Container(
                                        decoration: BoxDecoration(color: KColor.black.withOpacity(0.5), shape: BoxShape.circle),
                                        child: IconButton(
                                          padding: const EdgeInsets.only(left: 5),
                                          icon: Icon(Icons.arrow_back_ios, size: 18, color: KColor.white),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: (MediaQuery.of(context).size.width * 0.5) - KSize.getWidth(context, 51),
                                    child: InkWell(
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
                                          border: Border.all(color: AppMode.darkMode ? KColor.appBackground : KColor.white, width: 3),
                                          image: DecorationImage(image: NetworkImage(profileFeedData.basicOverView!.profilePic!)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: KColor.textBackground,
                              child: Column(
                                children: [
                                  SizedBox(height: KSize.getHeight(context, 7)),
                                  UserName(
                                      onTapNavigate: false,
                                      backgroundColor: KColor.textBackground,
                                      name: '${profileFeedData.basicOverView!.firstName} ${profileFeedData.basicOverView!.lastName}',
                                      textStyle: KTextStyle.headline4.copyWith(fontWeight: FontWeight.w700, color: KColor.black)),
                                  SizedBox(height: KSize.getHeight(context, 8)),
                                  Text(profileFeedData.basicOverView!.username ?? '', style: KTextStyle.bodyText3.copyWith(color: KColor.black87)),
                                  SizedBox(height: KSize.getHeight(context, 16)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: KButton(
                                            title: isLoading
                                                ? "Please wait..."
                                                : profileFeedData.basicOverView?.friend == null
                                                    ? "Add Friend"
                                                    : profileFeedData.basicOverView?.friend!.status == "accepted"
                                                        ? "Unfriend"
                                                        : profileFeedData.basicOverView?.friend!.status == "pending"
                                                            ? "Cancel Request"
                                                            : profileFeedData.basicOverView?.friend!.status == "waiting"
                                                                ? "Accept Request"
                                                                : "",
                                            color: isLoading ? KColor.grey : KColor.appThemeColor,
                                            innerPadding: 10,
                                            leadingTitleIcon: Icon(
                                              isLoading
                                                  ? null
                                                  : profileFeedData.basicOverView?.friend == null
                                                      ? Ionicons.ios_person_add
                                                      : profileFeedData.basicOverView?.friend!.status == "accepted"
                                                          ? Icons.person_outlined
                                                          : profileFeedData.basicOverView?.friend?.status == "pending"
                                                              ? Icons.person_add_disabled
                                                              : profileFeedData.basicOverView?.friend?.status == "waiting"
                                                                  ? Ionicons.ios_person_add
                                                                  : null,
                                              color: KColor.whiteConst,
                                            ),
                                            onPressedCallback: isLoading
                                                ? null
                                                : () async {
                                                    if (!mounted) return;
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    if (profileFeedData.basicOverView!.friend == null) {
                                                      await ref.read(friendRequestsProvider.notifier).addFriend(profileFeedData.basicOverView);
                                                    } else if (profileFeedData.basicOverView!.friend!.status == "accepted") {
                                                      await ref.read(friendRequestsProvider.notifier).unfriend(profileFeedData.basicOverView);
                                                    } else if (profileFeedData.basicOverView!.friend!.status == "pending") {
                                                      await ref.read(friendRequestsProvider.notifier).unfriend(profileFeedData.basicOverView);
                                                    } else if (profileFeedData.basicOverView!.friend!.status == "waiting") {
                                                      await ref.read(friendRequestsProvider.notifier).acceptRequest(
                                                            friendId: profileFeedData.basicOverView!.id,
                                                            friendOverview: profileFeedData.basicOverView,
                                                          );
                                                    } else {}

                                                    if (!mounted) return;
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  },
                                          ),
                                        ),
                                        SizedBox(width: KSize.getWidth(context, 8)),
                                        InkWell(
                                          onTap: () {
                                            // ref.read(chatProvider.notifier).fetchChat(
                                            //     id: profileFeedData.basicOverView!.id, group: 0, onlineChat: profileFeedData.basicOverView!.isOnline);
                                            // Navigator.push(
                                            //     context,
                                            //     CupertinoPageRoute(
                                            //         builder: (context) => ChatScreen(
                                            //               id: profileFeedData.basicOverView!.id,
                                            //               firstName: profileFeedData.basicOverView!.firstName,
                                            //               lastName: profileFeedData.basicOverView!.lastName,
                                            //               userName: profileFeedData.basicOverView!.username,
                                            //               profilePic: profileFeedData.basicOverView!.profilePic,
                                            //               conversation: ConversationsModel(isGroup: 0),
                                            //             )));
                                          },
                                          child: Container(
                                            height: KSize.getHeight(context, 45),
                                            width: KSize.getWidth(context, 48),
                                            decoration: BoxDecoration(
                                                color: KColor.darkAppBackground,
                                                border: Border.all(color: KColor.black87, width: 0.1),
                                                borderRadius: BorderRadius.circular(6)),
                                            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                                            child: Image.asset(AppMode.darkMode ? AssetPath.messageIcon : AssetPath.messageFillIcon,
                                                color: AppMode.darkMode ? KColor.whiteConst : null, height: 25, width: 25),
                                          ),
                                        ),
                                        SizedBox(width: KSize.getWidth(context, 8)),
                                        Container(
                                          height: KSize.getHeight(context, 45),
                                          width: KSize.getWidth(context, 48),
                                          decoration: BoxDecoration(
                                              color: KColor.darkAppBackground,
                                              border: Border.all(color: KColor.black87, width: 0.1),
                                              borderRadius: BorderRadius.circular(6)),
                                          child: PopupMenuButton(
                                            tooltip: '',
                                            onSelected: (selected) {
                                              if (selected == 'report') {
                                                Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                                                    builder: (context) => ReportFeedScreen(profileFeedData.basicOverView, "profile")));
                                              }

                                              if (selected == 'block') {
                                                KDialog.kShowDialog(
                                                    context,
                                                    ConfirmationDialogContent(
                                                        titleShow: true,
                                                        titleColor: KColor.primary,
                                                        title:
                                                            "Block ${profileFeedData.basicOverView!.firstName} ${profileFeedData.basicOverView!.lastName}?",
                                                        titleContent:
                                                            '${profileFeedData.basicOverView!.firstName} ${profileFeedData.basicOverView!.lastName} will no longer be able to:\n\n • See your posts on your timeline\n • Tag you\n • Invite you to events or groups\n • Message you\n • Add you as a friend\n\nIf you\'re friends, blocking ${profileFeedData.basicOverView!.firstName} ${profileFeedData.basicOverView!.lastName} will also unfriend him/her',
                                                        buttonTextYes: "Block",
                                                        buttonTextNo: "Cancel",
                                                        onPressedCallback: () => {
                                                              Navigator.pop(context),
                                                              KDialog.kShowDialog(
                                                                context,
                                                                const ProcessingDialogContent("Processing..."),
                                                                barrierDismissible: false,
                                                              ),
                                                              ref.read(blockUserProvider.notifier).block(profileFeedData.basicOverView!.id)
                                                            }),
                                                    useRootNavigator: false);
                                              }
                                            },
                                            color: AppMode.darkMode ? KColor.feedActionCircle : KColor.appBackground,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                            ),
                                            icon: Icon(MaterialIcons.more_horiz, color: KColor.black87),
                                            itemBuilder: (_) => <PopupMenuItem<String>>[
                                              PopupMenuItem<String>(
                                                  value: "report",
                                                  child: Text(
                                                    'Report',
                                                    style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                                  )),
                                              PopupMenuItem<String>(
                                                  value: "block",
                                                  child: Text(
                                                    'Block',
                                                    style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: KSize.getHeight(context, 10)),
                                  if (profileFeedData.basicOverView!.workData!.isNotEmpty &&
                                      profileFeedData.basicOverView?.currentCity == null &&
                                      profileFeedData.basicOverView?.homeTown == null)
                                    Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        height: 1,
                                        color: KColor.greyconst.withOpacity(AppMode.darkMode ? 0.5 : 0.3)),
                                  SizedBox(height: KSize.getHeight(context, 8)),
                                ],
                              ),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                              ),
                              decoration: BoxDecoration(color: KColor.textBackground, borderRadius: const BorderRadius.all(Radius.circular(6))),
                              child: Column(
                                children: [
                                  profileFeedData.basicOverView!.workData!.isEmpty
                                      ? Container()
                                      : Column(children: _showWorksList(profileFeedData.basicOverView!.workData!)),
                                  profileFeedData.basicOverView?.currentCity == null || profileFeedData.basicOverView?.currentCity == ""
                                      ? Container()
                                      : basicInfoWidget(
                                          "currentCity",
                                          "Lives in ",
                                          profileFeedData.basicOverView!.currentCity,
                                        ),
                                  profileFeedData.basicOverView?.homeTown == null || profileFeedData.basicOverView?.homeTown == ""
                                      ? Container()
                                      : basicInfoWidget(
                                          "homeTown",
                                          "From ",
                                          profileFeedData.basicOverView!.homeTown,
                                        ),
                                  SizedBox(height: KSize.getHeight(context, 16)),
                                ],
                              ),
                            ),
                            SizedBox(height: KSize.getHeight(context, 8)),

                            Container(
                              margin: const EdgeInsets.only(top: 5),
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
                            //  SizedBox(height: KSize.getHeight(context, 8)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: profileFeedData.feedData!.isEmpty
                                  ? const KContentUnvailableComponent(message: 'No posts found! Keep checking back later!')
                                  : Column(
                                      children: List.generate(profileFeedData.feedData!.length, (index) {
                                        return Hero(
                                            tag: index, child: FeedCard(feedData: profileFeedData.feedData![index], feedType: FeedType.PROFILE));
                                      }),
                                    ),
                            ),
                            if (profileFeedScrollState is ScrollReachedBottomState && profileFeedData.feedData!.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: const CupertinoActivityIndicator(),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
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
