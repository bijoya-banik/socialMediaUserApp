import 'dart:async';
import 'dart:io';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/link_preview_controller.dart';
import 'package:buddyscripts/controller/feed/state/feed_state.dart';
import 'package:buddyscripts/controller/feed/state/link_preview_state.dart';
import 'package:buddyscripts/controller/feelings_activities/activities_controller.dart';
import 'package:buddyscripts/controller/feelings_activities/feelings_controller.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/global_components/feed_link_preview.dart';
import 'package:buddyscripts/views/global_components/preview_media.dart';
import 'package:buddyscripts/views/screens/home/components/poll_options_field.dart';
import 'package:buddyscripts/views/screens/home/components/poll_settings_modal.dart';
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

class CreateFeedScreen extends ConsumerStatefulWidget {
  final FeedType feedType;
  final int? id;
  final bool story;

  const CreateFeedScreen({Key? key, this.feedType = FeedType.PROFILE, this.id, this.story = false}) : super(key: key);

  @override
  _CreateFeedScreenState createState() => _CreateFeedScreenState();
}

class _CreateFeedScreenState extends ConsumerState<CreateFeedScreen> {
  TextEditingController postController = TextEditingController();

  List<TextEditingController> pollOptionsController = [TextEditingController(), TextEditingController()];
  int pollOptionsCount = 2;
  bool isAllowMemberAddOptions = false, isAllowMultipleChoice = false;
  bool allowStoryAdd = true;

  // bool enableCreateButton = false;
  String privacy = 'Public';
  String? bgColor;
  bool _isStory = false;
  double? contentPaddingHorizental;
  double? contentPaddingVerticle;
  Timer? searchOnStoppedTyping;
  bool previewLoaded = false;
  bool expandColor = true;
  bool isBackground = false;
  bool isPoll = false;
  int backGroundIndex = 1;
  bool storeBackground = false;
  int storeColor = 0;
  FeelingsModel? feelingData;

