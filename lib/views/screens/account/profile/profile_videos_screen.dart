import 'package:buddyscripts/controller/profile/profile_videos_controller.dart';
import 'package:buddyscripts/controller/profile/state/profile_videos_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_video_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileVideosScreen extends StatefulWidget {
  const ProfileVideosScreen({Key? key}) : super(key: key);

  @override
  _ProfileVideosScreenState createState() => _ProfileVideosScreenState();
}

class _ProfileVideosScreenState extends State<ProfileVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(title: 'Videos', automaticallyImplyLeading: false, hasLeading: true),
      child: Consumer(builder: (context, ref, _) {
        final profileVideosState = ref.watch(profileVideosProvider);

        return profileVideosState is ProfileVideosSuccessState
            ? CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () =>
                        ref.read(profileVideosProvider.notifier).fetchProfileVideos(profileVideosState.profileVideosModel.basicOverView!.username!),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    sliver: SliverToBoxAdapter(
                        child: profileVideosState.profileVideosModel.videos!.isEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                                child: const KContentUnvailableComponent(message: 'No videos'))
                            : Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: List.generate(profileVideosState.profileVideosModel.videos!.length, (index) {
                                  return SizedBox(
                                      height: KSize.getHeight(context, 300),
                                      width: MediaQuery.of(context).size.width,
                                      child: KVideoComponent(profileVideosState.profileVideosModel.videos![index].fileLoc));
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
