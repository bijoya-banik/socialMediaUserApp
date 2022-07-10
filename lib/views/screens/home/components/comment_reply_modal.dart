import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/auth/state/user_state.dart';
import 'package:buddyscripts/controller/auth/user_controller.dart';
import 'package:buddyscripts/controller/comment/comment_reacted_users_controller.dart';
import 'package:buddyscripts/controller/comment/comment_reply_controller.dart';
import 'package:buddyscripts/controller/comment/state/comment_reply_state.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/models/feed/comment_model.dart';
import 'package:buddyscripts/models/reaction_button/reaction_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:buddyscripts/services/date_time_service.dart';
import 'package:buddyscripts/views/screens/home/comment_reacted_users_screen.dart';
import 'package:buddyscripts/views/screens/home/components/feed_card.dart';
import 'package:buddyscripts/views/screens/home/components/reaction_box/reaction_button_toggle.dart';
import 'package:buddyscripts/views/screens/home/components/reaction_box/reaction_emoji_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_comment_loading_indicator.dart';
import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/screens/home/components/comment_options_modal.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentReplyModal extends StatefulWidget {
  final CommentModel? commentData;
  final int? feedUserId;
  final FeedType? feedType;
  const CommentReplyModal(this.commentData, {Key? key, this.feedUserId, this.feedType}) : super(key: key);

  @override
  _CommentReplyModalState createState() => _CommentReplyModalState();
}

