import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/event/event_feed_controller.dart';
import 'package:buddyscripts/controller/group/group_feed_controller.dart';
import 'package:buddyscripts/controller/page/page_feed_controller.dart';
import 'package:buddyscripts/controller/profile/my_profile_feed_controller.dart';
import 'package:buddyscripts/controller/profile/user_profile_feed_controller.dart';
import 'package:buddyscripts/views/screens/account/events/event_details_screen.dart';
import 'package:buddyscripts/views/screens/account/groups/group_details_screen.dart';
import 'package:buddyscripts/views/screens/account/pages/page_details_screen.dart';
import 'package:buddyscripts/views/screens/account/profile/my_profile_screen.dart';
import 'package:buddyscripts/views/screens/account/profile/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/constants/asset_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:nb_utils/nb_utils.dart';

class UserProfilePicture extends ConsumerWidget {
  final double? avatarRadius, iconSize;
  final String? profileURL;
  final String? slug;
  final int? userId;
  final bool onTapNavigate;
  final String? type;
  final double rightPadding;

  const UserProfilePicture({
    Key? key,
    this.avatarRadius,
    this.iconSize = 24.5,
    this.profileURL,
    this.userId,
    this.slug,
    this.onTapNavigate = true,
    this.type,
    this.rightPadding = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: !onTapNavigate
          ? null
          : () {
              if (type == 'page') {
                ref.read(pageFeedProvider.notifier).fetchPageFeed(slug!);
                Navigator.push(context, CupertinoPageRoute(builder: (context) => PageDetailsScreen()));
              } else if (type == 'group') {
                ref.read(groupFeedProvider.notifier).fetchGroupFeed(slug!);
                Navigator.push(context, CupertinoPageRoute(builder: (context) => GroupDetailsScreen()));
              } else if (type == 'event') {
                ref.read(eventFeedProvider.notifier).fetchEventFeed(slug!);
                Navigator.push(context, CupertinoPageRoute(builder: (context) => EventDetailsScreen()));
              } else {
                userId == getIntAsync(USER_ID)
                    ? ref.read(myProfileFeedProvider.notifier).fetchProfileFeed(slug!)
                    : ref.read(userProfileFeedProvider.notifier).fetchProfileFeed(slug!);
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => userId == getIntAsync(USER_ID) ? const MyProfileScreen() : const UserProfileScreen()));
              }
            },
      child: Container(
        margin: EdgeInsets.only(right: rightPadding),
        child: CircleAvatar(
          radius: avatarRadius,
          backgroundColor: KColor.grey100,
          backgroundImage: (profileURL == null) ? const AssetImage(AssetPath.profilePlaceholder) : NetworkImage(profileURL!) as ImageProvider,
          foregroundImage: (profileURL != null) ? NetworkImage(profileURL!) : const AssetImage(AssetPath.profilePlaceholder) as ImageProvider,
        ),
      ),
    );
  }
}
