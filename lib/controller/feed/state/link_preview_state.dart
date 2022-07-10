

import 'package:buddyscripts/models/feed/feed_model.dart';

abstract class LinkPreviewState {
  const LinkPreviewState();
}

class LinkPreviewInitialState extends LinkPreviewState {
  const LinkPreviewInitialState();
}

class LinkPreviewLoadingState extends LinkPreviewState {
  const LinkPreviewLoadingState();
}

class LinkPreviewSuccessState extends LinkPreviewState {
  final LinkMeta linkPreviewModel;
  const LinkPreviewSuccessState(this.linkPreviewModel);
}

class LinkPreviewErrorState extends LinkPreviewState {
  const LinkPreviewErrorState();
}
