import 'dart:async';
import 'dart:io';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/feed_details_controller.dart';
import 'package:buddyscripts/controller/feed/link_preview_controller.dart';
import 'package:buddyscripts/controller/feed/state/feed_state.dart';
import 'package:buddyscripts/controller/feed/state/link_preview_state.dart';
import 'package:buddyscripts/controller/feelings_activities/activities_controller.dart';
import 'package:buddyscripts/controller/feelings_activities/feelings_controller.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/feed_link_preview.dart';
import 'package:buddyscripts/views/global_components/preview_media.dart';
import 'package:buddyscripts/views/screens/home/components/poll_options_field.dart';
import 'package:buddyscripts/views/screens/home/components/poll_settings_modal.dart';
import 'package:buddyscripts/views/screens/home/components/shared_feed_card.dart';
import 'package:buddyscripts/views/screens/home/feed_details_screen.dart';
import 'package:buddyscripts/views/screens/home/feeling_activity/feeling_activity_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:buddyscripts/services/asset_service.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_text_field.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/home/components/post_options_card.dart';
import 'package:buddyscripts/views/screens/home/components/privacy_options_modal.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:nb_utils/nb_utils.dart';

class EditFeedScreen extends ConsumerStatefulWidget {
  final FeedType? feedType;
  final FeedModel? feed;

  const EditFeedScreen({Key? key, this.feedType = FeedType.PROFILE, this.feed}) : super(key: key);

  @override
  _EditFeedScreenState createState() => _EditFeedScreenState();
}

class _EditFeedScreenState extends ConsumerState<EditFeedScreen> {
  TextEditingController postController = TextEditingController();

  List<TextEditingController> pollOptionsController = [];
  int pollOptionsCount = 0;
  bool isAllowMemberAddOptions = false, isAllowMultipleChoice = false;

  // bool enableUpdateButton = true;
  String privacy = 'Public';
  List oldFiles = [];
  Timer? searchOnStoppedTyping;
  bool previewLoaded = false, linkModified = false;
  bool expandColor = true;
  bool isBackground = false;
  bool isPoll = false;
  int backGroundIndex = 1;
  bool storeBackground = false;
  int storeColor = 0;
  double? contentPaddingHorizental;
  double? contentPaddingVerticle;
  String? bgColor;
  FeelingsModel? feelingData;
  FeelingsModel? storeFeelingData;

