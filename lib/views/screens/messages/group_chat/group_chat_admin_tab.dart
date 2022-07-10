import 'package:buddyscripts/controller/chat/group_chat_admin_controller.dart';
import 'package:buddyscripts/controller/chat/group_chat_member_controller.dart';
import 'package:buddyscripts/controller/chat/state/group_chat_admin_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_member_loading_indicator.dart';
import 'package:buddyscripts/views/screens/messages/components/group_chat_member_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupChatAdminTab extends ConsumerWidget {
  final int? chatId;
    const GroupChatAdminTab({Key? key,required this.chatId }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupChatAdminState = ref.watch(groupChatAdminProvider);

    return RefreshIndicator (
      onRefresh:()async {
         ref.read(groupChatMemberProvider.notifier).fetchGroupChatAllMembers(chatId!);
          ref.read(groupChatAdminProvider.notifier).fetchGroupChatAdmins(chatId!);
           
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        
        child: 
        groupChatAdminState is GroupChatAdminSuccessState
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  groupChatAdminState.groupChatAdminModel.isNotEmpty
                      ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            children: List.generate(groupChatAdminState.groupChatAdminModel.length, (index) {



                            return GroupChatMemberCard(groupMember: groupChatAdminState.groupChatAdminModel[index], admin: false);
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
