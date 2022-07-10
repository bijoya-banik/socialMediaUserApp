import 'package:buddyscripts/controller/event/event_feed_controller.dart';
import 'package:buddyscripts/controller/feed/feed_details_controller.dart';
import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/controller/notifications/notification_controller.dart';
import 'package:buddyscripts/controller/page/page_feed_controller.dart';
import 'package:buddyscripts/controller/profile/user_profile_feed_controller.dart';
import 'package:buddyscripts/models/notifications/notifications_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/screens/account/events/event_details_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/group_details_screen.dart';
import 'package:buddyscripts/views/screens/account/pages/page_details_screen.dart';
import 'package:buddyscripts/views/screens/account/profile/user_profile_screen.dart';
import 'package:buddyscripts/views/screens/home/feed_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationCard extends ConsumerWidget {
  final Notifications notification;

  const NotificationCard(this.notification, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onLongPress: () {
        _showBottomModal(context, notification.id);
      },
      onTap: () async {
        if (notification.seen == 0) {
          ref.read(notificationsProvider.notifier).markNotificationSeen(notification.id);
        }
        if (notification.notiType == "feed_like" || notification.notiType == "share_post") {
          ref.read(feedDetailsProvider.notifier).fetchFeedDetails(notification.feedId);
          await Navigator.of(context).push<void>(CupertinoPageRoute(builder: (context) => const FeedDetailsScreen()));
        } else if (notification.notiType == "feed_comment" || notification.notiType == "comment_like") {
          ref.read(feedDetailsProvider.notifier).fetchFeedDetails(notification.feedId);
          await Navigator.of(context).push<void>(CupertinoPageRoute(builder: (context) => const FeedDetailsScreen(showCommentModal: true)));
        }
        // else if (notification.notiType == "feed_comment") {
        //   context
        //       .read(feedDetailsProvider)
        //       .fetchFeedDetails(notification.feedId);
        //   await Navigator.of(context).push<void>(CupertinoPageRoute(
        //       builder: (context) => FeedDetailsScreen(showCommentModal: true)));
        // }

        else if (notification.notiType == "new_chat") {
          //
        } else if (notification.notiType == "typing") {
          //
        } else if (notification.notiType == "msg_seen") {
          //
        } else if (notification.notiType == "video_call") {
          //
        } else if (notification.notiType == "event_invitation") {
// context.read(discoverEventsProvider).fetchDiscoverEvents();
// context.read(interestedEventsProvider).fetchInterestedEvents();
// context.read(goingEventsProvider).fetchGoingEvents();

          ref.read(eventFeedProvider.notifier).fetchEventFeed(notification.notiMeta?.slug ?? "");
          Navigator.push(context, CupertinoPageRoute(builder: (context) => EventDetailsScreen()));
        } else if (notification.notiType == "new_group_member") {
          ref.read(groupFeedProvider.notifier).fetchGroupFeed(notification.notiMeta?.slug ?? "");
          Navigator.push(context, CupertinoPageRoute(builder: (context) => GroupDetailsScreen()));
        } else if (notification.notiType == "new_group_request") {
          ref.read(groupFeedProvider.notifier).fetchGroupFeed(notification.notiMeta?.slug ?? "");
          Navigator.push(context, CupertinoPageRoute(builder: (context) => GroupDetailsScreen()));
        } else if (notification.notiType == "page_follow") {
          ref.read(pageFeedProvider.notifier).fetchPageFeed(notification.notiMeta?.slug ?? "");
          Navigator.push(context, CupertinoPageRoute(builder: (context) => PageDetailsScreen()));
        } else if (notification.notiType == "accept_friend" || notification.notiType == "new_friend") {
          ref.read(userProfileFeedProvider.notifier).fetchProfileFeed(notification.notiMeta?.username ?? "");
          Navigator.push(context, CupertinoPageRoute(builder: (context) => const UserProfileScreen()));
        }
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserProfilePicture(profileURL: notification.fromUser?.profilePic, avatarRadius: 25, iconSize: 24.5, onTapNavigate: false),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "${notification.fromUser?.firstName}" " " "${notification.fromUser?.lastName}",
                            style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: ' ${notification.notiMeta?.actionText}',
                            style: KTextStyle.subtitle1.copyWith(color: KColor.black87),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: KSize.getHeight(context, 3)),
                    Text(
                      DateTimeService.timeAgoLocal(notification.createdAt?.toIso8601String()),
                      style: KTextStyle.bodyText2.copyWith(color: KColor.black54, fontSize: 12, letterSpacing: 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(thickness: 1),
          )
        ],
      ),
    );
  }

  void _showBottomModal(context, notificationId) {
    showPlatformModalSheet(
      context: context,
      material: MaterialModalSheetData(
        elevation: 5,
        isScrollControlled: true,
        useRootNavigator: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
      ),
      builder: (_) => PlatformWidget(
        material: (_, __) => NotificationOptionsModal(notificationId),
        cupertino: (_, __) => NotificationOptionsModal(
          notificationId,
          isPlatformIos: true,
        ),
      ),
    );
  }
}

class NotificationOptionsModal extends ConsumerWidget {
  final bool isPlatformIos;
  final int notificationId;

  const NotificationOptionsModal(this.notificationId, {Key? key, this.isPlatformIos = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isPlatformIos
        ? CupertinoTheme(
            data: CupertinoThemeData(
              brightness: AppMode.darkMode ? Brightness.dark : Brightness.light,
            ),
            child: CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('Delete'),
                  isDestructiveAction: true,
                  onPressed: () {
                    ref.read(notificationsProvider.notifier).deleteNotification(notificationId);
                    Navigator.pop(context);
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancel'),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          )
        : Container(
            color: KColor.textBackground,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 65,
                    height: 5,
                    decoration: BoxDecoration(color: KColor.grey100, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25)),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundColor: KColor.red!.withOpacity(0.1),
                    child: Icon(Icons.delete, color: KColor.red),
                  ),
                  title: Text(
                    'Delete this notification',
                    style: KTextStyle.subtitle2.copyWith(color: KColor.red),
                  ),
                  onTap: () {
                    ref.read(notificationsProvider.notifier).deleteNotification(notificationId);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
  }
}
