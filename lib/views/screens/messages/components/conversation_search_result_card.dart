import 'package:buddyscripts/models/chats/conversation_search_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buddyscripts/views/global_components/user_name.dart';
import 'package:buddyscripts/views/global_components/user_profile_picture.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class ConversationSearchResultCard extends ConsumerWidget {
  final ConversationSearchResultModel conversation;
  final bool share;

  const ConversationSearchResultCard(this.conversation, {Key? key, this.share = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        // if (!share) {
        //   FocusScope.of(context).unfocus();
        //   ref.read(chatProvider.notifier).fetchChat(conversation.id, conversation.isOnline);

        //   Navigator.push(
        //       context,
        //       CupertinoPageRoute(
        //           builder: (context) => ChatScreen(
        //                 id: conversation.id,
        //                 firstName: conversation.firstName,
        //                 lastName: conversation.lastName,
        //                 userName: conversation.username,
        //                 profilePic: conversation.profilePic,
        //               )));
        // }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: KColor.appBackground,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserProfilePicture(profileURL: conversation.profilePic, avatarRadius: 25, onTapNavigate: false, iconSize: 24.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: UserName(
                          name: "${conversation.firstName} ${conversation.lastName}",
                          onTapNavigate: false,
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
    );
  }
}
