import 'dart:io';

import 'package:buddyscripts/controller/country/country_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/group/group_about_controller.dart';
import 'package:buddyscripts/controller/group/group_controller.dart';
import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/controller/group/group_invite_member_controller.dart';
import 'package:buddyscripts/controller/group/group_members_controller.dart';
import 'package:buddyscripts/controller/group/group_pending_member_controller.dart';
import 'package:buddyscripts/controller/group/group_photos_controller.dart';
import 'package:buddyscripts/controller/group/group_videos_controller.dart';
import 'package:buddyscripts/controller/group/state/group_feed_state.dart';
import 'package:buddyscripts/controller/group/state/group_state.dart';
import 'package:buddyscripts/controller/pagination/group/group_feed_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/models/group/group_feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/views/global_components/create_feed_card.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_image_view.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_profile_loading_indicator.dart';
import 'package:buddyscripts/views/screens/account/groups/edit_group_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/group_invite_member_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/group_members_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/group_pending_members_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/group_photos_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/group_videos_screen.dart';
import 'package:buddyscripts/views/screens/home/report_feed_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/screens/account/groups/group_about_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class GroupDetailsScreen extends ConsumerWidget {
  List groupTabs = [
    {'icon': Icons.people, 'title': 'Members'},
    {'icon': Icons.people, 'title': 'Pending Members'},
    {'icon': Icons.photo_library, 'title': 'Photos'},
    {'icon': Icons.video_collection, 'title': 'Videos'},
  ];
  double? top;

  GroupDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupFeedState = ref.watch(groupFeedProvider);
    final groupState = ref.watch(groupProvider);
    final groupFeedScrollState = ref.watch(groupFeedScrollProvider);
    GroupFeedModel? groupFeedData = groupFeedState is GroupFeedSuccessState ? groupFeedState.groupFeedModel : null;

    ref.listen(countryProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        if (ref.read(groupFeedProvider.notifier).groupFeedList!.feedData!.isNotEmpty) {
          ref.read(groupFeedProvider.notifier).fetchMoreGroupFeed(groupFeedData!.basicOverView!.slug!);
        }
      }
    });

    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: groupFeedData == null && groupFeedState is! GroupFeedLoadingState ? KCupertinoNavBar() : null,
      child: groupFeedState is GroupFeedLoadingState
          ? const KProfileLoadingIndicator()
          : groupFeedData == null
              ? const KContentUnvailableComponent(message: 'Group not found!', isUnavailablePage: true)
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  controller: ref.read(groupFeedScrollProvider.notifier).controller,
                  slivers: [
                    CupertinoSliverRefreshControl(onRefresh: () {
                      return ref.read(groupFeedProvider.notifier).fetchGroupFeed(groupFeedData.basicOverView!.slug!);
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
                      elevation: 1,
                      expandedHeight: MediaQuery.of(context).size.height * 0.345,
                      flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                        print('constraints=' + constraints.toString());
                        top = constraints.biggest.height;
                        return FlexibleSpaceBar(
                          collapseMode: CollapseMode.none,
                          centerTitle: true,
                          title: Text(
                            top! <= 80 ? '${groupFeedData.basicOverView!.groupName}' : "",
                            style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.whiteConst),
                          ),
                          background: Container(
                            color: KColor.white,
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(CupertinoPageRoute(builder: (context) => KImageView(url: groupFeedData.basicOverView!.cover)));
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                    child: Image.network(
                                      API.baseUrl+groupFeedData.basicOverView!.cover!,
                                      height: MediaQuery.of(context).size.height * 0.345,
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
                                        icon: const Icon(Icons.arrow_back_ios, size: 18, color: KColor.whiteConst),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                  ),
                                ),
                                //   if (!AppMode.DIVINE9)
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
                                              // context.read(groupCategoryProvider).fetchGroupCategory();
                                              ref.read(countryProvider.notifier).fetchCountries();
                                              Navigator.of(context, rootNavigator: true).push(
                                                CupertinoPageRoute(
                                                    fullscreenDialog: true, builder: (context) => EditGroupScreen(groupFeedData.basicOverView)),
                                              );
                                            } else if (selected == 'delete') {
                                              KDialog.kShowDialog(
                                                  context,
                                                  ConfirmationDialogContent(
                                                      titleContent: 'Are you sure want to delete this group?',
                                                      onPressedCallback: () async => {
                                                            Navigator.pop(context),
                                                            KDialog.kShowDialog(context, const ProcessingDialogContent("Processing..."),
                                                                barrierDismissible: false, useRootNavigator: true),
                                                            await ref.read(groupProvider.notifier).deleteGroup(groupFeedData.basicOverView!.id!),
                                                            Navigator.pop(context),
                                                          }),
                                                  useRootNavigator: false);
                                            } else if (selected == 'report') {
                                              Navigator.of(context, rootNavigator: true).push(
                                                  CupertinoPageRoute(builder: (context) => ReportFeedScreen(groupFeedData.basicOverView, "group")));
                                            }
                                          },
                                          color: AppMode.darkMode ? KColor.feedActionCircle : KColor.appBackground,
                                          icon: const Icon(MaterialIcons.more_vert, size: 18, color: KColor.whiteConst),
                                          itemBuilder: (_) {
                                            return groupFeedData.basicOverView?.isMember != null &&
                                                    groupFeedData.basicOverView?.isMember?.isAdmin == 'super admin'
                                                ? <PopupMenuItem<String>>[
                                                    PopupMenuItem<String>(
                                                        value: "edit",
                                                        child: Text(
                                                          'Edit',
                                                          style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                                        )),
                                                    PopupMenuItem<String>(
                                                        value: "delete",
                                                        child: Text(
                                                          'Delete',
                                                          style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                                        )),
                                                    PopupMenuItem<String>(
                                                        value: "report",
                                                        child: Text(
                                                          'Report',
                                                          style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                                        )),
                                                  ]
                                                : <PopupMenuItem<String>>[
                                                    PopupMenuItem<String>(
                                                        value: "report",
                                                        child: Text(
                                                          'Report',
                                                          style: KTextStyle.subtitle2.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
                                                        )),
                                                  ];
                                          }),
                                    ),
                                  ),
                                ),
                                if (groupFeedData.basicOverView?.isMember != null && groupFeedData.basicOverView?.isMember?.isAdmin == 'super admin')
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
                                            await ref.read(groupProvider.notifier).uploadGroupPicture(
                                              image: [picked],
                                              groupId: groupFeedData.basicOverView!.id,
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
                              Material(
                                child: InkWell(
                                  onTap: () {
                                    ref.read(groupAboutProvider.notifier).fetchGroupAbout(groupFeedData.basicOverView!.slug!);
                                    Navigator.push(context, CupertinoPageRoute(builder: (context) => GroupAboutScreen()));
                                  },
                                  child: Ink(
                                    color: KColor.white,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                                child: Text(groupFeedData.basicOverView!.groupName ?? '',
                                                    style: KTextStyle.headline4.copyWith(color: KColor.black, fontWeight: FontWeight.w700))),
                                            Icon(Icons.keyboard_arrow_right, color: KColor.black87),
                                          ],
                                        ),
                                        SizedBox(height: KSize.getHeight(context, 8)),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                                groupFeedData.basicOverView?.groupPrivacy == 'PRIVATE' ||
                                                        groupFeedData.basicOverView?.groupPrivacy == 'ONLY ME'
                                                    ? Icons.lock
                                                    : Icons.public,
                                                size: 15,
                                                color: KColor.black54),
                                            SizedBox(width: KSize.getWidth(context, 5)),
                                            Text(
                                                groupFeedData.basicOverView?.groupPrivacy == 'PRIVATE' ||
                                                        groupFeedData.basicOverView?.groupPrivacy == 'ONLY ME'
                                                    ? 'Private Group'
                                                    : 'Public Group',
                                                style: KTextStyle.subtitle2.copyWith(color: KColor.black54)),
                                            SizedBox(width: KSize.getWidth(context, 5)),
                                            Icon(Icons.circle, size: 4, color: KColor.black54),
                                            SizedBox(width: KSize.getWidth(context, 5)),
                                            Text(
                                                groupFeedData.basicOverView!.totalMembers! > 1
                                                    ? '${groupFeedData.basicOverView?.totalMembers} members'
                                                    : '${groupFeedData.basicOverView?.totalMembers} member',
                                                style: KTextStyle.subtitle2.copyWith(color: KColor.black54)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: KSize.getHeight(context, 20)),
                              Row(
                                children: [
                                  Expanded(
                                    child: KButton(
                                      title: groupState is GroupLoadingState
                                          ? "Please wait..."
                                          : groupFeedData.basicOverView!.isMember != null
                                              ? 'Leave Group'
                                              : groupFeedData.basicOverView!.isRequested != null
                                                  ? 'Cancel Request'
                                                  : 'Join Group',
                                      color: groupState is GroupLoadingState ? KColor.grey : KColor.buttonBackground,
                                      innerPadding: 10,
                                      leadingTitleIcon: groupFeedData.basicOverView!.isMember != null
                                          ? const Icon(Icons.no_accounts, color: KColor.whiteConst)
                                          : null,
                                      onPressedCallback: () {
                                        if (groupFeedData.basicOverView!.isMember != null &&
                                            groupFeedData.basicOverView!.isMember?.isAdmin == "super admin") {
                                          KDialog.kShowDialog(
                                              context,
                                              ConfirmationDialogContent(
                                                  titleContent:
                                                      'If you leave this group then the group will be deleted.Are you sure you want to leave this group?',
                                                  onPressedCallback: () async {
                                                    Navigator.pop(context);
                                                    KDialog.kShowDialog(
                                                      context,
                                                      const ProcessingDialogContent("Processing..."),
                                                      barrierDismissible: false,
                                                    );
                                                    await ref.read(groupProvider.notifier).deleteGroup(groupFeedData.basicOverView!.id!);
                                                    Navigator.pop(context);
                                                  }),
                                              useRootNavigator: false);
                                        } else if (groupFeedData.basicOverView?.isRequested != null) {
                                          if (groupState is! GroupLoadingState) {
                                            ref.read(groupProvider.notifier).cancelRequest(groupData: groupFeedData.basicOverView);
                                          }
                                        } else {
                                          if (groupState is! GroupLoadingState) {
                                            groupFeedData.basicOverView!.isMember != null
                                                ? ref.read(groupProvider.notifier).leaveGroup(
                                                    groupData: groupFeedData.basicOverView,
                                                    groupType: groupFeedData.basicOverView!.isMember?.isAdmin == "admin"
                                                        ? GroupType.MYGROUP
                                                        : GroupType.JOINED)
                                                : ref
                                                    .read(groupProvider.notifier)
                                                    .joinGroup(groupData: groupFeedData.basicOverView, groupType: GroupType.DISCOVER);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  if (groupFeedData.basicOverView!.isMember != null)
                                    Visibility(
                                      visible: groupFeedData.basicOverView!.isMember?.isAdmin == "admin" ||
                                          groupFeedData.basicOverView!.isMember?.isAdmin == "super admin",
                                      child: Container(
                                        margin: EdgeInsets.only(left: KSize.getWidth(context, 8)),
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        child: KButton(
                                          isOutlineButton: false,
                                          textColor: KColor.whiteConst,
                                          innerPadding: 9.5,
                                          title: 'Add Member',
                                          leadingTitleIcon: const Icon(Icons.group_add, color: KColor.whiteConst),
                                          onPressedCallback: () {
                                            ref.read(groupInviteMemberProvider.notifier).fetchSuggestedMembers(groupFeedData.basicOverView!.id!);
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) => GroupInviteMembersScreen(groupId: groupFeedData.basicOverView!.id!)));
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: KSize.getHeight(context, 16)),
                            ],
                          ),
                        ),
                        SizedBox(height: KSize.getHeight(context, 10)),
                        if (groupFeedData.basicOverView!.isMember != null)
                          Container(
                            color: KColor.darkAppBackground,
                            width: MediaQuery.of(context).size.width,
                            height: KSize.getHeight(context, 80),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: groupTabs.length,
                              itemBuilder: (context, index) {
                                bool admin = false;

                                if (groupFeedData.basicOverView!.isMember?.isAdmin == "admin" ||
                                    groupFeedData.basicOverView!.isMember?.isAdmin == "super admin") {
                                  admin = true;
                                }
                                return (!admin && index == 1)
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          if (groupTabs[index]['title'] == 'Members') {
                                            ref.read(groupMembersProvider.notifier).fetchGroupMembers(groupFeedData.basicOverView!.slug!);
                                            Navigator.push(context, CupertinoPageRoute(builder: (context) => GroupMembersScreen()));
                                          } else if (groupTabs[index]['title'] == 'Pending Members') {
                                            ref.read(groupPendingMemberProvider.notifier).fetchGroupPendingMember(groupFeedData.basicOverView!.id);
                                            Navigator.push(context, CupertinoPageRoute(builder: (context) => const GroupPendingMemberScreen()));
                                          } else if (groupTabs[index]['title'] == 'Photos') {
                                            ref.read(groupPhotosProvider.notifier).fetchGroupPhotos(groupFeedData.basicOverView!.slug!);
                                            Navigator.push(context, CupertinoPageRoute(builder: (context) => const GroupPhotosScreen()));
                                          } else if (groupTabs[index]['title'] == 'Videos') {
                                            ref.read(groupVideosProvider.notifier).fetchGroupVideos(groupFeedData.basicOverView!.slug!);
                                            Navigator.push(context, CupertinoPageRoute(builder: (context) => const GroupVideosScreen()));
                                          }
                                        },
                                        child: Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: KColor.textBackground,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: KColor.white, width: 4)),
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Row(
                                              children: [
                                                Icon(groupTabs[index]['icon'], size: 20, color: KColor.primary),
                                                SizedBox(width: KSize.getWidth(context, 5)),
                                                Text(groupTabs[index]['title'], style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                        if (groupFeedData.basicOverView!.isMember != null)
                          CreateFeedCard(feedType: FeedType.GROUP, id: groupFeedData.basicOverView!.id),
                        Container(color: KColor.darkAppBackground, height: 10),
                      ],
                    )),
                    if ((groupFeedData.basicOverView!.groupPrivacy != 'ONLY ME' || groupFeedData.basicOverView!.isMember != null))
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        sliver: groupFeedData.feedData!.isEmpty
                            ? const SliverToBoxAdapter(
                                child: KContentUnvailableComponent(message: 'End of feed! Keep checking back later!'),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) => Hero(
                                        tag: index,
                                        child: FeedCard(
                                          feedData: groupFeedData.feedData![index],
                                          feedType: FeedType.GROUP,
                                          id: groupFeedData.basicOverView!.id!,
                                        )),
                                    childCount: groupFeedData.feedData!.length),
                              ),
                      ),
                    if (groupFeedScrollState is ScrollReachedBottomState && ref.read(groupFeedProvider.notifier).groupFeedList!.feedData!.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const CupertinoActivityIndicator(),
                        ),
                      ),
                  ],
                ),
    );
  }
}
