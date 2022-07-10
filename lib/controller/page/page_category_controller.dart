import 'package:buddyscripts/controller/page/state/page_category_state.dart';
import 'package:buddyscripts/models/page/page_category_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageCategoryProvider = StateNotifierProvider<PageCategoryController,PageCategoryState>(
  (ref) => PageCategoryController(ref: ref),
);

class PageCategoryController extends StateNotifier<PageCategoryState> {
  final Ref? ref;
  PageCategoryController({this.ref}) : super(const PageCategoryInitialState());

  List<PageCategoryModel> pageCategoryList = [];

  Future fetchPageCategory() async {
    state = const PageCategoryLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.pageCategory));
      print(responseBody);
      if (responseBody != null) {
        pageCategoryList.clear();
        pageCategoryList.add(PageCategoryModel(name: "Select Category", id: -1));
        var pageCategoryListInstance = (responseBody as List<dynamic>).map((x) => PageCategoryModel.fromJson(x)).toList();
        pageCategoryList.addAll(pageCategoryListInstance);

        state = PageCategorySuccessState(pageCategoryList);
      } else {
        state = const PageCategoryErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const PageCategoryErrorState();
    }
  }
}
