import 'package:buddyscripts/controller/pagination/scroll_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final discoverPagesScrollProvider = StateNotifierProvider<DiscoverPagesScrollProvider, ScrollState>((ref) => DiscoverPagesScrollProvider(ref: ref));

class DiscoverPagesScrollProvider extends StateNotifier<ScrollState> {
  final Ref? ref;

  DiscoverPagesScrollProvider({this.ref}) : super(const ScrollInitialState());

  ScrollController _scrollController = ScrollController();

  get controller {
    _scrollController.addListener(scrollListener);
    return _scrollController;
  }

  set setController(ScrollController scrollController) {
    _scrollController = scrollController;
  }

  get scrollNotifierState => state;

  scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      state = const ScrollReachedBottomState();
    }
  }

  resetState() {
    state = const ScrollInitialState();
  }
}
