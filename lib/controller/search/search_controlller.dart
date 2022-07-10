import 'package:buddyscripts/controller/search/state/search_state.dart';
import 'package:buddyscripts/models/event/events_model.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/models/group/groups_model.dart';
import 'package:buddyscripts/models/page/pages_model.dart';
import 'package:buddyscripts/models/search/people_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = StateNotifierProvider<SearchController,SearchState>(
  (ref) => SearchController(ref: ref),
);

class SearchController extends StateNotifier<SearchState> {
  final Ref? ref;
  SearchController({this.ref}) : super(const SearchInitialState());

  dynamic response;

  Future search(str, {tab = 'feed'}) async {
    state = const SearchLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.search(str, tab: tab)));
      if (responseBody != null) {
        response = tab == 'people'
            ? (responseBody['peopleData'] as List<dynamic>).map((x) => PeopleModel.fromJson(x)).toList()
            : tab == 'group'
                ? (responseBody['groupData'] as List<dynamic>).map((x) => GroupDatum.fromJson(x)).toList()
                : tab == 'page'
                    ? (responseBody['pageData'] as List<dynamic>).map((x) => PageDatum.fromJson(x)).toList()
                    : tab == 'event'
                        ? (responseBody['eventData'] as List<dynamic>).map((x) => EventDatum.fromJson(x)).toList()
                        : (responseBody['feedData'] as List<dynamic>).map((x) => FeedModel.fromJson(x)).toList();
        state = SearchSuccessState(response);
      } else {
        state = const SearchErrorState();
      }
    } catch (error, stackTrace) {
      print("search(): $error");
      print(stackTrace);
      state = const SearchErrorState();
    }
  }

  updateSuccessState(feedList) {
    state = SearchSuccessState(feedList);
  }

  resetSearchSuccessState() {
    state = const SearchSuccessState([]);
  }
}
