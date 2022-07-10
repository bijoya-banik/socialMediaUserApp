import 'package:buddyscripts/controller/block_user/block_user_controller.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

class BlockedUserCard extends ConsumerStatefulWidget {
  final dynamic friendData;
   const BlockedUserCard(this.friendData, {Key? key}) : super(key: key);

  @override
  _BlockedUserCardState createState() => _BlockedUserCardState();
}

class _BlockedUserCardState extends ConsumerState<BlockedUserCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserProfilePicture(
                    avatarRadius: 25,
                    profileURL: widget.friendData.profilePic,
                    onTapNavigate: false,
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
                                onTapNavigate: false,
                                type: 'profile',
                                slug: widget.friendData.username,
                                userId: widget.friendData.id,
                                overflowVisible: true,
                                backgroundColor: KColor.appBackground,
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
            ),
            SizedBox(
                width: KSize.getWidth(context, 75),
                child: KButton(
                  title: isLoading ? "Loading..." : 'Unblock',
                  color: isLoading ? KColor.grey : KColor.primary,
                  innerPadding: 10,
                  onPressedCallback: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          await ref.read(blockUserProvider.notifier).unblock(widget.friendData.id);

                          setState(() {
                            isLoading = false;
                          });
                        },
                ))
          ],
        ),
        SizedBox(height: KSize.getHeight(context, 12)),
      ],
    );
  }
}
