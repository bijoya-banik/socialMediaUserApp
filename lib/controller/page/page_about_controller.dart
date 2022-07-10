import 'package:buddyscripts/controller/page/state/page_about_state.dart';
import 'package:buddyscripts/models/page/page_about_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageAboutProvider = StateNotifierProvider<PageAboutController,PageAboutState>(
  (ref) => PageAboutController(ref: ref),
);

class PageAboutController extends StateNotifier<PageAboutState> {
  final Ref? ref;
  PageAboutController({this.ref}) : super(const PageAboutInitialState());

  PageAboutModel? pageAboutModel;

  Future fetchPageAbout(String pageName) async {
    state = const PageAboutLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pageDetails(pageName, tab: 'about')),
      );
      if (responseBody != null) {
        pageAboutModel = PageAboutModel.fromJson(responseBody);
        state = PageAboutSuccessState(pageAboutModel!);
      } else {
        state = const PageAboutErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchPageAbout(): $error");
      print(stackTrace);
      state = const PageAboutErrorState();
    }
  }
}
