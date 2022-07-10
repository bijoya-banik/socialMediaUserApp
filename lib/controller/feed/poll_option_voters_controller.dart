import 'package:buddyscripts/controller/feed/state/poll_option_voters_state.dart';
import 'package:buddyscripts/controller/pagination/poll/poll_option_voters_scroll_provider.dart';
import 'package:buddyscripts/models/feed/poll_option_voters_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pollOptionVotersProvider = StateNotifierProvider<PollOptionVotersController, PollOptionVotersState>(
  (ref) => PollOptionVotersController(ref: ref),
);

class PollOptionVotersController extends StateNotifier<PollOptionVotersState> {
  final Ref? ref;
  PollOptionVotersController({this.ref}) : super(const PollOptionVotersInitialState());

  List<PollOptionVotersModel> pollOptionVotersModel = [];

  Future fetchPollOptionVoters(pollId, optionId) async {
    state = const PollOptionVotersLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.pollOptionVoters(pollId: pollId, optionId: optionId)),
      );
      if (responseBody != null) {
        pollOptionVotersModel = (responseBody as List<dynamic>).map((x) => PollOptionVotersModel.fromJson(x)).toList();

        state = PollOptionVotersSuccessState(pollOptionVotersModel);
      } else {
        state = const PollOptionVotersErrorState();
      }
    } catch (error, stackTrace) {
      print('fetchPollOptionVoters() error = $error');
      print(stackTrace);
      state = const PollOptionVotersErrorState();
    }
  }

  Future fetchMorePollOptionVoters(pollId, optionId) async {
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(
        API.pollOptionVoters(pollId: pollId, optionId: optionId, lastId: pollOptionVotersModel.last.id),
      ));

      if (responseBody != null) {
        var pollOptionVotersModelInstance = (responseBody as List<dynamic>).map((x) => PollOptionVotersModel.fromJson(x)).toList();
        if (pollOptionVotersModelInstance.isNotEmpty &&
            (pollOptionVotersModelInstance.first.id == pollOptionVotersModel.first.id ||
                pollOptionVotersModelInstance.first.id == pollOptionVotersModel.last.id)) return;

        pollOptionVotersModel.addAll(pollOptionVotersModelInstance);

        state = PollOptionVotersSuccessState(pollOptionVotersModel);
        ref!.read(pollOptionVotersScrollProvider.notifier).resetState();
      } else {
        state = const PollOptionVotersErrorState();
      }
    } catch (error, stackTrace) {
      print('fetchPollOptionVoters() error = $error');
      print(stackTrace);
      state = const PollOptionVotersErrorState();
    }
  }
}
