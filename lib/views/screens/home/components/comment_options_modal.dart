//

import 'package:buddyscripts/controller/comment/comment_controller.dart';
import 'package:buddyscripts/controller/comment/comment_reply_controller.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/models/feed/comment_model.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddyscripts/views/screens/home/components/edit_comment_modal.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class CommentOptionsModal extends ConsumerStatefulWidget {
  final bool isReply;
  final CommentModel? commentData;
  final FeedType? feedType;
  const CommentOptionsModal({Key? key, this.isReply = false, this.commentData, this.feedType}) : super(key: key);

  @override
  _CommentOptionsModalState createState() => _CommentOptionsModalState();
}

class _CommentOptionsModalState extends ConsumerState<CommentOptionsModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: KColor.white,
      height: MediaQuery.of(context).size.height * 0.225,
      child: Column(
        children: <Widget>[
          Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  width: 65,
                  height: 5,
                  decoration: BoxDecoration(color: KColor.grey200, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(25)))),
          ListTile(
            leading: CircleAvatar(
              radius: 23.0,
              backgroundColor: KColor.black.withOpacity(0.1),
              child: Icon(Icons.edit, color: KColor.black),
            ),
            title: Text(
              'Edit',
              style: KTextStyle.bodyText1.copyWith(color: KColor.black),
            ),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  elevation: 5,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  backgroundColor: KColor.white,
                  builder: (context) {
                    return EditCommentModal(isReply: widget.isReply, commentData: widget.commentData!);
                  });
            },
          ),
          ListTile( 
            leading: CircleAvatar(
              radius: 23.0,
              backgroundColor: KColor.red!.withOpacity(0.1),
              child: Icon(Icons.delete, color: KColor.red),
            ),
            title: Text(
              'Delete',
              style: KTextStyle.bodyText1.copyWith(color: KColor.black),
            ),
            onTap: () async {
          
              KDialog.kShowDialog(
                context,
                ConfirmationDialogContent(
                  titleContent: widget.isReply?"Are you sure want to delete this reply?":"Are you sure want to delete this comment?",
                  titleColor: KColor.primary,
                  onPressedCallback: () async => {
                    Navigator.pop(context),
                    KDialog.kShowDialog(
                      context,
                      const ProcessingDialogContent("Deleting..."),
                      barrierDismissible: false,
                    ),
                    widget.isReply
                        ? await ref.read(commentRepliesProvider.notifier).deleteCommentReply(
                              commentId: widget.commentData!.id,
                              feedId: widget.commentData!.feedId,
                              parentId: widget.commentData!.parrentId,
                              feedType: widget.feedType,
                            )
                        : await ref
                            .read(commentsProvider.notifier)
                            .deleteComment(commentId: widget.commentData!.id, feedId: widget.commentData!.feedId, feedType: widget.feedType),
                    Navigator.pop(context),
                    Navigator.pop(context)
                  },
                ),
                useRootNavigator: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
