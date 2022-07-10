import 'package:buddyscripts/controller/pagination/page/page_feed_tab.dart';
import 'package:buddyscripts/controller/page/state/page_feed_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/page/page_feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageFeedProvider = StateNotifierProvider<PageFeedController,PageFeedState>(
  (ref) => PageFeedController(ref: ref),
);

class PageFeedController extends StateNotifier<PageFeedState> {
  final Ref? ref;
  PageFeedController({this.ref}) : super(const PageFeedInitialState());

  PageFeedModel? pageFeedList;

  updateSuccessState(List<FeedModel> feedList) {
    if (pageFeedList != null) pageFeedList!.feedData = feedList;
    state = PageFeedSuccessState(pageFeedList!);
  }

  updatePageDetails(BasicOverView? pageDetails) {
    if (pageFeedList != null) pageFeedList!.basicOverView = pageDetails;
    state = PageFeedSuccessState(pageFeedList ?? PageFeedModel());
  }

  Future fetchPageFeed(String userName) async {
    state = const PageFeedLoadingState();

    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.pageDetails(userName)));

      if (responseBody != null) {
        pageFeedList = PageFeedModel.fromJson(responseBody);
        state = PageFeedSuccessState(pageFeedList!);
      } else {
        state = const PageFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const PageFeedErrorState();
    }
  }

  Future fetchMorePageFeed(String userName) async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.pageDetails(userName, lastId: pageFeedList!.feedData!.last.id)));

      if (responseBody != null) {
        var pageFeedModelInstance = (responseBody['feedData'] as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();
        pageFeedList!.feedData!.addAll(pageFeedModelInstance);
        state = PageFeedSuccessState(pageFeedList!);
        ref!.read(pageFeedScrollProvider.notifier).resetState();
      } else {
        state = const PageFeedErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const PageFeedErrorState();
    }
  }
}
