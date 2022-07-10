import 'package:buddyscripts/constants/asset_path.dart';
import 'package:buddyscripts/controller/chat/chat_controller.dart';
import 'package:buddyscripts/controller/chat/share_msg_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/views/screens/home/share_feed_screen.dart';
import 'package:buddyscripts/views/screens/home/share_msg_to_friends_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShareOptionsModal extends ConsumerWidget {
  final FeedType? feedType;
  final FeedModel? feed;
  final int? id;
  final bool isPlatformIos;
  const ShareOptionsModal({Key? key, this.feedType = FeedType.PROFILE, this.feed, this.id, this.isPlatformIos = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.23,
      child: Scaffold(
        backgroundColor: KColor.appBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                width: 65,
                height: 5,
                decoration: BoxDecoration(color: KColor.grey200, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25)),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                  radius: 23,
                  backgroundColor: KColor.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: KColor.primary.withOpacity(0.1),
                      border: Border.all(color: KColor.primary),
                    ),
                    child: Image.asset(
                      AssetPath.messageIcon,
                      color: KColor.primary,
                      height: KSize.getHeight(context, 19.5),
                      width: KSize.getWidth(context, 21),
                    ),
                  )),
              title: Text(
                'Send in messenger',
                style: KTextStyle.bodyText1.copyWith(color: KColor.black),
              ),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(chatProvider.notifier).statusShareUserIdList?.clear();
                ref.read(chatProvider.notifier).msgController = "";
                ref.read(shareMsgProvider.notifier).fetchRecentChatList();

                //ref.read(conversationSearchResultProvider.notifier).memberSearchForCreateGroupChat();
                Navigator.of(context, rootNavigator: true)
                    .push((CupertinoPageRoute(builder: (context) => ShareMsgToFriendsScreen(feed: feed, feedType: feedType, id: id))));
              },
            ),
            ListTile(
              leading: CircleAvatar(
                  radius: 23,
                  backgroundColor: KColor.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: KColor.primary.withOpacity(0.1),
                      border: Border.all(color: KColor.primary),
                    ),
                    child: Image.asset(
                      AssetPath.homeIcon,
                      color: KColor.primary,
                      height: KSize.getHeight(context, 19.5),
                      width: KSize.getWidth(context, 21),
                    ),
                  )),
              title: Text(
                'Share to newsfeed',
                style: KTextStyle.bodyText1.copyWith(color: KColor.black),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).push((CupertinoPageRoute(
                    builder: (context) => ShareFeedScreen(feed: feed!.share == null ? feed : feed?.share, feedType: feedType, id: id))));
              },
            ),
          ],
        ),
      ),
    );
  }
}
