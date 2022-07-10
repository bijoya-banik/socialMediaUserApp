import 'package:buddyscripts/models/feed/poll_option_voters_model.dart';

abstract class PollOptionVotersState {
  const PollOptionVotersState();
}

class PollOptionVotersInitialState extends PollOptionVotersState {
  const PollOptionVotersInitialState();
}

class PollOptionVotersLoadingState extends PollOptionVotersState {
  const PollOptionVotersLoadingState();
}

class PollOptionVotersSuccessState extends PollOptionVotersState {
  final List<PollOptionVotersModel> pollOptionVoters;
  const PollOptionVotersSuccessState(this.pollOptionVoters);
}

class PollOptionVotersErrorState extends PollOptionVotersState {
  const PollOptionVotersErrorState();
}
