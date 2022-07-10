import 'package:buddyscripts/controller/group/group_videos_controller.dart';
import 'package:buddyscripts/controller/group/state/group_videos_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_video_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupVideosScreen extends StatefulWidget {
  const GroupVideosScreen({Key? key}) : super(key: key);

  @override
  _GroupVideosScreenState createState() => _GroupVideosScreenState();
}

class _GroupVideosScreenState extends State<GroupVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(title: 'Videos', automaticallyImplyLeading: false, hasLeading: true),
      child: Consumer(builder: (context, ref, _) {
        final groupVideosState = ref.watch(groupVideosProvider);

        return groupVideosState is GroupVideosSuccessState
            ? CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () => ref.read(groupVideosProvider.notifier).fetchGroupVideos(groupVideosState.groupVideosModel.basicOverView!.slug!),
                  ),
                  groupVideosState.groupVideosModel.videos!.isEmpty
                      ? SliverToBoxAdapter(
                          child:
                              SizedBox(height: MediaQuery.of(context).size.height / 2 + 20, child: const KContentUnvailableComponent(message: 'No videos')),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          sliver: SliverToBoxAdapter(
                              child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: List.generate(groupVideosState.groupVideosModel.videos!.length, (index) {
                              return KVideoComponent(groupVideosState.groupVideosModel.videos![index].fileLoc);
                            }),
                          )),
                        ),
                ],
              )
            : const Center(child: CupertinoActivityIndicator());
      }),
    );
  }
}
