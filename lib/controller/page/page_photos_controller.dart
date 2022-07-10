import 'package:buddyscripts/controller/page/state/page_photos_state.dart';
import 'package:buddyscripts/models/page/page_photos_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pagePhotosProvider = StateNotifierProvider<PagePhotosController,PagePhotosState>(
  (ref) => PagePhotosController(ref: ref),
);

class PagePhotosController extends StateNotifier<PagePhotosState> {
  final Ref? ref;
  PagePhotosController({this.ref}) : super(const PagePhotosInitialState());

  PagePhotosModel? pagePhotosModel;

  Future fetchPagePhotos(String pageName) async {
    state = const PagePhotosLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pageDetails(pageName, tab: 'photos')),
      );
      if (responseBody != null) {
        pagePhotosModel = PagePhotosModel.fromJson(responseBody);
        state = PagePhotosSuccessState(pagePhotosModel!);
      } else {
        state = const PagePhotosErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchPagePhotos(): $error");
      print(stackTrace);
      state = const PagePhotosErrorState();
    }
  }
}
