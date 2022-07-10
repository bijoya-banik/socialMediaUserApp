abstract class ReportFeedState {
  const ReportFeedState();
}

class ReportFeedInitialState extends ReportFeedState {
  const ReportFeedInitialState();
}

class ReportFeedLoadingState extends ReportFeedState {
  const ReportFeedLoadingState();
}

class ReportFeedSuccessState extends ReportFeedState {
  const ReportFeedSuccessState();
}

class ReportFeedErrorState extends ReportFeedState {
  const ReportFeedErrorState();
}
