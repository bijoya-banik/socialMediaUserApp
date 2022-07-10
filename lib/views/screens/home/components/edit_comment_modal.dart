import 'package:buddyscripts/controller/comment/comment_controller.dart';
import 'package:buddyscripts/controller/comment/comment_reply_controller.dart';
import 'package:buddyscripts/models/feed/comment_model.dart';
import 'package:buddyscripts/services/app_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/global_components/k_button.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class EditCommentModal extends ConsumerStatefulWidget {
  final bool isReply;
  final CommentModel? commentData;
  const EditCommentModal({Key? key, this.isReply = false, this.commentData}) : super(key: key);

  @override
  _EditCommentModalState createState() => _EditCommentModalState();
}

class _EditCommentModalState extends ConsumerState<EditCommentModal> {
  bool _isLoading = false;
  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    msgController.text = widget.commentData?.commentTxt ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Scaffold(
        backgroundColor: AppMode.darkMode ? KColor.appBackground : KColor.whiteConst,
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios, size: 16, color: KColor.black),
                  ),
                  Expanded(
                    child: Text(
                      widget.isReply ? "Edit Reply" : "Edit Comment",
                      textAlign: TextAlign.center,
                      style: KTextStyle.subtitle2.copyWith(color: KColor.black),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: KColor.grey, height: 1),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UserProfilePicture(profileURL: widget.commentData?.user?.profilePic, avatarRadius: 17, iconSize: 16.5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: AppMode.darkMode ? KColor.grey850const : KColor.appBackground, borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: msgController,
                                autofocus: true,
                                maxLines: 15,
                                minLines: 1,
                                cursorColor: KColor.grey,
                                style: KTextStyle.bodyText1.copyWith(color: KColor.black),
                                decoration: InputDecoration(
                                  hintText: widget.isReply ? "Write a reply..." : "Write a comment...",
                                  hintStyle: TextStyle(color: KColor.black54),
                                  contentPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 10, top: 10),
                  width: KSize.getWidth(context, 75),
                  child: KButton(
                    title: 'Cancel',
                    color: AppMode.darkMode ? KColor.grey800const! : KColor.greyconst,
                    textColor: KColor.whiteConst,
                    innerPadding: 10,
                    onPressedCallback: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10, top: 10),
                  width: KSize.getWidth(context, _isLoading ? 120 : 75),
                  child: KButton(
                    title: _isLoading ? 'Please wait...' : 'Save',
                    color: _isLoading ? KColor.grey : KColor.buttonBackground,
                    innerPadding: 10,
                    onPressedCallback: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });

                            widget.isReply
                                ? await ref.read(commentRepliesProvider.notifier).updateCommentReply(
                                      commentReplyData: widget.commentData,
                                      commentReplyText: msgController.text,
                                    )
                                : await ref.read(commentsProvider.notifier).updateComment(
                                      commentText: msgController.text,
                                      commentData: widget.commentData,
                                    );
                            Navigator.pop(context);

                            if (!mounted) return;
                            setState(() {
                              _isLoading = false;
                            });
                          },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
