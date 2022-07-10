import 'package:buddyscripts/controller/page/state/my_pages_state.dart';
import 'package:buddyscripts/controller/pagination/page/my_pages_tab.dart';
import 'package:buddyscripts/models/page/pages_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myPagesProvider = StateNotifierProvider<MyPagesController,MyPagesState>(
  (ref) => MyPagesController(ref: ref),
);

class MyPagesController extends StateNotifier<MyPagesState> {
  final Ref? ref;
  MyPagesController({this.ref}) : super(const MyPagesInitialState());

  PagesModel? myPagesModel;
  int currentPage = 1;

  updateSuccessState(PagesModel pagesModel) {
    myPagesModel = pagesModel;
    state = MyPagesSuccessState(myPagesModel!);
  }

  Future fetchMyPages() async {
    state = const MyPagesLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pages()),
      );
      if (responseBody != null) {
        myPagesModel = PagesModel.fromJson(responseBody);
        currentPage = myPagesModel!.meta!.currentPage;
        state = MyPagesSuccessState(myPagesModel!);
      } else {
        state = const MyPagesErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMyPages(): $error");
      print(stackTrace);
      state = const MyPagesErrorState();
    }
  }

  Future fetchMoreMyPages() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pages(page: currentPage += 1)),
      );
      if (responseBody != null) {
        var myPagesModelInstance = PagesModel.fromJson(responseBody);
        myPagesModel!.data!.addAll(myPagesModelInstance.data!);
        state = MyPagesSuccessState(myPagesModel!);
        ref!.read(myPagesScrollProvider.notifier).resetState();
      } else {
        state = const MyPagesErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreMyPages(): $error");
      print(stackTrace);
      state = const MyPagesErrorState();
    }
  }
}
