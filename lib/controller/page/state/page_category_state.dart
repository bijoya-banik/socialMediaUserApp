import 'package:buddyscripts/models/page/page_category_model.dart';

abstract class PageCategoryState {
    const PageCategoryState();
}
class PageCategoryInitialState extends PageCategoryState {
    const PageCategoryInitialState();
}
class PageCategoryLoadingState extends PageCategoryState {
    const PageCategoryLoadingState();
}
class PageCategorySuccessState extends PageCategoryState {
   List<PageCategoryModel> pageCategoryModel;
   PageCategorySuccessState(this.pageCategoryModel);
}
class PageCategoryErrorState extends PageCategoryState {
    const PageCategoryErrorState();
}