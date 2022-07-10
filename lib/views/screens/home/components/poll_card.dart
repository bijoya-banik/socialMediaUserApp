import 'package:buddyscripts/constants/shared_preference_constant.dart';
import 'package:buddyscripts/controller/feed/feed_controller.dart';
import 'package:buddyscripts/controller/feed/poll_option_voters_controller.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/views/global_components/dialogs/confirmation_dialog_content.dart';
import 'package:buddyscripts/views/global_components/dialogs/k_dialog.dart';
import 'package:buddyscripts/views/global_components/dialogs/processing_dialog_content.dart';
import 'package:buddyscripts/views/screens/home/poll_option_voters_screen.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

class PollCard extends ConsumerStatefulWidget {
  const PollCard({Key? key, required this.feedData, required this.feedType, required this.feedId, this.isShare = false}) : super(key: key);

  final FeedModel? feedData;
  final FeedType? feedType;
  final int? feedId;
  final bool isShare;

  @override
  _PollCardState createState() => _PollCardState();
}

class _PollCardState extends ConsumerState<PollCard> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                children: List.generate(widget.feedData!.poll!.pollOptions!.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (!widget.isShare)
                          SizedBox(
                              width: 25,
                              child: InkWell(
                                onTap: () async {
                                  if (widget.feedData!.poll!.isMultipleSelected == 1) {
                                    if (widget.feedData!.poll!.pollOptions![index].isVoted == null) {
                                      await ref.read(feedProvider.notifier).addVoteOption(
                                          feedId: widget.feedId!,
                                          pollId: widget.feedData!.pollId!,
                                          optionId: widget.feedData!.poll!.pollOptions![index].id!,
                                          feedType: widget.feedType!,
                                          mutipleOption: widget.feedData!.poll!.isMultipleSelected!,
                                          isVote: true);
                                    } else {
                                      await ref.read(feedProvider.notifier).addVoteOption(
                                          feedId: widget.feedId!,
                                          pollId: widget.feedData!.pollId!,
                                          optionId: widget.feedData!.poll!.pollOptions![index].id!,
                                          feedType: widget.feedType!,
                                          mutipleOption: widget.feedData!.poll!.isMultipleSelected!,
                                          isVote: false);
                                    }
                                  } else {
                                    dynamic voteId = widget.feedData!.poll?.isVotedOne?.optionId;

                                    if (voteId == widget.feedData!.poll!.pollOptions![index].id!) {
                                      await ref.read(feedProvider.notifier).addVoteOption(
                                          feedId: widget.feedId!,
                                          pollId: widget.feedData!.pollId!,
                                          optionId: widget.feedData!.poll!.pollOptions![index].id!,
                                          feedType: widget.feedType!,
                                          mutipleOption: widget.feedData!.poll!.isMultipleSelected!,
                                          isVote: false,
                                          prevVoteId: voteId,
                                          isVotePrev: true);
                                    } else {
                                      print("widget.feedId");
                                      print(widget.feedId);
                                      print(widget.feedData?.id);
                                      await ref.read(feedProvider.notifier).addVoteOption(
                                          feedId: widget.feedId!,
                                          pollId: widget.feedData!.pollId!,
                                          optionId: widget.feedData!.poll!.pollOptions![index].id!,
                                          feedType: widget.feedType!,
                                          mutipleOption: widget.feedData!.poll!.isMultipleSelected!,
                                          isVote: true,
                                          prevVoteId: voteId);
                                    }
                                  }
                                },
                                child: Icon(
                                    widget.feedData!.poll!.pollOptions![index].isVoted == null
                                        ? Icons.check_box_outline_blank_rounded
                                        : Icons.check_box,
                                    color: widget.feedData!.poll!.pollOptions![index].isVoted == null ? KColor.black54 : KColor.primary),
                              )),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 7),
                            decoration: BoxDecoration(border: Border.all(color: KColor.black45, width: 0.6), borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.feedData!.poll!.pollOptions![index].text ?? "",
                                  style: KTextStyle.subtitle2.copyWith(color: KColor.black, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Added by " +
                                      (widget.feedData!.poll!.pollOptions![index].userId == getIntAsync(USER_ID)
                                          ? "You"
                                          : (widget.feedData!.poll!.pollOptions![index].user?.firstName ?? "") +
                                              (" " + (widget.feedData!.poll!.pollOptions![index].user?.lastName ?? ""))),
                                  style: KTextStyle.subtitle2.copyWith(fontSize: 13, color: KColor.black87, fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!widget.isShare)
                          SizedBox(
                              width: 25,
                              child: InkWell(
                                onTap: () {
                                  if (widget.feedData!.poll!.pollOptions![index].userId == getIntAsync(USER_ID) ||
                                      widget.feedData!.userId == getIntAsync(USER_ID)) {
                                    KDialog.kShowDialog(
                                        context,
                                        ConfirmationDialogContent(
                                            titleShow: true,
                                            titleColor: KColor.primary,
                                            title: "Delete Option",
                                            titleContent: 'Are you sure that you want to delete this option from the poll?',
                                            buttonTextYes: "Delete",
                                            buttonTextNo: "Cancel",
                                            onPressedCallback: () => {
                                                  Navigator.pop(context),
                                                  KDialog.kShowDialog(
                                                    context,
                                                    const ProcessingDialogContent("Deleting..."),
                                                    barrierDismissible: false,
                                                  ),
                                                  ref.read(feedProvider.notifier).deletePollOption(
                                                      pollId: widget.feedData!.pollId!,
                                                      optionId: widget.feedData!.poll!.pollOptions![index].id!,
                                                      feedType: widget.feedType!)
                                                }),
                                        useRootNavigator: false);
                                  }
                                },
                                child: Icon(
                                  Icons.close,
                                  color: widget.feedData!.poll!.pollOptions![index].userId == getIntAsync(USER_ID) ||
                                          widget.feedData!.userId == getIntAsync(USER_ID)
                                      ? KColor.black54
                                      : KColor.transparent,
                                ),
                              )),
                      ],
                    ),
                    if (!widget.isShare)
                      if (widget.feedData!.poll!.pollOptions![index].voteOption!.isNotEmpty)
                        InkWell(
                          onTap: () {
                            ref
                                .read(pollOptionVotersProvider.notifier)
                                .fetchPollOptionVoters(widget.feedData!.poll!.id, widget.feedData!.poll!.pollOptions![index].id);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => PollOptionVotersScreen(
                                          pollId: widget.feedData!.poll!.id,
                                          optionId: widget.feedData!.poll!.pollOptions![index].id,
                                        )));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: widget.feedData!.poll!.pollOptions![index].voteOption!.length == 1
                                    ? 60
                                    : widget.feedData!.poll!.pollOptions![index].voteOption!.length == 2
                                        ? 80
                                        : 80,
                                child: Stack(
                                  children: [
                                    if (widget.feedData!.poll!.pollOptions![index].voteOption!.isNotEmpty)
                                      Container(
                                        margin: const EdgeInsets.only(left: 30),
                                        height: KSize.getHeight(context, 22.5),
                                        width: KSize.getWidth(context, 22.5),
                                        child: CircleAvatar(
                                            foregroundImage:
                                                NetworkImage(widget.feedData!.poll!.pollOptions![index].voteOption![0].user?.profilePic ?? "")),
                                      ),
                                    if (widget.feedData!.poll!.pollOptions![index].voteOption!.length > 1)
                                      Positioned(
                                          left: 48,
                                          child: SizedBox(
                                            height: KSize.getHeight(context, 22.5),
                                            width: KSize.getWidth(context, 22.5),
                                            child: CircleAvatar(
                                                foregroundImage:
                                                    NetworkImage(widget.feedData!.poll!.pollOptions![index].voteOption![1].user?.profilePic ?? "")),
                                          ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                child: Text(
                                  widget.feedData!.poll!.pollOptions![index].totalVote == 0
                                      ? ""
                                      : '${widget.feedData!.poll!.pollOptions![index].totalVote}' +
                                          (widget.feedData!.poll!.pollOptions![index].totalVote == 1 ? " vote" : " votes"),
                                  style: KTextStyle.subtitle2.copyWith(fontSize: 13, color: KColor.black, fontWeight: FontWeight.normal),
                                ),
                              )
                            ],
                          ),
                        )
                  ],
                ),
              );
            })),
            if (!widget.isShare)
              if (widget.feedData!.poll?.allowUserAddOption == 1)
                InkWell(
                  onTap: () {
                    showMessageDialog();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 5),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(color: KColor.black45, width: 0.6), borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      "+ Add an option",
                      style: KTextStyle.subtitle2.copyWith(color: KColor.black, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
            const SizedBox(height: 20)
          ],
        ));
  }

  Future showMessageDialog() {
    return showDialog(
      builder: (context) => Builder(builder: (BuildContext context) {
        textController.text = "";
        return AlertDialog(
          backgroundColor: KColor.appBackground,
          insetPadding: EdgeInsets.zero,
          title: Text('Add new poll option', style: KTextStyle.subtitle1.copyWith(color: KColor.black)),
          content: TextField(
            autofocus: true,
            cursorColor: KColor.grey,
            controller: textController,
            style: KTextStyle.subtitle1.copyWith(color: KColor.black87, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: KColor.grey),
              ),
            ),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                if (textController.text.isNotEmpty) {
                  Navigator.pop(context);
                  KDialog.kShowDialog(
                    context,
                    const ProcessingDialogContent("Processing..."),
                    barrierDismissible: false,
                  );
                  ref
                      .read(feedProvider.notifier)
                      .addPollOption(pollId: widget.feedData!.pollId!, text: textController.text, feedType: widget.feedType!);
                } else {
                  toast("Enter a option", bgColor: KColor.red);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Add", style: KTextStyle.subtitle2.copyWith(color: KColor.appThemeColor)),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Cancel", style: KTextStyle.subtitle2.copyWith(color: KColor.appThemeColor)),
              ),
            ),
          ],
        );
      }),
      context: context,
    );
  }
}
