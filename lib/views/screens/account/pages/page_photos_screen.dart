import 'package:buddyscripts/controller/page/page_photos_controller.dart';
import 'package:buddyscripts/controller/page/state/page_photos_state.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/global_components/k_content_unavailable_component.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/global_components/k_image_slider.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PagePhotosScreen extends StatelessWidget {
  const PagePhotosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.appBackground,
      navigationBar: KCupertinoNavBar(title: 'Photos', automaticallyImplyLeading: false, hasLeading: true),
      child: Consumer(builder: (context, WidgetRef ref, _) {
        final pagePhotosState = ref.watch(pagePhotosProvider);

        return pagePhotosState is PagePhotosSuccessState
            ? CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () => ref.read(pagePhotosProvider.notifier).fetchPagePhotos(pagePhotosState.pagePhotosModel.basicOverView!.slug!),
                  ),
                  pagePhotosState.pagePhotosModel.photos!.isEmpty
                      ? SliverToBoxAdapter(
                          child:
                              SizedBox(height: MediaQuery.of(context).size.height / 2 + 20, child: const KContentUnvailableComponent(message: 'No photos')),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          sliver: SliverToBoxAdapter(
                            child: Center(
                                child: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: List.generate(pagePhotosState.pagePhotosModel.photos!.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        ScaleRoute(
                                            page: KImageSliderView(
                                          imagesList: List<String>.from(pagePhotosState.pagePhotosModel.photos!.map((model) => model.fileLoc)),
                                          initialPage: index,
                                        )));
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          API.baseUrl+ pagePhotosState.pagePhotosModel.photos![index].fileLoc!,
                                          height: KSize.getHeight(context, 125),
                                          width: MediaQuery.of(context).size.width * 0.29,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return const Center(child: CupertinoActivityIndicator());
                                          },
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Icon(Icons.error, color: KColor.black);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            )),
                          ),
                        ),
                ],
              )
            : const Center(child: CupertinoActivityIndicator());
      }),
    );
  }
}
