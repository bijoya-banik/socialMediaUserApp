import 'package:buddyscripts/controller/chat/conversation_search_controller.dart';
import 'package:buddyscripts/views/screens/messages/group_chat/add_participant_screen.dart';
import 'package:buddyscripts/views/screens/messages/group_chat/group_chat_admin_tab.dart';
import 'package:buddyscripts/views/screens/messages/group_chat/group_chat_members_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable

class GroupChatAllMembersScreen extends ConsumerStatefulWidget {
  final int? chatId;
  final bool admin;
  const GroupChatAllMembersScreen({Key? key, required this.chatId, required this.admin}) : super(key: key);

  @override
  _GroupChatAllMembersScreenState createState() => _GroupChatAllMembersScreenState();
}

class _GroupChatAllMembersScreenState extends ConsumerState<GroupChatAllMembersScreen> {
  List tabs = ['ALL', 'ADMIN'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: KColor.darkAppBackground,
        appBar: AppBar(
          backgroundColor: KColor.secondary,
          elevation: 1,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 18, color: KColor.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Visibility(
              visible: widget.admin,
              child: TextButton(
                  onPressed: () {
                    ref.read(conversationSearchResultProvider.notifier).refresh([]);
                    Navigator.of(context, rootNavigator: true)
                        .push(CupertinoPageRoute(builder: (context) => AddParticipateScreen(isGroup: 1, inboxId: widget.chatId)));
                  },
                  child: Text("ADD", style: KTextStyle.subtitle2.copyWith(color: KColor.black))),
            )
          ],
          centerTitle: true,
          title: Text('Members', style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.w500, color: KColor.black)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(46),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                isScrollable: true,
                labelColor: KColor.black,
                labelStyle: KTextStyle.subtitle2,
                tabs: List.generate(tabs.length, (index) {
                  return Tab(text: "${tabs[index]}");
                }),
                indicatorColor: KColor.buttonBackground,
                unselectedLabelColor: KColor.black54,
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: KSize.getHeight(context, 5)),
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [GroupChatMemberTab(chatId: widget.chatId, admin: widget.admin), GroupChatAdminTab(chatId: widget.chatId)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
