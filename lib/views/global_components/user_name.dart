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
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class UserName extends ConsumerWidget {
  final String? slug;
  final String? name;
  final int? userId;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final bool onTapNavigate;
  final String? type;
  final bool overflowVisible;

  const UserName({
    this.slug,
    this.name,
    this.userId,
    this.textStyle,
    this.backgroundColor = KColor.whiteConst,
    this.onTapNavigate = true,
    this.type,
    this.overflowVisible = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: !onTapNavigate
            ? null
            : () {
                print('type: $type');
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
        child: Text(
          name ?? '',
          style: textStyle ?? KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.w700),
          overflow: overflowVisible ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
