import 'package:buddyscripts/controller/group/group_about_controller.dart';
import 'package:buddyscripts/controller/group/state/group_about_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class GroupAboutScreen extends ConsumerWidget {
  GroupAboutScreen({Key? key}) : super(key: key);

  List<String> contentList = ['Admins and moderators', 'Friends', 'Others'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAboutState = ref.watch(groupAboutProvider);
    final groupAboutData = groupAboutState is GroupAboutSuccessState ? groupAboutState.groupAboutModel.basicOverView : null;

    return CupertinoPageScaffold(
      backgroundColor: KColor.white,
      navigationBar: groupAboutState is GroupAboutSuccessState
          ? KCupertinoNavBar(title: groupAboutState.groupAboutModel.basicOverView!.groupName, automaticallyImplyLeading: false, hasLeading: true)
          : null,
      child: groupAboutState is GroupAboutSuccessState
          ? CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(onRefresh: () => ref.read(groupAboutProvider.notifier).fetchGroupAbout(groupAboutData!.slug!)),
                SliverToBoxAdapter(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About',
                              style: KTextStyle.headline5.copyWith(
                                color: KColor.black,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(height: KSize.getHeight(context, 20)),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: Icon(Icons.people, color: KColor.black87),
                            title: Text(
                              '${groupAboutData!.totalMembers} Members',
                              style: KTextStyle.bodyText3.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: Icon(groupAboutData.groupPrivacy == 'ONLY ME' ? Icons.lock : Icons.public, color: KColor.black87),
                            title: Text(groupAboutData.groupPrivacy == 'ONLY ME' ? 'Private Group' : 'Public Group',
                                style: KTextStyle.subtitle1.copyWith(color: KColor.black87)),
                            isThreeLine: true,
                            subtitle: Text(
                                groupAboutData.groupPrivacy == 'ONLY ME'
                                    ? 'Only group member can see who\'s in the group and what they post'
                                    : 'Anyone can see who\'s in the group and what they post.',
                                style: KTextStyle.bodyText3.copyWith(color: KColor.black54)),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: Icon(Icons.remove_red_eye, color: KColor.black87),
                            title: Text('Visible', style: KTextStyle.subtitle1.copyWith(color: KColor.black87)),
                            isThreeLine: true,
                            subtitle: Text('Anyone can find this group.', style: KTextStyle.bodyText3.copyWith(color: KColor.black54)),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: Icon(Icons.info_outlined, color: KColor.black87),
                            title: Text(
                              groupAboutData.about ?? '',
                              style: KTextStyle.bodyText3.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 5,
                            dense: true,
                            leading: (groupAboutData.city == "" && groupAboutData.country == "") ||
                                    (groupAboutData.city == null && groupAboutData.country == null)
                                ? null
                                : Icon(Icons.location_on, color: KColor.black87),
                            title: Text(
                              //groupAboutData.city,
                              (groupAboutData.city == "" && groupAboutData.country == "") ||
                                      (groupAboutData.city == null && groupAboutData.country == null)
                                  ? ""
                                  : (groupAboutData.city == "" || groupAboutData.city == null ? "" : '${groupAboutData.city}') +
                                      (groupAboutData.city == "" || groupAboutData.country == "" ? "" : " , ") +
                                      (groupAboutData.country == "" || groupAboutData.country == null ? "" : '${groupAboutData.country}'),
                              style: KTextStyle.bodyText3.copyWith(color: KColor.black87, height: KSize.getHeight(context, 1.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            )
          : const Center(child: CupertinoActivityIndicator()),
    );
  }
}
