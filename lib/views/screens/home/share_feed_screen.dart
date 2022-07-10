import 'dart:io';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/state/feed_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/screens/home/components/shared_feed_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/home/components/privacy_options_modal.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class ShareFeedScreen extends ConsumerStatefulWidget {
  final FeedType? feedType;
  final FeedModel? feed;
  final int? id;

  const ShareFeedScreen({Key? key, this.feedType = FeedType.PROFILE, this.feed, this.id}) : super(key: key);

  @override
  _ShareFeedScreenState createState() => _ShareFeedScreenState();
}

class _ShareFeedScreenState extends ConsumerState<ShareFeedScreen> {
  TextEditingController postController = TextEditingController();

  String privacy = 'Public';

  @override
  Widget build(BuildContext context) {
    ref.listen(feedProvider, (_, state) {
      if (state is FeedSuccessState) {
        Navigator.pop(context);
      }
    });

    return Consumer(builder: (context, watch, _) {
      final assetManager = ref.watch(assetManagerProvider);
      return CupertinoPageScaffold(
        backgroundColor: KColor.darkAppBackground,
        navigationBar: KCupertinoNavBar(
          title: 'Share to News Feed',
          automaticallyImplyLeading: false,
          customLeading: InkWell(
            onTap: () {
              ref.read(assetManagerProvider).removeAll();
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'Close',
                style: KTextStyle.subtitle1.copyWith(color: KColor.closeText),
              ),
            ),
          ),
          trailing: InkWell(
            onTap: () async {
              List<File> files = [];
              KDialog.kShowDialog(
                context,
                const ProcessingDialogContent("Processing..."),
                barrierDismissible: false,
              );
              if (assetManager.assets.isNotEmpty) {
                for (var file in assetManager.assets) {
                  files.add(File(file.path));
                }
              }
              if (widget.feedType == FeedType.HOME || widget.feedType == FeedType.PROFILE || widget.feedType == FeedType.DETAILS) {
                await ref.read(feedProvider.notifier).createFeed(
                      feedText: postController.text,
                      feedPrivacy: privacy,
                      activityType: 'share',
                      images: files,
                      fileType: assetManager.isVideoSelected ? 'video' : 'image',
                      feedType: widget.feedType == FeedType.PROFILE ? FeedType.PROFILE : FeedType.HOME,
                      shareId: widget.feed?.id,
                    );
              } else if (widget.feedType == FeedType.EVENT) {
                await ref.read(feedProvider.notifier).createFeed(
                      feedText: postController.text,
                      feedPrivacy: privacy,
                      activityType: 'share',
                      images: files,
                      fileType: assetManager.isVideoSelected ? 'video' : 'image',
                      eventId: widget.id,
                      feedType: FeedType.EVENT,
                      shareId: widget.feed?.id,
                    );
              } else if (widget.feedType == FeedType.GROUP) {
                await ref.read(feedProvider.notifier).createFeed(
                      feedText: postController.text,
                      feedPrivacy: privacy,
                      activityType: 'share',
                      images: files,
                      fileType: assetManager.isVideoSelected ? 'video' : 'image',
                      groupId: widget.id,
                      feedType: FeedType.GROUP,
                      shareId: widget.feed?.id,
                    );
              } else if (widget.feedType == FeedType.PAGE) {
                await ref.read(feedProvider.notifier).createFeed(
                      feedText: postController.text,
                      feedPrivacy: privacy,
                      activityType: 'share',
                      images: files,
                      fileType: assetManager.isVideoSelected ? 'video' : 'image',
                      pageId: widget.id,
                      feedType: FeedType.PAGE,
                      shareId: widget.feed?.id,
                    );
              }
              Navigator.pop(context);
            },
            child: Text(
              'SHARE',
              style: KTextStyle.subtitle2.copyWith(color: KColor.buttonBackground, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                /// Username, Profile Picture, Post Privacy
                Consumer(builder: (context, ref, _) {
                  final userState = ref.watch(userProvider);
                  final userData = userState is UserSuccessState ? userState.userModel.user : null;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UserProfilePicture(profileURL: userData?.profilePic, avatarRadius: 25, iconSize: 24.5, onTapNavigate: false),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserName(
                                name: "${userData?.firstName} ${userData?.lastName}", backgroundColor: KColor.appBackground, onTapNavigate: false),
                            SizedBox(height: KSize.getHeight(context, 3)),
                            Material(
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              color: AppMode.darkMode ? KColor.feedActionCircle : KColor.textBackground,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      elevation: 5,
                                      isScrollControlled: true,
                                      backgroundColor: KColor.textBackground,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                                      ),
                                      builder: (context) {
                                        return PrivacyOptionsModal(
                                          callBackFunction: (val) {
                                            setState(() {
                                              privacy = val;
                                            });
                                          },
                                          isSelected: privacy,
                                        );
                                      });
                                },
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        privacy,
                                        style: KTextStyle.bodyText2.copyWith(color: KColor.black87, fontSize: 12, letterSpacing: 0),
                                      ),
                                      Icon(Icons.keyboard_arrow_down, size: 15, color: KColor.black87)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                KTextField(controller: postController, hintText: 'What’s on your mind?', maxLines: null, minLines: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: SharedFeedCard(feedData: widget.feed, feedType: widget.feedType, isShare: true),
                ),

                SizedBox(height: KSize.getHeight(context, 20)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
