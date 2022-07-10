import 'package:buddyscripts/controller/chat/group_chat_member_controller.dart';
import 'package:buddyscripts/controller/chat/state/group_chat_member_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_member_loading_indicator.dart';
import 'package:buddyscripts/views/screens/messages/components/group_chat_member_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupChatMemberTab extends ConsumerWidget {
  final int? chatId;
  final bool admin;
    const GroupChatMemberTab({Key? key,required this.chatId, required this.admin }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupChatMemberState = ref.watch(groupChatMemberProvider);

    return RefreshIndicator (
      onRefresh:()async {
          ref.read(groupChatMemberProvider.notifier).fetchGroupChatAllMembers(chatId!);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        
        child: 
        groupChatMemberState is GroupChatMemberSuccessState
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  groupChatMemberState.groupChatAllMemberModel.isNotEmpty
                      ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            children: List.generate(groupChatMemberState.groupChatAllMemberModel.length, (index) {
                            return GroupChatMemberCard(groupMember: groupChatMemberState.groupChatAllMemberModel[index], admin: admin);
                          })),
                      )
                      : Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                          child: const KContentUnvailableComponent(message: 'No members available')),
                ],
              )
            :
              const KMemberLoadingIndicator(),
      ),
    );
  }
}
