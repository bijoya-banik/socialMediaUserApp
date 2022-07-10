import 'package:buddyscripts/controller/page/page_videos_controller.dart';
import 'package:buddyscripts/controller/page/state/page_videos_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_video_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageVideosScreen extends StatefulWidget {
  const PageVideosScreen({Key? key}) : super(key: key);

  @override
  _PageVideosScreenState createState() => _PageVideosScreenState();
}

class _PageVideosScreenState extends State<PageVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(title: 'Videos', automaticallyImplyLeading: false, hasLeading: true),
      child: Consumer(builder: (context, WidgetRef ref, _) {
        final pageVideosState = ref.watch(pageVideosProvider);

        return pageVideosState is PageVideosSuccessState
            ? CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () => ref.read(pageVideosProvider.notifier).fetchPageVideos(pageVideosState.pageVideosModel.basicOverView!.slug!),
                  ),
                  pageVideosState.pageVideosModel.videos!.isEmpty
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
                            children: List.generate(pageVideosState.pageVideosModel.videos!.length, (index) {
                              return KVideoComponent(pageVideosState.pageVideosModel.videos![index].fileLoc);
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