  @override
  void initState() {
    _isStory = widget.story;

    if (_isStory) {
      privacy = "Friends";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final assetManager = ref.watch(assetManagerProvider);

      ref.listen(feedProvider, (_, state) {
        if (state is FeedSuccessState) {
          Navigator.pop(context);
        }
      });
      return CupertinoPageScaffold(
        backgroundColor: AppMode.darkMode ? KColor.blackConst : KColor.appBackground,
        navigationBar: KCupertinoNavBar(
          title: 'Create Post',
          automaticallyImplyLeading: false,
          customLeading: InkWell(
            onTap: () {
              ref.read(linkPreviewProvider.notifier).updateState();
              ref.read(linkPreviewProvider.notifier).linkPreviewModelModel = null;
              ref.read(assetManagerProvider.notifier).removeAll();
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
              if (postController.text.trim().isNotEmpty || assetManager.assets.isNotEmpty || feelingData != null) {
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
                if (widget.feedType == FeedType.HOME || widget.feedType == FeedType.PROFILE || widget.feedType == FeedType.STORY) {
                  await ref.read(feedProvider.notifier).createFeed(
                    feedText: postController.text,
                    feedPrivacy: privacy,
                    activityType: 'feed',
                    images: files,
                    fileType: assetManager.isVideoSelected
                        ? 'video'
                        : assetManager.isDocumentSelected
                            ? 'application'
                            : 'image',
                    feedType: widget.feedType == FeedType.PROFILE ? FeedType.PROFILE : FeedType.HOME,
                    story: _isStory ? 1 : 0,
                    isBackground: bgColor == null ? 0 : 1,
                    bgColor: bgColor,
                    feelingsModel: feelingData,
                    isPoll: isPoll,
                    pollOptions: pollOptionsController.map((e) => e.text).toList(),
                    pollPrivacy: {"is_multiple_selected": isAllowMultipleChoice, "allow_user_add_option": isAllowMemberAddOptions},
                  );
                } else if (widget.feedType == FeedType.EVENT) {
                  await ref.read(feedProvider.notifier).createFeed(
                    feedText: postController.text,
                    feedPrivacy: privacy,
                    activityType: 'event',
                    images: files,
                    fileType: assetManager.isVideoSelected
                        ? 'video'
                        : assetManager.isDocumentSelected
                            ? 'application'
                            : 'image',
                    eventId: widget.id,
                    feedType: FeedType.EVENT,
                    isBackground: bgColor == null ? 0 : 1,
                    bgColor: bgColor,
                    feelingsModel: feelingData,
                    isPoll: isPoll,
                    pollOptions: pollOptionsController.map((e) => e.text).toList(),
                    pollPrivacy: {"is_multiple_selected": isAllowMultipleChoice, "allow_user_add_option": isAllowMemberAddOptions},
                  );
                } else if (widget.feedType == FeedType.GROUP) {
                  await ref.read(feedProvider.notifier).createFeed(
                    feedText: postController.text,
                    feedPrivacy: privacy,
                    activityType: 'group',
                    images: files,
                    fileType: assetManager.isVideoSelected
                        ? 'video'
                        : assetManager.isDocumentSelected
                            ? 'application'
                            : 'image',
                    groupId: widget.id,
                    feedType: FeedType.GROUP,
                    isBackground: bgColor == null ? 0 : 1,
                    bgColor: bgColor,
                    feelingsModel: feelingData,
                    isPoll: isPoll,
                    pollOptions: pollOptionsController.map((e) => e.text).toList(),
                    pollPrivacy: {"is_multiple_selected": isAllowMultipleChoice, "allow_user_add_option": isAllowMemberAddOptions},
                  );
                } else if (widget.feedType == FeedType.PAGE) {
                  await ref.read(feedProvider.notifier).createFeed(
                    feedText: postController.text,
                    feedPrivacy: privacy,
                    activityType: 'page',
                    images: files,
                    fileType: assetManager.isVideoSelected
                        ? 'video'
                        : assetManager.isDocumentSelected
                            ? 'application'
                            : 'image',
                    pageId: widget.id,
                    feedType: FeedType.PAGE,
                    isBackground: bgColor == null ? 0 : 1,
                    bgColor: bgColor,
                    feelingsModel: feelingData,
                    isPoll: isPoll,
                    pollOptions: pollOptionsController.map((e) => e.text).toList(),
                    pollPrivacy: {"is_multiple_selected": isAllowMultipleChoice, "allow_user_add_option": isAllowMemberAddOptions},
                  );
                }

                Navigator.pop(context);
              } else {
                toast('Please write a status or upload images or video!', bgColor: KColor.red);
              }
            },
            child: Text(
              'CREATE',
              style: KTextStyle.subtitle2.copyWith(color: KColor.primary, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Consumer(builder: (context, ref, _) {
              final userState = ref.watch(userProvider);
              final linkPreviewState = ref.watch(linkPreviewProvider);
              final userData = userState is UserSuccessState ? userState.userModel.user : null;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Username, Profile Picture, Post Privacy
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
                                    name: "${userData?.firstName ?? ""} ${userData?.lastName ?? ""}",
                                    backgroundColor: AppMode.darkMode ? KColor.blackConst : KColor.appBackground,
                                    onTapNavigate: false)
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
                                      Text(feelingData!.type == "FEELINGS" ? " is feeling " : " is ${feelingData!.type} ",
                                          style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w400)),
                                      InkWell(
                                        onTap: () async {
                                          ref.read(feelingsProvider.notifier).fetchFeelings();
                                          ref.read(activitiesProvider.notifier).fetchActivities();
                                          dynamic data = await Navigator.push(context,
                                              CupertinoPageRoute(builder: (context) => FeelingActivityScreen(feelingsModeldata: feelingData)));

                                          setState(() {
                                            feelingData = data;
                                          });
                                        },
                                        child: Text(feelingData!.name!,
                                            style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                            SizedBox(height: KSize.getHeight(context, 7)),
                            if (widget.feedType == FeedType.HOME || widget.feedType == FeedType.PROFILE || widget.feedType == FeedType.STORY)
                              Material(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                color: AppMode.darkMode ? KColor.appBackground : KColor.white,
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                                            isStory: _isStory,
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
                                        Icon(Icons.keyboard_arrow_down, size: 15, color: KColor.black87),
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
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppMode.darkMode ? KColor.appBackground : KColor.white,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
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
                            textInputAction: TextInputAction.newline,
                            textInputType: TextInputType.multiline,
                            topMargin: isBackground ? 0 : 20,
                            contentPaddingHorizental: contentPaddingHorizental,
                            contentPaddingVerticle: contentPaddingVerticle,
                            hintText: isPoll ? 'Ask a question...' : 'What\'s on your mind?',
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
                                      isBackground = true;
                                      isPoll = false;
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
                                  } else {
                                    ref.read(linkPreviewProvider.notifier).updateState();
                                  }
                                });
                              } 
                            },
                            widgetInTextField: true,
                            // childWidgetView:
                            //     linkPreviewState is LinkPreviewSuccessState ? FeedLinkPreviewWidget(linkPreviewState.linkPreviewModel) : Container()
                                ),
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
                          : InkWell(
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

                  SizedBox(height: KSize.getHeight(context, 16)),

                  /// Post options
                  Center(
                    child: Wrap(
                      spacing: KSize.getWidth(context, 8),
                      runSpacing: KSize.getWidth(context, 8),
                      children: [
                        PostOptionsCard(
                          title: 'Photo Gallery',
                          //  bgColor: assetManager.assets.length == 20 || assetManager.isVideoSelected ? KColor.grey350! : KColor.whiteConst,
                          bgColor: assetManager.assets.length == 20 ? KColor.grey350! : KColor.whiteConst,
                          customIcon: Icon(EvilIcons.image, color: KColor.black87),
                          onTap: () async {
                            // if (assetManager.isVideoSelected && assetManager.assets.isNotEmpty) {
                            //   assetManager.assets.clear();
                            // }
                            // if (assetManager.assets.length != 20 && !assetManager.isVideoSelected) {
                            if (assetManager.assets.length != 20) {
                              XFile _pickedMedia = await AssetService.pickImageVideo(false, context, ImageSource.gallery);
                              ref.read(assetManagerProvider).addAssets(File(_pickedMedia.path));
                              bgColor = null;
                              isBackground = false;
                              isPoll = false;
                              backGroundIndex = 1;
                              allowStoryAdd = true;
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
                            allowStoryAdd = true;
                            setPadding();
                          },
                        ),
                        PostOptionsCard(
                          title: 'Capture Photo',
                          // bgColor: assetManager.assets.length == 20 || assetManager.isVideoSelected ? KColor.grey350! : KColor.whiteConst,
                          bgColor: assetManager.assets.length == 20 ? KColor.grey350! : KColor.whiteConst,
                          customIcon: Icon(CupertinoIcons.camera, size: 18, color: KColor.black87),
                          onTap: () async {
                            //  if (assetManager.isVideoSelected && assetManager.assets.isNotEmpty) {
                            //   assetManager.assets.clear();
                            // }
                            //  if (assetManager.assets.length != 20 && !assetManager.isVideoSelected) {
                            if (assetManager.assets.length != 20) {
                              XFile _pickedMedia = await AssetService.pickImageVideo(false, context, ImageSource.camera);
                              ref.read(assetManagerProvider).addAssets(File(_pickedMedia.path));
                              bgColor = null;
                              isBackground = false;
                              isPoll = false;
                              backGroundIndex = 1;
                              allowStoryAdd = true;
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
                            allowStoryAdd = true;
                            setPadding();
                          },
                        ),
                        if (widget.feedType != FeedType.STORY)
                          PostOptionsCard(
                            title: 'File',
                            customIcon: Icon(CupertinoIcons.doc, color: KColor.black87, size: 18),
                            onTap: () async {
                              //if (assetManager.assets.length != 20 && !assetManager.isVideoSelected) {
                              if (assetManager.assets.length != 20) {
                                PlatformFile _asset = await AssetService.pickMedia(false, context, true, false);
                                ref.read(assetManagerProvider).addAssets(File(_asset.path.toString()));
                                bgColor = null;
                                isBackground = false;
                                isPoll = false;
                                backGroundIndex = 1;
                                allowStoryAdd = false;
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
                              allowStoryAdd = true;
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
                                allowStoryAdd = false;
                              });
                              // print('allowStoryAdd =  $allowStoryAdd');
                            },
                          ),
                        // if (widget.feedType != FeedType.STORY)
                        //   PostOptionsCard(
                        //     title: 'Poll',
                        //     bgColor: KColor.whiteConst,
                        //     customIcon: Icon(MaterialIcons.bar_chart, size: 18, color: KColor.black87),
                        //     onTap: () async {
                        //       setState(() {
                        //         bgColor = null;
                        //         isBackground = false;
                        //         if (assetManager.assets.isNotEmpty) {
                        //           ref.read(assetManagerProvider).removeAll();
                        //           isPoll = true;
                        //         } else {
                        //           isPoll = true;
                        //         }
                        //         backGroundIndex = 1;
                        //         allowStoryAdd = false;
                        //         setPadding();
                        //       });
                        //     },
                        //   ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: allowStoryAdd &&
                        (widget.feedType == FeedType.HOME || widget.feedType == FeedType.PROFILE || widget.feedType == FeedType.STORY),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isStory = !_isStory;
                          if (_isStory) {
                            privacy = "Friends";
                          }
                        });
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: KColor.grey,
                                checkboxTheme: CheckboxThemeData(
                                  fillColor: MaterialStateColor.resolveWith(
                                    (states) {
                                      if (states.contains(MaterialState.selected)) return KColor.primary; // the color when checkbox is selected;
                                      return KColor.grey; //the color when checkbox is unselected;
                                    },
                                  ),
                                ),
                              ),
                              child: Checkbox(
                                  value: _isStory,
                                  onChanged: (val) {
                                    print(widget.feedType);
                                    setState(() {
                                      _isStory = !_isStory;
                                      if (_isStory) {
                                        privacy = "Friends";
                                      }
                                    });
                                  }),
                            ),
                            Text(
                              'Add this post to your story',
                              style: KTextStyle.bodyText3.copyWith(color: KColor.black87, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: KSize.getWidth(context, 15)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: KSize.getHeight(context, 20)),

                  /// Selected Media Preview
                  Visibility(
                    visible: assetManager.assets.isNotEmpty,
                    child: SizedBox(
                      height: KSize.getHeight(context, 80),
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: assetManager.assets.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return PreviewMedia(asset: assetManager.assets[index], index: index, isNetworkAsset: false);
                          }),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      );
    });
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
