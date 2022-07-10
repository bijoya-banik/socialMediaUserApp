import 'package:buddyscripts/controller/feed/state/report_feed_state.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:buddyscripts/services/navigation_service.dart';
import 'package:buddyscripts/views/styles/k_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

final reportFeedProvider = StateNotifierProvider<ReportFeedRepository,ReportFeedState>(
  (ref) => ReportFeedRepository(),
);

class ReportFeedRepository extends StateNotifier<ReportFeedState> {
  ReportFeedRepository() : super(const ReportFeedInitialState());

  Future reportFeed({feed, String? reportType, String? reportText}) async {
    state = const ReportFeedLoadingState();

    var requestBody = {
      'feed_id': feed.id,
      'feed_type': reportType,
      'text': reportText,
    };
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.postRequest(API.reportFeed, requestBody),
      );
      if (responseBody != null) {
        state = const ReportFeedSuccessState();
        toast('Report submitted successfully!', bgColor: KColor.green);
        NavigationService.popNavigate();
      } else {
        state = const ReportFeedErrorState();
      }
    } catch (error) {
      state = const ReportFeedErrorState();
    }
  }
}
