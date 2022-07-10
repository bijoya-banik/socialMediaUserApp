import 'package:buddyscripts/controller/group/state/group_category_state.dart';
import 'package:buddyscripts/models/group/group_category_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupCategoryProvider = StateNotifierProvider<GroupCategoryController,GroupCategoryState>(
  (ref) => GroupCategoryController(ref: ref),
);

class GroupCategoryController extends StateNotifier<GroupCategoryState> {
  final Ref? ref;
  GroupCategoryController({this.ref}) : super(const GroupCategoryInitialState());

  List<GroupCategoryModel> groupCategoryList = [];

  Future fetchGroupCategory() async {
    state = const GroupCategoryLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.groupCategory));
      print(responseBody);
      if (responseBody != null) {
        groupCategoryList = (responseBody as List<dynamic>).map((x) => GroupCategoryModel.fromJson(x)).toList();
        state = GroupCategorySuccessState(groupCategoryList);
      } else {
        state = const GroupCategoryErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const GroupCategoryErrorState();
    }
  }
}
