import 'package:buddyscripts/controller/friends/all_friends_controller.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsCard extends ConsumerStatefulWidget {
  final FriendType type;
  final dynamic friendData;

  const FriendsCard({Key? key, required this.type, required this.friendData}) : super(key: key);

  @override
  _FriendsCardState createState() => _FriendsCardState();
}

class _FriendsCardState extends ConsumerState<FriendsCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserProfilePicture(
              avatarRadius: 25,
              profileURL: widget.friendData.profilePic,
              onTapNavigate: true,
              slug: widget.friendData.username,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: KSize.getHeight(context, 10)),
                  Row(
                    children: [
                      Expanded(
                        child: UserName(
                          name: '${widget.friendData.firstName} ${widget.friendData.lastName}',
                          onTapNavigate: true,
                          type: 'profile',
                          slug: widget.friendData.username,
                          userId: widget.friendData.id,
                          overflowVisible: true,
                          backgroundColor:AppMode.darkMode?KColor.darkAppBackground: KColor.appBackground,
                          textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: KSize.getHeight(context, 3)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: KSize.getHeight(context, 12)),
      ],
    );
  }
}
