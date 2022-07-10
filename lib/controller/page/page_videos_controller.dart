import 'package:buddyscripts/controller/page/state/page_videos_state.dart';
import 'package:buddyscripts/models/page/page_videos_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageVideosProvider = StateNotifierProvider<PageVideosController,PageVideosState>(
  (ref) => PageVideosController(ref: ref),
);

class PageVideosController extends StateNotifier<PageVideosState> {
  final Ref? ref;
  PageVideosController({this.ref}) : super(const PageVideosInitialState());

  PageVideosModel? pageVideosModel;

  Future fetchPageVideos(String pageName) async {
    state = const PageVideosLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pageDetails(pageName, tab: 'videos')),
      );
      if (responseBody != null) {
        pageVideosModel = PageVideosModel.fromJson(responseBody);
        state = PageVideosSuccessState(pageVideosModel!);
      } else {
        state = const PageVideosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchPageVideos(): $error");
      print(stackTrace);
      state = const PageVideosErrorState();
    }
  }
}
