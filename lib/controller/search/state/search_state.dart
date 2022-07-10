abstract class SearchState {
  const SearchState();
}

class SearchInitialState extends SearchState {
  const SearchInitialState();
}

class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

class SearchSuccessState extends SearchState {
  final dynamic response;
  const SearchSuccessState(this.response);
}

class SearchErrorState extends SearchState {
  const SearchErrorState();
}
