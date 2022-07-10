import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/block_user/block_user_controller.dart';
import 'package:buddyscripts/controller/event/discover_events_controller.dart';
import 'package:buddyscripts/controller/event/going_events_controller.dart';
import 'package:buddyscripts/controller/event/interested_events_controller.dart';
import 'package:buddyscripts/controller/event/my_events_controller.dart';
import 'package:buddyscripts/controller/friends/friend_requests_controller.dart';
import 'package:buddyscripts/controller/group/discover_groups_controller.dart';
import 'package:buddyscripts/controller/group/joined_groups_controller.dart';
import 'package:buddyscripts/controller/group/my_groups_controller.dart';
import 'package:buddyscripts/controller/page/discover_pages_controller.dart';
import 'package:buddyscripts/controller/page/followed_pages_controller.dart';
import 'package:buddyscripts/controller/page/my_pages_controller.dart';
import 'package:buddyscripts/controller/profile/my_profile_feed_controller.dart';
import 'package:buddyscripts/controller/profile/profile_about_controller.dart';
import 'package:buddyscripts/controller/profile/state/user_profile_about_state.dart';
import 'package:buddyscripts/controller/saved_posts/saved_post_controller.dart';
import 'package:buddyscripts/main.dart';
import 'package:buddyscripts/models/profile/profile_overview_model.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/screens/account/settings/blocked_list_screen.dart';
import 'package:buddyscripts/views/screens/account/profile/work_education_screen.dart';
import 'package:buddyscripts/views/screens/account/settings/change_password_screen.dart';
import 'package:buddyscripts/views/screens/account/settings/information_settings_screen.dart';
import 'package:buddyscripts/views/screens/account/settings/newsfeed_settings_screen.dart';
import 'package:buddyscripts/views/screens/account/settings/set_theme_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/screens/account/events/events_screen.dart';
import 'package:buddyscripts/views/screens/account/friends/friend_requests_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/groups_screen.dart';
import 'package:buddyscripts/views/screens/account/pages/pages_screen.dart';
import 'package:buddyscripts/views/screens/account/profile/my_profile_screen.dart';
import 'package:buddyscripts/views/screens/account/saved_posts_screen.dart';
import 'package:buddyscripts/views/screens/account/settings/change_email/change_email_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';