class _CommentReplyModalState extends State<CommentReplyModal> {
  bool _isDisabled = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final userState = ref.watch(userProvider);
      final commentRepliesState = ref.watch(commentRepliesProvider);
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Scaffold(
          backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.white,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  ref.read(commentReactionTypesProvider.notifier).fetchCommentReactionTypes(widget.commentData!.id);
                  ref.read(commentReactedUsersProvider.notifier).fetchCommentReactedUsers(widget.commentData!.id);

                  Navigator.push(context, CupertinoPageRoute(builder: (context) => CommentReactedUsersScreen(commentId: widget.commentData!.id)));
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                  child: Row(
                    children: [
                      widget.commentData!.totalLikes!.isNotEmpty
                          ? SizedBox(
                              width: widget.commentData!.totalLikes!.length == 1
                                  ? 25
                                  : widget.commentData!.totalLikes!.length == 2
                                      ? 40
                                      : 60,
                              child: Stack(
                                children: [
                                  ReactionEmojiComponent(
                                    reactionType: "${widget.commentData!.totalLikes![0].reactionType}",
                                    height: 20,
                                  ),
                                  if (widget.commentData!.totalLikes!.length >= 2)
                                    Positioned(
                                      left: 15,
                                      child: ReactionEmojiComponent(
                                        reactionType: "${widget.commentData!.totalLikes![1].reactionType}",
                                        height: 20,
                                      ),
                                    ),
                                  if (widget.commentData!.totalLikes!.length >= 3)
                                    Positioned(
                                      left: 32,
                                      child: ReactionEmojiComponent(
                                        reactionType: "${widget.commentData!.totalLikes![2].reactionType}",
                                        height: 20,
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : const ReactionEmojiComponent(reactionType: 'LIKE'),
                      const SizedBox(width: 5),
                      Text(
                        widget.commentData!.commentlike == null
                            ? '${widget.commentData!.likeCount}'
                            : widget.commentData!.likeCount == 1
                                ? 'You'
                                : widget.commentData!.likeCount == 2
                                    ? 'You and 1 other'
                                    : 'You and ${widget.commentData!.likeCount - 1} others',
                        style: KTextStyle.bodyText2.copyWith(color: KColor.black54, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: KColor.black.withOpacity(0.2), height: 1),
              ref.read(commentRepliesProvider.notifier).hasMoreCommentReplies
                  ? _isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: CupertinoActivityIndicator(),
                        )
                      : InkWell(
                          onTap: () async {
                            setState(() {
                              _isLoadingMore = true;
                            });
                            await ref.read(commentRepliesProvider.notifier).fetchMoreCommentReplies(widget.commentData!.feedId!);
                            setState(() {
                              _isLoadingMore = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 15, left: 15, bottom: 7),
                            child: Text(
                              'View previous replies...',
                              style: KTextStyle.bodyText2.copyWith(fontWeight: FontWeight.bold, color: KColor.black),
                            ),
                          ),
                        )
                  : SizedBox(height: KSize.getHeight(context, 10)),
              Expanded(
                child: commentRepliesState is CommentReplyLoadingState
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (BuildContext ctx, int index) {
                          return const KCommentLoadingIndicator();
                        },
                      )
                    : commentRepliesState is CommentReplySuccessState
                        ? commentRepliesState.commentModel.isEmpty
                            ? SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 100),
                                      child: Container(
                                        color: AppMode.darkMode ? KColor.appBackground : KColor.white,
                                        transform: Matrix4.rotationZ(-0.2),
                                        child: Icon(
                                          Octicons.comment_discussion,
                                          color: KColor.black54,
                                          size: KSize.getHeight(context, 150),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'No replies yet',
                                      style: KTextStyle.subtitle1.copyWith(color: KColor.primary, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Be the first to reply',
                                      style: KTextStyle.subtitle1.copyWith(
                                        color: KColor.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Align(
                                alignment: Alignment.topCenter,
                                child: ListView.builder(
                                    reverse: true,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: commentRepliesState.commentModel.length,
                                    itemBuilder: (BuildContext ctx, int index) {
                                      return GestureDetector(
                                        onLongPress: () {
                                          if (commentRepliesState.commentModel[index].userId == getIntAsync(USER_ID)) {
                                            _editDeleteModal(context, commentRepliesState.commentModel[index]);
                                          }
                                        },
                                        child: Container(
                                          color: KColor.transparent,
                                          padding: const EdgeInsets.only(bottom: 8),
                                          margin: const EdgeInsets.only(left: 15, right: 15),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: index == 0 ? 0 : 5),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        margin: const EdgeInsets.only(right: 5, top: 5),
                                                        child: UserProfilePicture(
                                                          avatarRadius: 17,
                                                          iconSize: 16.5,
                                                          profileURL: commentRepliesState.commentModel[index].user!.profilePic,
                                                          slug: commentRepliesState.commentModel[index].user!.username,
                                                          userId: commentRepliesState.commentModel[index].user!.id,
                                                          type: 'profile',
                                                        )),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10, left: 15),
                                                            margin: const EdgeInsets.only(bottom: 5),
                                                            decoration: BoxDecoration(
                                                              color: KColor.feedActionCircle,
                                                              borderRadius: BorderRadius.circular(16),
                                                            ),
                                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                              UserName(
                                                                slug: commentRepliesState.commentModel[index].user!.username,
                                                                userId: commentRepliesState.commentModel[index].user!.id,
                                                                name:
                                                                    '${commentRepliesState.commentModel[index].user!.firstName} ${commentRepliesState.commentModel[index].user!.lastName}',
                                                                textStyle: KTextStyle.subtitle1.copyWith(
                                                                  color: KColor.black,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                                backgroundColor: KColor.feedActionCircle,
                                                              ),
                                                              Container(
                                                                alignment: Alignment.centerLeft,
                                                                child: Container(
                                                                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                                                                  child: Text(
                                                                    commentRepliesState.commentModel[index].commentTxt ?? '',
                                                                    textAlign: TextAlign.justify,
                                                                    style: KTextStyle.bodyText3.copyWith(color: KColor.black87),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                          ),
                                                          Row(
                                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              const SizedBox(width: 10),
                                                              Text(
                                                                  DateTimeService.timeAgoLocal(
                                                                          commentRepliesState.commentModel[index].createdAt.toString(),
                                                                          alwaysTimeAgo: true,
                                                                          shortTime: true) ??
                                                                      '',
                                                                  style: KTextStyle.caption.copyWith(color: KColor.black54)),
                                                              // const SizedBox(width: 15),
                                                              // Container(
                                                              //   padding: const EdgeInsets.symmetric(vertical: 5),
                                                              //   child: InkWell(
                                                              //     onTap: () {
                                                              //       ref
                                                              //           .read(commentRepliesProvider.notifier)
                                                              //           .likeCommmentReply(replyData: commentRepliesState.commentModel[index]);
                                                              //     },
                                                              //     child: Row(
                                                              //       children: [
                                                              //         Icon(
                                                              //           commentRepliesState.commentModel[index].commentlike == null
                                                              //               ? FontAwesome.thumbs_o_up
                                                              //               : FontAwesome.thumbs_up,
                                                              //           color: commentRepliesState.commentModel[index].commentlike == null
                                                              //               ? KColor.black87
                                                              //               : KColor.primary,
                                                              //           size: 15,
                                                              //         ),
                                                              //         const SizedBox(width: 5),
                                                              //         Text(
                                                              //           commentRepliesState.commentModel[index].likeCount == 1
                                                              //               ? '1 Like'
                                                              //               : "${commentRepliesState.commentModel[index].likeCount} Likes",
                                                              //           style: KTextStyle.caption.copyWith(
                                                              //             color: KColor.black54,
                                                              //             fontSize: 12,
                                                              //             fontWeight: FontWeight.bold,
                                                              //           ),
                                                              //         ),
                                                              //       ],
                                                              //     ),
                                                              //   ),
                                                              // ),

                                                              InkWell(
                                                                onTap: () {
                                                                  ref.read(commentRepliesProvider.notifier).likeCommmentReply(
                                                                        replyData: commentRepliesState.commentModel[index],
                                                                        reaction: 'LIKE',
                                                                        action: 'deleteOrCreate',
                                                                      );
                                                                },
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(context).size.width * .2,
                                                                  child: FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    child: ReactionButtonToggle<String>(
                                                                      isFromComments: true,
                                                                      boxColor: AppMode.darkMode ? KColor.appBackground : KColor.whiteConst,
                                                                      onReactionChanged: (String? value, bool isChecked, reaction) {
                                                                        print('Selected value: $value, isChecked: $isChecked, reaction : $reaction');
                                                                        print('reaction : ${reaction.value}');

                                                                        ref.read(commentRepliesProvider.notifier).likeCommmentReply(
                                                                              replyData: commentRepliesState.commentModel[index],
                                                                              reaction: value!.toUpperCase(),
                                                                              action: 'update',
                                                                            );
                                                                        setState(() {});
                                                                      },
                                                                      //                                                commentRepliesState.commentModel[index].commentlike == null
                                                                      //       ?
                                                                      //       // AppMode.DIVINE9 ? FontAwesome.heart_o :
                                                                      //       FontAwesome.thumbs_o_up
                                                                      //       :
                                                                      //       //  AppMode.DIVINE9 ? FontAwesome.heart :
                                                                      //       FontAwesome.thumbs_up,
                                                                      //   color: // AppMode.DIVINE9 ?
                                                                      //       commentRepliesState.commentModel[index].commentlike == null
                                                                      //           ? KColor.black87
                                                                      //           // : KColor.lovePink
                                                                      //           : KColor.primary,
                                                                      //   size: 15,
                                                                      // ),
                                                                      // const SizedBox(width: 5),
                                                                      // Text(
                                                                      //   commentRepliesState.commentModel[index].likeCount == 1
                                                                      //       ? '1 Like'
                                                                      //       : "${commentRepliesState.commentModel[index].likeCount} Likes",
                                                                      //   style: KTextStyle.caption.copyWith(
                                                                      //     color: KColor.black54,
                                                                      //     fontSize: 12,
                                                                      //     fontWeight: FontWeight.bold,
                                                                      //   ),
                                                                      reactions: [
                                                                        ReactionModel<String>(
                                                                          value: 'Like',
                                                                          title: const ReactionBoxTitle('Like'),
                                                                          previewIcon: const ReactionsPreviewIcon('assets/images/like.gif'),
                                                                          icon: Text(
                                                                            commentRepliesState.commentModel[index].commentlike == null
                                                                                ? 'Like'
                                                                                : commentRepliesState.commentModel[index].commentlike!.reactionType ==
                                                                                        'LOVE'
                                                                                    ? 'Love'
                                                                                    : commentRepliesState
                                                                                                .commentModel[index].commentlike!.reactionType ==
                                                                                            'HAHA'
                                                                                        ? 'Haha'
                                                                                        : commentRepliesState
                                                                                                    .commentModel[index].commentlike!.reactionType ==
                                                                                                'WOW'
                                                                                            ? 'Wow'
                                                                                            : commentRepliesState.commentModel[index].commentlike!
                                                                                                        .reactionType ==
                                                                                                    'SAD'
                                                                                                ? 'Sad'
                                                                                                : commentRepliesState.commentModel[index].commentlike!
                                                                                                            .reactionType ==
                                                                                                        'ANGRY'
                                                                                                    ? 'Angry'
                                                                                                    : 'Like',
                                                                            style: KTextStyle.caption.copyWith(
                                                                              color: commentRepliesState.commentModel[index].commentlike == null
                                                                                  ? KColor.black54
                                                                                  : commentRepliesState
                                                                                              .commentModel[index].commentlike!.reactionType ==
                                                                                          'LOVE'
                                                                                      ? KColor.red
                                                                                      : commentRepliesState
                                                                                                  .commentModel[index].commentlike!.reactionType ==
                                                                                              'HAHA'
                                                                                          ? KColor.reactionYellow
                                                                                          : commentRepliesState.commentModel[index].commentlike!
                                                                                                      .reactionType ==
                                                                                                  'WOW'
                                                                                              ? KColor.reactionYellow
                                                                                              : commentRepliesState.commentModel[index].commentlike!
                                                                                                          .reactionType ==
                                                                                                      'SAD'
                                                                                                  ? KColor.reactionYellow
                                                                                                  : commentRepliesState.commentModel[index]
                                                                                                              .commentlike!.reactionType ==
                                                                                                          'ANGRY'
                                                                                                      ? KColor.reactionOrange
                                                                                                      : KColor.reactionBlue,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ReactionModel<String>(
                                                                          value: 'Love',
                                                                          title: const ReactionBoxTitle('Love'),
                                                                          previewIcon: const ReactionsPreviewIcon('assets/images/love.gif'),
                                                                          icon: ReactionsIcon(
                                                                            'assets/images/love2.png',
                                                                            Text('Love', style: TextStyle(color: KColor.red)),
                                                                          ),
                                                                        ),
                                                                        ReactionModel<String>(
                                                                          value: 'Haha',
                                                                          title: const ReactionBoxTitle('Haha'),
                                                                          previewIcon: const ReactionsPreviewIcon('assets/images/haha.gif'),
                                                                          icon: ReactionsIcon(
                                                                            'assets/images/haha2.png',
                                                                            Text('Haha', style: TextStyle(color: KColor.reactionYellow)),
                                                                          ),
                                                                        ),
                                                                        ReactionModel<String>(
                                                                          value: 'Wow',
                                                                          title: const ReactionBoxTitle('Wow'),
                                                                          previewIcon: const ReactionsPreviewIcon('assets/images/wow.gif'),
                                                                          icon: ReactionsIcon(
                                                                            'assets/images/wow2.png',
                                                                            Text('Wow', style: TextStyle(color: KColor.reactionYellow)),
                                                                          ),
                                                                        ),
                                                                        ReactionModel<String>(
                                                                          value: 'Sad',
                                                                          title: const ReactionBoxTitle('Sad'),
                                                                          previewIcon: const ReactionsPreviewIcon('assets/images/sad.gif'),
                                                                          icon: ReactionsIcon(
                                                                            'assets/images/sad2.png',
                                                                            Text('Sad', style: TextStyle(color: KColor.reactionYellow)),
                                                                          ),
                                                                        ),
                                                                        ReactionModel<String>(
                                                                          value: 'Angry',
                                                                          title: const ReactionBoxTitle('Angry'),
                                                                          previewIcon: const ReactionsPreviewIcon('assets/images/angry.gif'),
                                                                          icon: ReactionsIcon(
                                                                            'assets/images/angry2.png',
                                                                            Text('Angry', style: TextStyle(color: KColor.reactionOrange)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),

                                                              Row(
                                                                children: [
                                                                  if (commentRepliesState.commentModel[index].likeCount > 0)
                                                                    Text(
                                                                      "${commentRepliesState.commentModel[index].likeCount}",
                                                                      style: KTextStyle.caption.copyWith(
                                                                        color: KColor.black54,
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  const SizedBox(width: 4),
                                                                  if (commentRepliesState.commentModel[index].totalLikes!.isNotEmpty)
                                                                    SizedBox(
                                                                      width:
                                                                          commentRepliesState.commentModel[index].totalLikes!.length == 1 ? 20 : 40,
                                                                      child: Stack(
                                                                        children: [
                                                                          // ignore: prefer_is_empty
                                                                          if (commentRepliesState.commentModel[index].totalLikes!.length >= 1)
                                                                            ReactionEmojiComponent(
                                                                              reactionType:
                                                                                  "${commentRepliesState.commentModel[index].totalLikes![0].reactionType}",
                                                                              height: 18,
                                                                            ),
                                                                          if (commentRepliesState.commentModel[index].totalLikes!.length > 1)
                                                                            Positioned(
                                                                              right: 8,
                                                                              child: ReactionEmojiComponent(
                                                                                reactionType:
                                                                                    "${commentRepliesState.commentModel[index].totalLikes![1].reactionType}",
                                                                                height: 18,
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                        : Container(),
              ),
              Divider(color: KColor.black.withOpacity(0.2), height: 1),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfilePicture(
                      avatarRadius: 16,
                      iconSize: 15.5,
                      profileURL: userState is UserSuccessState ? userState.userModel.user!.profilePic : '',
                      slug: userState is UserSuccessState ? userState.userModel.user!.username : null,
                      userId: userState is UserSuccessState ? userState.userModel.user!.id : null,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                color: AppMode.darkMode ? KColor.grey850const : KColor.appBackground, borderRadius: BorderRadius.circular(15)),
                            child: TextField(
                              controller: commentController,
                              maxLines: 5,
                              minLines: 1,
                              cursorColor: KColor.grey,
                              onChanged: (value) {
                                if (value.trim().isEmpty) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _isDisabled = true;
                                    commentController.text = "";
                                  });
                                } else {
                                  setState(() {
                                    _isDisabled = false;
                                  });
                                }
                              },
                              keyboardType: TextInputType.multiline,
                              style: KTextStyle.bodyText1.copyWith(color: KColor.black),
                              decoration: InputDecoration(
                                hintText: "Write a reply...",
                                hintStyle: KTextStyle.bodyText2.copyWith(
                                  color: KColor.black54,
                                ),
                                contentPadding: const EdgeInsets.only(left: 10, right: 40, bottom: 10, top: 10),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          _isDisabled
                              ? Container()
                              : Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: InkWell(
                                    onTap: _isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              _isLoading = true;
                                            });

                                            await ref.read(commentRepliesProvider.notifier).createCommentReply(
                                                  commentText: commentController.text,
                                                  feedId: widget.commentData!.feedId,
                                                  feedUserId: widget.feedUserId,
                                                  parentId: widget.commentData!.id,
                                                  feedType: widget.feedType,
                                                );

                                            if (!mounted) return;
                                            setState(() {
                                              commentController.text = '';
                                              _isDisabled = true;
                                              _isLoading = false;
                                            });
                                          },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 5, top: 5, right: 5),
                                      alignment: Alignment.bottomRight,
                                      child: _isLoading
                                          ? const SizedBox(height: 25, width: 25, child: CupertinoActivityIndicator())
                                          : Icon(
                                              Ionicons.ios_send,
                                              size: 25,
                                              color: KColor.black,
                                            ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _editDeleteModal(context, CommentModel commentData) {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        useRootNavigator: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
        builder: (BuildContext bc) {
          return CommentOptionsModal(isReply: true, commentData: commentData, feedType: widget.feedType);
        });
  }
}