  @override
  void initState() {
    super.initState();

    if (widget.feed?.poll != null) {
      isPoll = true;
      for (int i = 0; i < widget.feed!.poll!.pollOptions!.length; i++) {
        pollOptionsController.add(TextEditingController(text: widget.feed!.poll!.pollOptions![i].text));
      }
      pollOptionsCount = widget.feed!.poll!.pollOptions!.length;
      isAllowMemberAddOptions = widget.feed!.poll!.allowUserAddOption == 0 ? false : true;
      isAllowMultipleChoice = widget.feed!.poll!.isMultipleSelected == 0 ? false : true;
    }

    if (widget.feed?.isBackground == 1) {
      isBackground = true;
      backGroundIndex = KColor.feedBackGroundGradientColors.indexWhere((element) => element == widget.feed?.bgColor) + 2;
      storeBackground = true;
      storeColor = backGroundIndex;
      bgColor = widget.feed?.bgColor;
      setPadding();
    }

    if (widget.feed?.feelings != null) {
      final splitFeelingText = widget.feed?.feelings?.text?.split(' ');
      var name = "";

      for (int i = 2; i < splitFeelingText!.length; i++) {
        name += splitFeelingText[i];
        if (i < splitFeelingText.length) {
          name += " ";
        }
      }

      feelingData = FeelingsModel(
        icon: widget.feed?.feelings?.icon,
        type: splitFeelingText[1] == "feeling" ? "FEELINGS" : splitFeelingText[1],
        name: name,
      );
      storeFeelingData = feelingData;
    }

    postController.text = widget.feed?.feedTxt ?? "";
    privacy = widget.feed?.feedPrivacy == FeedPrivacy.PUBLIC
        ? 'Public'
        : widget.feed?.feedPrivacy == FeedPrivacy.FRIENDS
            ? 'Friends'
            : 'Only Me';
    oldFiles = widget.feed!.files!;
    // print('oldFiles = $oldFiles');
    // print('widget.feed?.fileType = ${widget.feed?.fileType}');
    ref.read(assetManagerProvider).setNetworkAssets = widget.feed?.files;
    if (widget.feed?.fileType == 'video') {
      ref.read(assetManagerProvider).isVideoSelected = true;
    } else if (widget.feed?.fileType == 'application') {
      ref.read(assetManagerProvider).isDocumentSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    AssetManager assetManager = ref.watch(assetManagerProvider);

    ref.listen(feedProvider, (_, state) {
      if (state is FeedSuccessState) {
        Navigator.pop(context);

        ref.read(feedDetailsProvider.notifier).fetchFeedDetails(widget.feed?.id);
        Navigator.of(context, rootNavigator: true).push((CupertinoPageRoute(builder: (context) => const FeedDetailsScreen())));
      }
    });

    return CupertinoPageScaffold(
      backgroundColor: KColor.darkAppBackground,
      navigationBar: KCupertinoNavBar(
        title: 'Update Post',
        automaticallyImplyLeading: false,
        customLeading: InkWell(
          onTap: () {
            ref.read(linkPreviewProvider.notifier).updateState();
            ref.read(linkPreviewProvider.notifier).linkPreviewModelModel = null;
            ref.read(assetManagerProvider.notifier).removeAll();
            setState(() {
              linkModified = true;
            });
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
            if (widget.feed?.activityType != 'share') {
              // if (widget.feed?.poll != null)
              if (isPoll) {
                List pollOptionsList = pollOptionsController.map((e) => e.text).toList();
                if (postController.text.trim().isEmpty) {
                  return toast('Please enter a question!', bgColor: KColor.red);
                } else if (pollOptionsList.length == 1) {
                  if (pollOptionsList[0].isEmpty) {
                    return toast('Each of the options in your poll must have some text', bgColor: KColor.red);
                  }
                } else {
                  for (int i = 0; i < pollOptionsList.length; i++) {
                    if (pollOptionsList[i].isEmpty) {
                      return toast('Each of the options in your poll must have some text', bgColor: KColor.red);
                    }
                  }
                }
              }
              if (postController.text.trim().isEmpty && feelingData != null) {
                return toast('Please type in something', bgColor: KColor.red);
              }
              if (postController.text.trim().isNotEmpty || assetManager.assets.isNotEmpty || oldFiles.isNotEmpty || feelingData != null) {
                List<File> files = [];
                KDialog.kShowDialog(
                  context,
                  const ProcessingDialogContent("Processing..."),
                  barrierDismissible: false,
                );
                FocusScope.of(context).unfocus();
                if (assetManager.assets.isNotEmpty) {
                  for (var file in assetManager.assets) {
                    files.add(File(file.path));
                  }
                }
                if (widget.feedType == FeedType.HOME ||
                    widget.feedType == FeedType.PROFILE ||
                    widget.feedType == FeedType.SEARCH ||
                    widget.feedType == FeedType.DETAILS ||
                    widget.feedType == FeedType.SAVED) {
                  await ref.read(feedProvider.notifier).updateFeed(
                    feedId: widget.feed?.id,
                    feedText: postController.text.trim(),
                    feedPrivacy: privacy,
                    activityType: 'feed',
                    images: files,
                    fileType: assetManager.isVideoSelected
                        ? 'video'
                        : assetManager.isDocumentSelected
                            ? 'application'
                            : 'image',
                    feedType: widget.feedType == FeedType.PROFILE ? FeedType.PROFILE : FeedType.HOME,
                    oldFiles: widget.feed?.files,
                    isBackground: bgColor == null ? 0 : 1,
                    bgColor: bgColor,
                    feelingsModel: feelingData,
                    // isPoll: widget.feed?.poll != null ? true : false,
                    isPoll: isPoll,
                    pollOptions: pollOptionsController.map((e) => e.text).toList(),
                    pollPrivacy: {"is_multiple_selected": isAllowMultipleChoice, "allow_user_add_option": isAllowMemberAddOptions},
                  );
                } else if (widget.feedType == FeedType.EVENT) {
                  await ref.read(feedProvider.notifier).updateFeed(
                    feedId: widget.feed?.id,
                    feedText: postController.text.trim(),
                    feedPrivacy: privacy,
                    activityType: 'event',
                    images: files,
                    fileType: assetManager.isVideoSelected
                        ? 'video'
                        : assetManager.isDocumentSelected
                            ? 'application'
                            : 'image',
                    eventId: widget.feed?.eventId,
                    feedType: FeedType.EVENT,
                    oldFiles: widget.feed?.files,
                    isBackground: bgColor == null ? 0 : 1,
                    bgColor: bgColor,
                    feelingsModel: feelingData,
                    // isPoll: widget.feed?.poll != null ? true : false,
                    isPoll: isPoll,
                    pollOptions: pollOptionsController.map((e) => e.text).toList(),
                    pollPrivacy: {"is_multiple_selected": isAllowMultipleChoice, "allow_user_add_option": isAllowMemberAddOptions},
                  );
                } else if (widget.feedType == FeedType.GROUP) {
                  await ref.read(feedProvider.notifier).updateFeed(
                    feedId: widget.feed?.id,
                    feedText: postController.text.trim(),
                    feedPrivacy: privacy,
                    activityType: 'group',
                    images: files,
                    fileType: assetManager.isVideoSelected
                        ? 'video'
                        : assetManager.isDocumentSelected
                            ? 'application'
                            : 'image',
                    groupId: widget.feed?.groupId,
                    feedType: FeedType.GROUP,
                    oldFiles: widget.feed?.files,
                    isBackground: bgColor == null ? 0 : 1,
                    bgColor: bgColor,
                    feelingsModel: feelingData,
                    // isPoll: widget.feed?.poll != null ? true : false,
                    isPoll: isPoll,
                    pollOptions: pollOptionsController.map((e) => e.text).toList(),
                    pollPrivacy: {"is_multiple_selected": isAllowMultipleChoice, "allow_user_add_option": isAllowMemberAddOptions},
                  );
                } else if (widget.feedType == FeedType.PAGE) {
                  await ref.read(feedProvider.notifier).updateFeed(
                    feedId: widget.feed?.id,
                    feedText: postController.text.trim(),
                    feedPrivacy: privacy,
                    activityType: 'page',
                    images: files,
                    fileType: assetManager.isVideoSelected
                        ? 'video'
                        : assetManager.isDocumentSelected
                            ? 'application'
                            : 'image',
                    pageId: widget.feed?.pageId,
                    feedType: FeedType.PAGE,
                    oldFiles: widget.feed?.files,
                    isBackground: bgColor == null ? 0 : 1,
                    bgColor: bgColor,
                    feelingsModel: feelingData,
                    // isPoll: widget.feed?.poll != null ? true : false,
                    isPoll: isPoll,
                    pollOptions: pollOptionsController.map((e) => e.text).toList(),
                    pollPrivacy: {"is_multiple_selected": isAllowMultipleChoice, "allow_user_add_option": isAllowMemberAddOptions},
                  );
                }
              } else {
                toast('Please write a status or upload images or video!', bgColor: KColor.buttonBackground);
              }
            } else {
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

              await ref.read(feedProvider.notifier).updateFeed(
                feedId: widget.feed?.id,
                feedText: postController.text,
                feedPrivacy: privacy,
                activityType: 'share',
                images: files,
                fileType: assetManager.isVideoSelected
                    ? 'video'
                    : assetManager.isDocumentSelected
                        ? 'application'
                        : 'image',
                feedType: widget.feedType == FeedType.PROFILE ? FeedType.PROFILE : FeedType.HOME,
                oldFiles: widget.feed?.files,
                shareId: widget.feed?.id,
                isBackground: bgColor == null ? 0 : 1,
                bgColor: bgColor,
                feelingsModel: feelingData,
                // isPoll: widget.feed?.poll != null ? true : false,
                isPoll: isPoll,
                pollOptions: pollOptionsController.map((e) => e.text).toList(),
                pollPrivacy: {"is_multiple_selected": isAllowMultipleChoice, "allow_user_add_option": isAllowMemberAddOptions},
              );

              Navigator.pop(context);
            }
          },
          child: Text(
            'UPDATE',
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
                final linkPreviewState = ref.watch(linkPreviewProvider);
                final userData = userState is UserSuccessState ? userState.userModel.user : null;
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UserProfilePicture(profileURL: userData?.profilePic, avatarRadius: 25, iconSize: 24.5, onTapNavigate: false),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              feelingData == null
                                  ? UserName(
                                      name: "${userData?.firstName} ${userData?.lastName}",
                                      backgroundColor: KColor.appBackground,
                                      onTapNavigate: false,
                                    )
                                  : Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      children: [
                                        UserName(
                                            name: "${userData?.firstName ?? ""} ${userData?.lastName ?? ""}",
                                            backgroundColor: AppMode.darkMode ? KColor.blackConst : KColor.appBackground,
                                            onTapNavigate: false),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(horizontal: 5),
                                        //   child: Image.network(
                                        //     feelingData!.icon!,
                                        //     height: 20,
                                        //     width: 25,
                                        //   ),
                                        // ),
                                        Text(feelingData!.type == "FEELINGS" ? " is feeling " : " is ${feelingData!.type ?? ""} ",
                                            style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w400)),
                                        InkWell(
                                          onTap: () async {
                                            ref.read(feelingsProvider.notifier).fetchFeelings();
                                            ref.read(activitiesProvider.notifier).fetchActivities();
                                            dynamic data = await Navigator.push(context,
                                                CupertinoPageRoute(builder: (context) => FeelingActivityScreen(feelingsModeldata: feelingData)));

                                            setState(() {
                                              // if (data == null) {
                                              //   feelingData = storeFeelingData;
                                              // } else {
                                              feelingData = data;
                                              //  }
                                            });
                                          },
                                          child: Text(feelingData!.name ?? "",
                                              style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w700)),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: KSize.getHeight(context, 3)),
                              Material(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                color: KColor.white,
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isDismissible: true,
                                        elevation: 5,
                                        isScrollControlled: true,
                                        backgroundColor: KColor.white,
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
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppMode.darkMode ? KColor.appBackground : KColor.white,
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          KTextField(
                            controller: postController,
                            gredientColor: backGroundIndex == 1
                                ? LinearGradient(
                                    begin: const Alignment(-1.0, 0.0),
                                    end: const Alignment(1.0, 0.0),
                                    transform: const GradientRotation(90),
                                    colors: [
                                      AppMode.darkMode ? KColor.appBackground : KColor.white,
                                      AppMode.darkMode ? KColor.appBackground : KColor.white,
                                    ],
                                  )
                                : KColor.gradientsColor[backGroundIndex],
                            hasPrefixIcon: false,
                            topMargin: isBackground ? 0 : 20,
                            contentPaddingHorizental: contentPaddingHorizental,
                            contentPaddingVerticle: contentPaddingVerticle,
                            textInputAction: TextInputAction.newline,
                            textInputType: TextInputType.multiline,
                            hintText: widget.feed?.poll != null ? 'Ask a question...' : 'What’s on your mind?',
                            hintStyle: KTextStyle.bodyText3.copyWith(
                                fontSize: 16,
                                color: backGroundIndex == 1 ? KColor.black54 : KColor.whiteConst,
                                fontWeight: backGroundIndex == 1 ? FontWeight.w400 : FontWeight.bold),
                            style: KTextStyle.bodyText3.copyWith(
                                fontSize: 16,
                                color: backGroundIndex == 1 ? KColor.black : KColor.whiteConst,
                                fontWeight: backGroundIndex == 1 ? FontWeight.w400 : FontWeight.bold),
                            maxLines: isPoll ? 2 : null,
                            minLines: isPoll
                                ? 2
                                : backGroundIndex != 1
                                    ? 3
                                    : linkPreviewState is LinkPreviewSuccessState
                                        ? 5
                                        : 10,
                            textAlign: backGroundIndex == 1 ? TextAlign.left : TextAlign.center,
                            callBack: true,
                            callBackFunction: (value) {
                              setState(() {
                                int lines = '\n'.allMatches(value).length + 1;

                                if ((lines > 3 || value.length > 150)) {
                                  if (isBackground) {
                                    bgColor = null;
                                    isBackground = false;
                                    isPoll = false;
                                    storeColor = backGroundIndex;
                                    backGroundIndex = 1;
                                  }
                                } else {
                                  if (!isBackground) {
                                    if (storeBackground) {
                                      backGroundIndex = storeColor;
                                      bgColor = backGroundIndex == 0 || backGroundIndex == 1
                                          ? null
                                          : KColor.feedBackGroundGradientColors[backGroundIndex - 2];
                                      isPoll = false;
                                      isBackground = true;
                                    }
                                  }
                                }
                                setPadding();
                              });
                              const duration = Duration(milliseconds: 500);
                              if (searchOnStoppedTyping != null) {
                                setState(() => searchOnStoppedTyping?.cancel()); // clear timer
                              }

                              if (previewLoaded == false) {
                                searchOnStoppedTyping = Timer(duration, () {
                                  RegExp regExp = RegExp(r'(?:(?:https?|ftp|www):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

                                  print("regExp.hasMatch(value)");
                                  print(regExp.hasMatch(value));
                                  if (regExp.hasMatch(value) && value.isNotEmpty) {
                                    ref.read(linkPreviewProvider.notifier).getLinkPreview(value);
                                    setState(() {
                                      linkModified = true;
                                    });
                                  } else {
                                    ref.read(linkPreviewProvider.notifier).updateState();
                                    setState(() {
                                      linkModified = true;
                                    });
                                  }
                                });
                              }
                            },
                            widgetInTextField: true,
                            // childWidgetView: linkPreviewState is LinkPreviewSuccessState
                            //     ? FeedLinkPreviewWidget(linkPreviewState.linkPreviewModel)
                            //     : !linkModified
                            //         ? FeedLinkPreviewWidget(widget.feed?.metaData?.linkMeta)
                            //         : Container(),
                          ),
                          // if (widget.feed?.poll != null)
                          if (isPoll && assetManager.assets.isEmpty)
                            Column(
                              children: [
                                Column(
                                    children: List.generate(pollOptionsCount, (index) {
                                  return PollOptionField(
                                    pollOptionsController: pollOptionsController,
                                    index: index,
                                    removeFieldCallback: () {
                                      if (pollOptionsController.length > 1) pollOptionsController.removeAt(index);
                                      if (pollOptionsCount > 1) pollOptionsCount--;
                                      setState(() {});
                                    },
                                    showRemoveOption: pollOptionsController.length > 1 ? true : false,
                                  );
                                })),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          pollOptionsController.add(TextEditingController());
                                          pollOptionsCount++;
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: AppMode.darkMode ? KColor.appBackground : KColor.white,
                                              border: Border.all(color: KColor.black87, width: 0.1),
                                              borderRadius: BorderRadius.circular(6)),
                                          child: Text(
                                            "Add option...",
                                            style: KTextStyle.subtitle2.copyWith(color: KColor.black, fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        showModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            elevation: 5,
                                            isScrollControlled: true,
                                            backgroundColor: KColor.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                                            ),
                                            builder: (context) {
                                              return StatefulBuilder(builder: (context, setState) {
                                                return PollSettingsModal(
                                                  isAllowMemberAddOptions: isAllowMemberAddOptions,
                                                  isAllowMultipleChoice: isAllowMultipleChoice,
                                                  callBackFunction: (val) {
                                                    print('val from call back  = $val');
                                                    setState(() {
                                                      isAllowMemberAddOptions = val['isAllowMemberAddOptions'];
                                                      isAllowMultipleChoice = val['isAllowMultipleChoice'];
                                                    });
                                                  },
                                                );
                                              });
                                            });
                                      },
                                      child: Icon(
                                        Icons.settings_outlined,
                                        color: KColor.grey700,
                                      ),
                                    ),
                                    SizedBox(width: KSize.getWidth(context, 12)),
                                  ],
                                ),
                                SizedBox(height: KSize.getHeight(context, 24)),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              if (widget.feed?.activityType == 'share')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: SharedFeedCard(
                    feedData: widget.feed!.share,
                    feedType: widget.feedType!,
                    isShare: true,
                  ),
                ),
              SizedBox(height: KSize.getHeight(context, 16)),

              /// background list
              !isBackground || assetManager.assets.isNotEmpty
                  ? Container()
                  : expandColor
                      ? Row(
                          children: List.generate(KColor.gradientsColor.length, (index) {
                            return index == 0
                                ? Container(
                                    height: 30,
                                    width: 30,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(color: KColor.whiteConst, borderRadius: BorderRadius.circular(8)),
                                    child: IconButton(
                                      padding: const EdgeInsets.only(left: 5),
                                      alignment: Alignment.center,
                                      icon: const Icon(Icons.arrow_back_ios, size: 15, color: KColor.blackConst),
                                      onPressed: () {
                                        setState(() {
                                          expandColor = !expandColor;
                                        });
                                      },
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        backGroundIndex = index;
                                        storeBackground = backGroundIndex == 0 || backGroundIndex == 1 ? false : true;
                                        storeColor = backGroundIndex;
                                        print("storeColor backGroundIndex");
                                        print(storeColor);
                                        bgColor = backGroundIndex == 0 || backGroundIndex == 1
                                            ? null
                                            : KColor.feedBackGroundGradientColors[backGroundIndex - 2];

                                        setPadding();
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(gradient: KColor.gradientsColor[index], borderRadius: BorderRadius.circular(8)),
                                    ),
                                  );
                          }),
                        )
                      : Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                expandColor = !expandColor;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: KColor.whiteConst, width: 2),
                                    gradient: const RadialGradient(
                                      center: Alignment(-0.9, -0.6),
                                      colors: [
                                        Color.fromRGBO(3, 235, 255, 1),
                                        Color.fromRGBO(152, 70, 242, 1),
                                        Color(0xFFff7f11),
                                        Color.fromRGBO(24, 175, 78, 1),
                                      ],
                                      radius: 1.0,
                                    ),
                                  ),
                                ),
                                Positioned(child: Icon(Ionicons.ios_text, size: 18, color: KColor.black87))
                              ],
                            ),
                          ),
                        ),

              SizedBox(height: KSize.getHeight(context, 16)),

              /// Post options
              if (widget.feed?.activityType != 'share')
                Wrap(
                  spacing: KSize.getWidth(context, 8),
                  runSpacing: KSize.getWidth(context, 8),
                  children: [
                    PostOptionsCard(
                      title: 'Photo Gallery',
                      bgColor: assetManager.assets.length == 20 ? KColor.grey350! : KColor.whiteConst,
                      customIcon: Icon(EvilIcons.image, color: KColor.black87),
                      onTap: () async {
                        if (assetManager.assets.length != 20) {
                          XFile _pickedMedia = await AssetService.pickImageVideo(false, context, ImageSource.gallery);
                          ref.read(assetManagerProvider).addAssets(File(_pickedMedia.path));
                          bgColor = null;
                          isBackground = false;
                          isPoll = false;
                          backGroundIndex = 1;
                          setPadding();
                        }
                      },
                    ),
                    PostOptionsCard(
                      title: 'Video Gallery',
                      customIcon: Icon(MaterialCommunityIcons.file_video_outline, size: 20, color: KColor.black87),
                      onTap: () async {
                        XFile _pickedMedia = await AssetService.pickImageVideo(false, context, ImageSource.gallery, isVideo: true);
                        ref.read(assetManagerProvider).addAssets(File(_pickedMedia.path));
                        bgColor = null;
                        isBackground = false;
                        isPoll = false;
                        backGroundIndex = 1;
                        setPadding();
                      },
                    ),
                    PostOptionsCard(
                      title: 'Capture Photo',
                      bgColor: assetManager.assets.length == 20 ? KColor.grey350! : KColor.whiteConst,
                      customIcon: Icon(CupertinoIcons.camera, size: 18, color: KColor.black87),
                      onTap: () async {
                        if (assetManager.assets.length != 20) {
                          XFile _pickedMedia = await AssetService.pickImageVideo(false, context, ImageSource.camera);
                          ref.read(assetManagerProvider).addAssets(File(_pickedMedia.path));
                          bgColor = null;
                          isBackground = false;
                          isPoll = false;
                          backGroundIndex = 1;
                          setPadding();
                        }
                      },
                    ),
                    PostOptionsCard(
                      title: 'Capture Video',
                      customIcon: Icon(CupertinoIcons.videocam, color: KColor.black87),
                      onTap: () async {
                        XFile _pickedMedia = await AssetService.pickImageVideo(false, context, ImageSource.camera, isVideo: true);
                        ref.read(assetManagerProvider).addAssets(File(_pickedMedia.path));
                        bgColor = null;
                        isBackground = false;
                        isPoll = false;
                        backGroundIndex = 1;
                        setPadding();
                      },
                    ),
                    if (widget.feedType != FeedType.STORY)
                      PostOptionsCard(
                        title: 'File',
                        customIcon: Icon(CupertinoIcons.doc, color: KColor.black87, size: 18),
                        onTap: () async {
                          if (assetManager.assets.length != 20) {
                            PlatformFile _asset = await AssetService.pickMedia(false, context, true, false);
                            ref.read(assetManagerProvider).addAssets(File(_asset.path.toString()));
                            bgColor = null;
                            isBackground = false;
                            isPoll = false;
                            backGroundIndex = 1;
                            setPadding();
                          }
                        },
                      ),
                    PostOptionsCard(
                      title: 'Background',
                      bgColor: KColor.whiteConst,
                      customIcon: Icon(Ionicons.text_outline, size: 18, color: KColor.black87),
                      onTap: () async {
                        setState(() {
                          if (assetManager.assets.isNotEmpty) {
                            ref.read(assetManagerProvider).removeAll();
                            isBackground = true;
                          } else {
                            isBackground = true;
                          }
                          isPoll = false;
                        });
                      },
                    ),
                    if (widget.feedType != FeedType.STORY)
                      PostOptionsCard(
                        title: 'Feeling/Activity',
                        bgColor: KColor.whiteConst,
                        customIcon: Icon(Icons.face, color: KColor.black87),
                        onTap: () async {
                          ref.read(feelingsProvider.notifier).fetchFeelings();
                          ref.read(activitiesProvider.notifier).fetchActivities();
                          dynamic data = await Navigator.push(
                              context, CupertinoPageRoute(builder: (context) => FeelingActivityScreen(feelingsModeldata: feelingData)));
                          setState(() {
                            feelingData = data;
                          });
                        },
                      ),
                    if (widget.feedType != FeedType.STORY)
                      PostOptionsCard(
                        title: 'Poll',
                        bgColor: KColor.whiteConst,
                        customIcon: Icon(MaterialIcons.bar_chart, size: 18, color: KColor.black87),
                        onTap: () async {
                          setState(() {
                            bgColor = null;
                            isBackground = false;
                            if (assetManager.assets.isNotEmpty) {
                              ref.read(assetManagerProvider).removeAll();
                              isPoll = true;
                            } else {
                              isPoll = true;
                            }
                            backGroundIndex = 1;
                            setPadding();
                          });
                        },
                      ),
                  ],
                ),
              SizedBox(height: KSize.getHeight(context, 20)),

              /// Selected Media Preview
              Wrap(
                runSpacing: 5,
                children: [
                  Visibility(
                    visible: oldFiles.isNotEmpty,
                    child: Wrap(
                      spacing: 5,
                      children: List.generate(oldFiles.length, (index) {
                        return PreviewMedia(
                          networkAsset: oldFiles[index],
                          index: index,
                          isNetworkAsset: true,
                          isFeedMedia: true,
                        );
                      }),
                    ),
                  ),
                  Visibility(
                    visible: assetManager.assets.isNotEmpty,
                    child: Wrap(
                      spacing: 5,
                      children: List.generate(assetManager.assets.length, (index) {
                        return PreviewMedia(asset: assetManager.assets[index], index: index, isNetworkAsset: false);
                      }),
                    ),
                  ),
                ],
              ),

              SizedBox(height: KSize.getHeight(context, 10)),
            ],
          ),
        ),
      ),
    );
  }

  setPadding() {
    if (backGroundIndex == 1) {
      contentPaddingHorizental = 0;
      contentPaddingVerticle = 12;
    } else {
      contentPaddingHorizental = 10;
      contentPaddingVerticle = 60;
    }
  }
}
