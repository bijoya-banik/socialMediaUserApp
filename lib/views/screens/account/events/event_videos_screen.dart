import 'package:buddyscripts/controller/event/event_videos_controller.dart';
import 'package:buddyscripts/controller/event/state/event_videos_state.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_video_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventVideosScreen extends StatefulWidget {
  const EventVideosScreen({Key? key}) : super(key: key);

  @override
  _EventVideosScreenState createState() => _EventVideosScreenState();
}

class _EventVideosScreenState extends State<EventVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(title: 'Videos', automaticallyImplyLeading: false, hasLeading: true),
      child: Consumer(builder: (context, ref, _) {
        final eventVideosState = ref.watch(eventVideosProvider);

        return eventVideosState is EventVideosSuccessState
            ? CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () => ref.read(eventVideosProvider.notifier).fetchEventVideos(eventVideosState.eventVideosModel.basicOverView!.slug!),
                  ),
                  eventVideosState.eventVideosModel.videos!.isEmpty
                      ? SliverToBoxAdapter(
                          child:
                              SizedBox(height: MediaQuery.of(context).size.height / 2 + 20, child: const KContentUnvailableComponent(message: 'No videos')))
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          sliver: SliverToBoxAdapter(
                              child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: List.generate(eventVideosState.eventVideosModel.videos!.length, (index) {
                              return KVideoComponent(eventVideosState.eventVideosModel.videos![index].fileLoc);
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
