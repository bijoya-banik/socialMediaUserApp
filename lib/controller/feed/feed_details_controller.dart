import 'package:buddyscripts/controller/feed/state/feed_details_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedDetailsProvider = StateNotifierProvider<FeedDetailsController, FeedDetailsState>((ref) {
  return FeedDetailsController(ref: ref);
});

class FeedDetailsController extends StateNotifier<FeedDetailsState> {
  final Ref? ref;
  FeedDetailsController({this.ref}) : super(const FeedDetailsInitialState());

  FeedModel? feedDetailsModel;

  Future fetchFeedDetails(id) async {
    state = const FeedDetailsLoadingState();

    dynamic responseBody;

    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.feedDetails(id)));
      if (responseBody != null) {
        feedDetailsModel = FeedModel.fromJson(responseBody[0]);
        state = FeedDetailsSuccessState(feedDetailsModel!);
      } else {
        state = const FeedDetailsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FeedDetailsErrorState();
    }
  }

  updateDetailsSuccessState(feedDetailsModel) {
    state = FeedDetailsSuccessState(feedDetailsModel);
  }
}
