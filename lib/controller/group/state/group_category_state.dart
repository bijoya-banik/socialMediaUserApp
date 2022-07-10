import 'package:buddyscripts/models/group/group_category_model.dart';

abstract class GroupCategoryState {
    const GroupCategoryState();
}
class GroupCategoryInitialState extends GroupCategoryState {
    const GroupCategoryInitialState();
}
class GroupCategoryLoadingState extends GroupCategoryState {
    const GroupCategoryLoadingState();
}
class GroupCategorySuccessState extends GroupCategoryState {
   List<GroupCategoryModel> groupCategoryModel;
   GroupCategorySuccessState(this.groupCategoryModel);
}
class GroupCategoryErrorState extends GroupCategoryState {
    const GroupCategoryErrorState();
}