import 'package:buddyscripts/controller/page/state/discover_pages_state.dart';
import 'package:buddyscripts/controller/pagination/page/discover_pages_tab.dart';
import 'package:buddyscripts/models/page/pages_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final discoverPagesProvider = StateNotifierProvider<DiscoverPagesController,DiscoverPagesState>(
  (ref) => DiscoverPagesController(ref: ref),
);

class DiscoverPagesController extends StateNotifier<DiscoverPagesState> {
  final Ref? ref;
  DiscoverPagesController({this.ref}) : super(const DiscoverPagesInitialState());

  PagesModel? discoverPagesModel;
  int currentPage = 1;

  updateSuccessState(PagesModel discoverPages) {
    discoverPagesModel = discoverPages;
    state = DiscoverPagesSuccessState(discoverPagesModel!);
  }

  Future fetchDiscoverPages() async {
    state = const DiscoverPagesLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pages(tab: 'discover')),
      );
      if (responseBody != null) {
        discoverPagesModel = PagesModel.fromJson(responseBody);
        currentPage = discoverPagesModel!.meta!.currentPage;
        state = DiscoverPagesSuccessState(discoverPagesModel!);
      } else {
        state = const DiscoverPagesErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchDiscoverPages(): $error");
      print(stackTrace);
      state = const DiscoverPagesErrorState();
    }
  }

  Future fetchMoreDiscoverPages() async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pages(tab: 'discover', page: currentPage += 1)),
      );
      if (responseBody != null) {
        var discoverPagesModelInstance = PagesModel.fromJson(responseBody);
        discoverPagesModel!.data!.addAll(discoverPagesModelInstance.data!);
        state = DiscoverPagesSuccessState(discoverPagesModel!);
        ref!.read(discoverPagesScrollProvider.notifier).resetState();
      } else {
        state = const DiscoverPagesErrorState();
      }
    } catch (error, stackTrace) {
      print("fetchMoreDiscoverPages(): $error");
      print(stackTrace);
      state = const DiscoverPagesErrorState();
    }
  }
}
