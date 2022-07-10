abstract class FeedState {
  const FeedState();
}

class FeedInitialState extends FeedState {
  const FeedInitialState();
}

class FeedLoadingState extends FeedState {
  const FeedLoadingState();
}

class FeedSuccessState extends FeedState {
  const FeedSuccessState();
}

class FeedErrorState extends FeedState {
  const FeedErrorState();
}
