import 'package:buddyscripts/controller/friends/friend_requests_controller.dart';
import 'package:buddyscripts/models/friend/friend_requests_model.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendRequestsCard extends ConsumerStatefulWidget {
  final Datum? friendData;

  const FriendRequestsCard(this.friendData, {Key? key}) : super(key: key);

  @override
  _FriendRequestsCardState createState() => _FriendRequestsCardState();
}

class _FriendRequestsCardState extends ConsumerState<FriendRequestsCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserProfilePicture(
              avatarRadius: 25,
              profileURL: widget.friendData!.friend!.profilePic,
              onTapNavigate: true,
              slug: widget.friendData!.friend!.username,
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
                          name: '${widget.friendData!.friend!.firstName} ${widget.friendData!.friend!.lastName}',
                          type: 'profile',
                          slug: widget.friendData!.friend!.username,
                          overflowVisible: true,
                          backgroundColor: KColor.darkAppBackground,
                          textStyle: KTextStyle.subtitle1.copyWith(color: KColor.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: KSize.getHeight(context, 10)),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: KButton(
                          title: isLoading ? "Please wait..." : "Confirm",
                          color: isLoading ? KColor.grey : KColor.buttonBackground,
                          innerPadding: 9,
                          onPressedCallback: isLoading
                              ? null
                              : () async {
                                  if (!mounted) return;
                                  setState(() {
                                    isLoading = true;
                                  });

                                  await ref.read(friendRequestsProvider.notifier).acceptRequest(friendId: widget.friendData!.friendId);

                                  if (!mounted) return;
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                        ),
                      ),
                      SizedBox(width: KSize.getWidth(context, 5)),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.33,
                          child: KButton(
                              title: 'Decline',
                              color: KColor.textBackground,
                              textColor: KColor.black,
                              innerPadding: 9,
                              onPressedCallback: () {
                                KDialog.kShowDialog(
                                    context,
                                    ConfirmationDialogContent(
                                        titleContent: 'Are you sure want to remove this request?',
                                        onPressedCallback: () => {
                                              Navigator.pop(context),
                                              KDialog.kShowDialog(context, const ProcessingDialogContent("Processing..."), barrierDismissible: false),
                                              ref.read(friendRequestsProvider.notifier).deleteRequest(widget.friendData!.friendId!)
                                            }),
                                    useRootNavigator: false);
                              })),
                    ],
                  ),
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
