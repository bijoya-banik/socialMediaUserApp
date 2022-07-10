import 'dart:io';
import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/event/event_about_controller.dart';
import 'package:buddyscripts/controller/event/event_feed_controller.dart';
import 'package:buddyscripts/controller/event/event_photos_controller.dart';
import 'package:buddyscripts/controller/event/event_videos_controller.dart';
import 'package:buddyscripts/controller/event/invite_member_controller.dart';
import 'package:buddyscripts/controller/event/my_events_controller.dart';
import 'package:buddyscripts/controller/event/state/event_feed_state.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/pagination/event/event_feed_tab.dart';
import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:buddyscripts/models/auth/user_model.dart';
import 'package:buddyscripts/models/event/event_feed_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/global_components/create_feed_card.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_image_view.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_profile_loading_indicator.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/account/events/create_event_screen.dart';
import 'package:buddyscripts/views/screens/account/events/event_photos_screen.dart';
import 'package:buddyscripts/views/screens/account/events/event_videos_screen.dart';
import 'package:buddyscripts/views/screens/home/report_feed_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/screens/account/components/event_options_modal.dart';
import 'package:buddyscripts/views/screens/account/events/event_about_screen.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/screens/account/groups/invite_members_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class EventDetailsScreen extends ConsumerWidget {
  EventDetailsScreen({Key? key}) : super(key: key);

  List eventTabs = [
    {'icon': Icons.photo_library, 'title': 'Photos'},
    {'icon': Icons.video_collection, 'title': 'Videos'},
  ];
  double top = 0.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final eventFeedState = ref.watch(eventFeedProvider);
    final eventFeedScrollState = ref.watch(eventFeedScrollProvider);

    User? userData = userState is UserSuccessState ? userState.userModel.user : null;
    EventFeedModel? eventFeedData = eventFeedState is EventFeedSuccessState ? eventFeedState.eventFeedModel : null;

    ref.listen(eventFeedScrollProvider, (_, state) {
      if (state is ScrollReachedBottomState) {
        print('reached bottom');
        ref.read(eventFeedProvider.notifier).fetchMoreEventFeed(eventFeedData!.basicOverView!.slug!);
      }
    });

    return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: eventFeedData == null ? KCupertinoNavBar() : null,
        child: eventFeedState is EventFeedLoadingState
            ? const KProfileLoadingIndicator()
            : eventFeedData == null
                ? const KContentUnvailableComponent(message: 'Event not found!', isUnavailablePage: true)
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    controller: ref.read(eventFeedScrollProvider.notifier).controller,
                    slivers: [
                        CupertinoSliverRefreshControl(onRefresh: () {
                          return ref.read(eventFeedProvider.notifier).fetchEventFeed(eventFeedData.basicOverView!.slug!);
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
                                top <= 80 ? '${eventFeedData.basicOverView!.eventName}' : "",
                                style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.whiteConst),
                              ),
                              background: Container(
                                color: KColor.white,
                                height: MediaQuery.of(context).size.height * 0.345,
                                child: Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(CupertinoPageRoute(builder: (context) => KImageView(url: eventFeedData.basicOverView!.cover!)));
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                        child: Image.network(
                                          eventFeedData.basicOverView!.cover!,
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
                                          decoration: BoxDecoration(color: KColor.blackConst.withOpacity(0.4), shape: BoxShape.circle),
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_back_ios, size: 18, color: KColor.white),
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
                                                  Navigator.of(context, rootNavigator: true).push(
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            CreateEventScreen(eventData: eventFeedData.basicOverView, isEdit: true)),
                                                  );
                                                } else if (selected == 'delete') {
                                                  KDialog.kShowDialog(
                                                      context,
                                                      ConfirmationDialogContent(
                                                          titleContent: 'Are you sure want to delete this event?',
                                                          onPressedCallback: () async => {
                                                                Navigator.pop(context),
                                                                KDialog.kShowDialog(
                                                                  context,
                                                                  const ProcessingDialogContent("Processing..."),
                                                                  barrierDismissible: false,
                                                                ),
                                                                await ref
                                                                    .read(myEventsProvider.notifier)
                                                                    .deleteEvent(eventFeedData.basicOverView!.id!),
                                                                Navigator.pop(context),
                                                              }),
                                                      useRootNavigator: false);
                                                } else if (selected == 'report') {
                                                  Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                                                      builder: (context) => ReportFeedScreen(eventFeedData.basicOverView, "event")));
                                                }
                                              },
                                              color: AppMode.darkMode ? KColor.feedActionCircle : KColor.appBackground,
                                              icon: const Icon(MaterialIcons.more_vert, size: 18, color: KColor.whiteConst),
                                              itemBuilder: (_) {
                                                return eventFeedData.basicOverView!.userId == getIntAsync(USER_ID)
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
                                                        PopupMenuItem<String>(
                                                            value: "report",
                                                            child: Text(
                                                              'Report',
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
                                    if (eventFeedData.basicOverView!.userId == getIntAsync(USER_ID))
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
                                                await ref.read(eventFeedProvider.notifier).uploadEventCover(
                                                  image: [picked],
                                                  eventId: eventFeedData.basicOverView!.id,
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
                                        ref.read(eventAboutProvider.notifier).fetchEventAbout(eventFeedData.basicOverView!.slug!);
                                        Navigator.push(context, CupertinoPageRoute(builder: (context) => const EventAboutScreen()));
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
                                                    child: Text('${eventFeedData.basicOverView!.eventName}',
                                                        style: KTextStyle.headline4.copyWith(color: KColor.black, fontWeight: FontWeight.w700))),
                                                Icon(Icons.keyboard_arrow_right, color: KColor.black87),
                                              ],
                                            ),
                                            SizedBox(height: KSize.getHeight(context, 8)),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${eventFeedData.basicOverView!.address}',
                                                    style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: KSize.getHeight(context, 8)),
                                            Wrap(
                                              alignment: WrapAlignment.start,
                                              children: [
                                                Icon(Icons.schedule, size: 16, color: KColor.black87),
                                                SizedBox(width: KSize.getWidth(context, 3)),
                                                Text(
                                                  DateTimeService.convert(eventFeedData.basicOverView!.startTime.toString(), isDateWithTime: true) ??
                                                      '',
                                                  style: KTextStyle.subtitle2.copyWith(color: KColor.black87),
                                                ),
                                                SizedBox(width: KSize.getWidth(context, 5)),
                                                Icon(Icons.remove, size: 16, color: KColor.black87),
                                                SizedBox(width: KSize.getWidth(context, 5)),
                                                Text(
                                                  DateTimeService.convert(eventFeedData.basicOverView!.endTime.toString(), isDateWithTime: true) ??
                                                      '',
                                                  style: KTextStyle.subtitle2.copyWith(color: KColor.black87),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: KSize.getHeight(context, 20)),
                                  if (eventFeedData.isGoing != null && eventFeedData.isGoing!.status == 'invited')
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            elevation: 5,
                                            isScrollControlled: true,
                                            useRootNavigator: true,
                                            backgroundColor: KColor.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                                            ),
                                            builder: (context) {
                                              return EventOptionsModal(eventFeedData.isGoing);
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppMode.darkMode ? KColor.grey850const : const Color(0xffE5E5E5),
                                            borderRadius: BorderRadius.circular(6)),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            UserProfilePicture(
                                              profileURL: eventFeedData.isGoing!.fromUser!.profilePic,
                                              onTapNavigate: false,
                                              avatarRadius: 20,
                                            ),
                                            const SizedBox(width: 5),
                                            Flexible(
                                                child: Text(
                                                    "${eventFeedData.isGoing!.fromUser!.firstName} ${eventFeedData.isGoing!.fromUser!.lastName} invited you to this event",
                                                    style: KTextStyle.bodyText1.copyWith(color: KColor.black)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (eventFeedData.isGoing != null && eventFeedData.isGoing!.status == 'invited')
                                    SizedBox(height: KSize.getHeight(context, 20)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: KButton(
                                          title: eventFeedData.isGoing == null
                                              ? 'Not Interested'
                                              : eventFeedData.isGoing!.status == 'interested'
                                                  ? 'Interested'
                                                  : eventFeedData.isGoing!.status == 'going'
                                                      ? 'Going'
                                                      : 'Not Interested',
                                          textColor: KColor.whiteConst,
                                          innerPadding: 10,
                                          leadingTitleIcon: Icon(
                                            eventFeedData.isGoing == null || eventFeedData.isGoing!.status == ""
                                                ? FontAwesome5.times_circle
                                                : eventFeedData.isGoing!.status == 'interested'
                                                    ? FontAwesome5.star
                                                    : FontAwesome5.check_circle,
                                            size: 18,
                                            color: KColor.whiteConst,
                                          ),
                                          trailingTitleIcon: const Icon(FontAwesome.caret_down, size: 18, color: KColor.whiteConst),
                                          onPressedCallback: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isDismissible: true,
                                                elevation: 5,
                                                isScrollControlled: true,
                                                useRootNavigator: true,
                                                backgroundColor: KColor.white,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18))),
                                                builder: (context) => EventOptionsModal(eventFeedData.isGoing));
                                          },
                                        ),
                                      ),
                                      SizedBox(width: KSize.getWidth(context, 8)),
                                      Expanded(
                                        child: KButton(
                                          // isOutlineButton: true,
                                          textColor: KColor.whiteConst,
                                          innerPadding: 9.5,
                                          title: 'Invite',
                                          leadingTitleIcon: const Icon(Icons.group_add, size: 20, color: KColor.whiteConst),
                                          onPressedCallback: () {
                                            // ignore: unnecessary_null_comparison
                                            if (eventFeedData != null) {
                                              ref
                                                  .read(inviteMemberProvider.notifier)
                                                  .fetchInvitedAndSuggestedMembers(eventFeedData.basicOverView!.slug);
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) => InviteMembersScreen(eventId: eventFeedData.basicOverView!.id!)));
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: KSize.getHeight(context, 16)),
                                ],
                              ),
                            ),
                            SizedBox(height: KSize.getHeight(context, 10)),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: KSize.getHeight(context, 60),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: eventTabs.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      if (eventTabs[index]['title'] == 'Photos') {
                                        ref.read(eventPhotosProvider.notifier).fetchEventPhotos(eventFeedData.basicOverView!.slug!);
                                        Navigator.push(context, CupertinoPageRoute(builder: (context) => const EventPhotosScreen()));
                                      } else if (eventTabs[index]['title'] == 'Videos') {
                                        ref.read(eventVideosProvider.notifier).fetchEventVideos(eventFeedData.basicOverView!.slug!);
                                        Navigator.push(context, CupertinoPageRoute(builder: (context) => const EventVideosScreen()));
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: KColor.textBackground,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: KColor.white, width: 4)),
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                        margin: const EdgeInsets.only(right: 10),
                                        child: Row(
                                          children: [
                                            Icon(eventTabs[index]['icon'], size: 20, color: KColor.primary),
                                            SizedBox(width: KSize.getWidth(context, 5)),
                                            Text(eventTabs[index]['title'], style: KTextStyle.subtitle2.copyWith(color: KColor.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (eventFeedData.basicOverView!.userId == userData!.id)
                              CreateFeedCard(feedType: FeedType.EVENT, id: eventFeedData.basicOverView!.id),
                            const SizedBox(height: 10)
                          ],
                        )),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          sliver: eventFeedData.feedData!.isEmpty
                              ? const SliverToBoxAdapter(child: KContentUnvailableComponent(message: 'End of feed! Keep checking back later!'))
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                    return Hero(
                                        tag: index,
                                        child: FeedCard(
                                          feedData: eventFeedData.feedData![index],
                                          feedType: FeedType.EVENT,
                                          id: eventFeedData.basicOverView!.id!,
                                        ));
                                  }, childCount: eventFeedData.feedData!.length),
                                ),
                        ),
                        if (eventFeedScrollState is ScrollReachedBottomState &&
                            ref.read(eventFeedProvider.notifier).eventFeedList!.feedData!.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const CupertinoActivityIndicator(),
                            ),
                          ),
                      ]));
  }
}
