import 'package:buddyscripts/controller/group/group_members_controller.dart';
import 'package:buddyscripts/controller/group/state/group_members_state.dart';
import 'package:buddyscripts/views/global_components/loading_indicators/k_pages_loading_inidcator.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/screens/account/components/group_member_card.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class GroupMembersScreen extends ConsumerWidget {
  GroupMembersScreen({Key? key}) : super(key: key);

  List<String> contentList = ['Admins and moderators', 'All Members'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupMembersState = ref.watch(groupMembersProvider);
    final groupMembersData = groupMembersState is GroupMembersSuccessState ? groupMembersState.groupMembersModel : null;
    return CupertinoPageScaffold(
      backgroundColor: KColor.white,
      navigationBar: KCupertinoNavBar(
        title: 'Members',
        automaticallyImplyLeading: false,
        hasLeading: true,
      ),
      child: groupMembersState is GroupMembersSuccessState
          ? CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                CupertinoSliverRefreshControl(
                    onRefresh: () => ref.read(groupMembersProvider.notifier).fetchGroupMembers(groupMembersData!.basicOverView!.slug!)),
                SliverToBoxAdapter(
                    child: Column(
                  children: [
                    Column(
                      children: List.generate(groupMembersData!.allMembers!.isEmpty ? contentList.length - 1 : contentList.length, (index) {
                        return Column(
                          children: [
                            Container(
                              color: KColor.appBackground,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Text(contentList[index], style: KTextStyle.subtitle1.copyWith(fontWeight: FontWeight.bold, color: KColor.black)),
                            ),
                            Column(
                              children: List.generate(index == 0 ? groupMembersData.adminAndModerators!.length : groupMembersData.allMembers!.length,
                                  (ind) {
                                return GroupMemberCard(
                                    basicOverView: groupMembersData.basicOverView,
                                    groupMemberData: index == 0 ?
                                     groupMembersData.adminAndModerators![ind] : groupMembersData.allMembers![ind]);
                              }),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                )),
              ],
            )
          : const KPagesLoadingIndicator(),
    );
  }
}
