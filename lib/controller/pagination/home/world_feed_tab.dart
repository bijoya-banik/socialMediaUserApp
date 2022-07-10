import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final worldFeedScrollProvider = StateNotifierProvider<WorldFeedScrollProvider, ScrollState>((ref) => WorldFeedScrollProvider(ref: ref));

class WorldFeedScrollProvider extends StateNotifier<ScrollState> {
  final Ref? ref;

  WorldFeedScrollProvider({this.ref}) : super(const ScrollInitialState());

  ScrollController _scrollController = ScrollController();

  get controller {
    _scrollController.addListener(scrollListener);
    return _scrollController;
  }

  set setController(ScrollController _scrollController) {
    this._scrollController = _scrollController;
  }

  get scrollNotifierState => state;

  scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent || !_scrollController.position.outOfRange) {
      state = const ScrollReachedBottomState();
    }
  }

  resetState() {
    state = const ScrollInitialState();
  }
}