class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({ Key? key }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final List menu = [
    {
      'menuTitle': 'CONTENT',
      'menuItems': [
        // {'icon': Icons.group_outlined, 'title': 'Groups'},
        // {'icon': Icons.pages_outlined, 'title': 'Pages'},
        // {'icon': Icons.event_outlined, 'title': 'Events'},
        {'icon': MaterialCommunityIcons.account_group_outline, 'title': 'People'},
        {'icon': MaterialIcons.collections_bookmark, 'title': 'Saved Posts'},
        // {'icon': Icons.campaign_outlined, 'title': 'Advertising'},
      ],
    },
    {
      'menuTitle': 'SETTINGS',
      'menuItems': [
        {'icon': Icons.settings_outlined, 'title': 'Profile Info'},
        {'icon': MaterialCommunityIcons.palette, 'title': 'Theme'},
        {'icon': Icons.work_outlined, 'title': 'Work'},
        {'icon': Icons.password_outlined, 'title': 'Password Settings'},
        {'icon': Icons.menu, 'title': 'NewsFeed'},
     //   {'icon': Icons.email_outlined, 'title': 'Email Settings'},
        {'icon': Icons.no_accounts, 'title': 'Blocked Users'},
        {'icon': Icons.delete, 'title': 'Delete Account'},
      ],
    },
    // {
    //   'menuTitle': 'POLICIES',
    //   'menuItems': [
    //     {'icon': Icons.privacy_tip_outlined, 'title': 'Privacy'},
    //     {'icon': Icons.support, 'title': 'Support'},
    //     {'icon': Icons.apartment_outlined, 'title': 'Company'},
    //     {'icon': Icons.question_answer_outlined, 'title': 'FAQ'},
    //   ],
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      // ignore: unused_local_variable
      final themeState = ref.watch(themeProvider);
      final userState = ref.watch(userProvider);
      final profileAboutState = ref.watch(profileAboutProvider);
      final ProfileOverView? profileAboutData =
          profileAboutState is ProfileAboutSuccessState ? profileAboutState.profileOverviewModel.basicOverView : null;

      return CupertinoPageScaffold(
        backgroundColor: KColor.white,
        navigationBar: KCupertinoNavBar(title: 'Account', automaticallyImplyLeading: false, hasLeading: false),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          height: KSize.getHeight(context, 125),
                          width: KSize.getWidth(context, 125),
                          decoration:
                              BoxDecoration(color: KColor.white, 
                              shape: BoxShape.circle,
                               border: Border.all(color: KColor.grey100const!.withOpacity(0.25))
                               ),
                          child: CircleAvatar(
                              backgroundImage: const AssetImage(AssetPath.profilePlaceholder),
                              foregroundImage: NetworkImage(userState is UserSuccessState ? userState.userModel.user!.profilePic! : '')),
                        ),
                        SizedBox(height: KSize.getHeight(context, 8)),
                        UserName(
                          name: userState is UserSuccessState ? '${userState.userModel.user!.firstName} ${userState.userModel.user!.lastName}' : '',
                          onTapNavigate: false,
                          textStyle: KTextStyle.headline4.copyWith(fontWeight: FontWeight.w700, color: KColor.black),
                          backgroundColor: KColor.white,
                        ),
                        SizedBox(height: KSize.getHeight(context, 6)),
                        Text(
                          userState is UserSuccessState ? userState.userModel.user!.username! : "",
                          style: KTextStyle.bodyText3.copyWith(color: KColor.black87),
                        ),
                        SizedBox(height: KSize.getHeight(context, 15)),
                        InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          onTap: () {
                            ref.read(userProvider.notifier).fetchUserData();
                            ref
                                .read(myProfileFeedProvider.notifier)
                                .fetchProfileFeed(userState is UserSuccessState ? userState.userModel.user!.username! : "");
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => const MyProfileScreen()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: KColor.primary, borderRadius: const BorderRadius.all(Radius.circular(6))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View your Profile',
                                  textAlign: TextAlign.center,
                                  style: KTextStyle.button.copyWith(color: KColor.whiteConst, height: 1),
                                ),
                                SizedBox(width: KSize.getWidth(context, 5)),
                                const Icon(Icons.keyboard_arrow_right, size: 20, color: KColor.whiteConst)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: KSize.getHeight(context, 24)),
                      ],
                    )),
                Column(
                  children: List.generate(
                    menu.length,
                    (index) {
                      return Column(
                        children: [
                          if (index == 0) SizedBox(height: KSize.getHeight(context, 12)),
                          Container(
                            color: KColor.appBackground,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Text(
                              menu[index]['menuTitle'],
                              style: KTextStyle.subtitle2.copyWith(fontWeight: FontWeight.w700, color: KColor.grey, letterSpacing: 1.2),
                            ),
                          ),
                          SizedBox(height: KSize.getHeight(context, 10)),
                          Column(
                              children: List.generate(menu[index]['menuItems'].length, (ind) {
                            return InkWell(
                              onTap: () {
                                if (menu[index]['menuItems'][ind]['title'] == 'Groups') {
                                  ref.read(joinedGroupsProvider.notifier).fetchJoinedGroupList();
                                  ref.read(myGroupsProvider.notifier).fetchMyGroupList();
                                  ref.read(discoverGroupsProvider.notifier).fetchDiscoverGroupList();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => GroupsScreen()));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'Pages') {
                                  ref.read(myPagesProvider.notifier).fetchMyPages();
                                  ref.read(discoverPagesProvider.notifier).fetchDiscoverPages();
                                  ref.read(followedPagesProvider.notifier).fetchFollowedPages();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const PagesScreen()));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'Events') {
                                  ref.read(myEventsProvider.notifier).fetchMyEvents();
                                  ref.read(goingEventsProvider.notifier).fetchGoingEvents();
                                  ref.read(interestedEventsProvider.notifier).fetchInterestedEvents();
                                  ref.read(discoverEventsProvider.notifier).fetchDiscoverEvents();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const EventsScreen()));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'People') {
                                  ref.read(friendRequestsProvider.notifier).fetchFriendRequests();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => FriendRequestsScreen()));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'Saved Posts') {
                                  ref.read(savedPostsProvider.notifier).fetchSavedPosts();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const SavedPostsScreen()));
                                }
                                // else if (menu[index]['menuItems'][ind]['title'] == 'Advertising')
                                //   Navigator.push(context, CupertinoPageRoute(builder: (context) => AdsScreen()));
                                else if (menu[index]['menuItems'][ind]['title'] == 'Password Settings') {
                                  Navigator.of(context, rootNavigator: true).push(
                                    CupertinoPageRoute(fullscreenDialog: true, builder: (context) => const ChangePasswordScreen()),
                                  );
                                } else if (menu[index]['menuItems'][ind]['title'] == 'Work') {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const WorkEducationScreen()));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'Profile Info') {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => InformationSettingsScreen(profileAboutData)));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'Theme') {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const SetThemeScreen()));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'NewsFeed') {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const NewsFeedSettingsScreen()));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'Email Settings') {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => ChangeEmailScreen(ref.read(userProvider.notifier).userData!.user!.email!)));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'Blocked Users') {
                                  ref.read(blockUserProvider.notifier).fetchBlockUser();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => BlockedListScreen()));
                                } else if (menu[index]['menuItems'][ind]['title'] == 'Delete Account') {
                                  KDialog.kShowDialog(
                                    context,
                                    ConfirmationDialogContent(
                                      title: "Delete Account",
                                      titleShow: true,
                                      titleContent:
                                          'Once you delete your account you will no longer can access it again.\nAre you sure want to delete this account?',
                                      titleColor: KColor.primary,
                                      onPressedCallback: () => {
                                        Navigator.pop(context),
                                        KDialog.kShowDialog(
                                          context,
                                          const ProcessingDialogContent("Processing..."),
                                          barrierDismissible: false,
                                        ),
                                        ref.read(userProvider.notifier).deleteAccount()
                                      },
                                    ),
                                    useRootNavigator: false,
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(menu[index]['menuItems'][ind]['icon'], color: KColor.black.withOpacity(0.7)),
                                        SizedBox(width: KSize.getWidth(context, 10)),
                                        Expanded(
                                          child: Text(menu[index]['menuItems'][ind]['title'],
                                              style: KTextStyle.subtitle2.copyWith(fontSize: 16, color: KColor.black.withOpacity(0.75))),
                                        ),
                                        Icon(Icons.keyboard_arrow_right, color: KColor.black)
                                      ],
                                    ),
                                    SizedBox(height: KSize.getHeight(context, 10)),
                                  ],
                                ),
                              ),
                            );
                          })),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(height: KSize.getHeight(context, 12)),
                      TextButton(
                        onPressed: () {
                          _logoutConfirmationDialog();
                        },
                        style: TextButton.styleFrom(primary: KColor.buttonBackground),
                        child: Text(
                          'LOG OUT',
                          style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w700, color: KColor.primary, letterSpacing: 1.2),
                        ),
                      ),
                      SizedBox(height: KSize.getHeight(context, 24)),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }

  _logoutConfirmationDialog() async {
    return (await showPlatformDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) => ConfirmationDialogContent(
          titleContent: 'Are you sure you want to log out of this app?',
          onPressedCallback: () {
            Navigator.pop(context);
            KDialog.kShowDialog(context, const ProcessingDialogContent('Logging out...'), barrierDismissible: false);
            ref.read(userProvider.notifier).logout();
          }),
    ));
  }
}
