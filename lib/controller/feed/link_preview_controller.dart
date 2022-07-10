import 'package:buddyscripts/controller/feed/state/link_preview_state.dart';
import 'package:buddyscripts/models/feed/feed_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final linkPreviewProvider = StateNotifierProvider<LinkPreviewController,LinkPreviewState>(
  (ref) => LinkPreviewController(ref: ref),
);

class LinkPreviewController extends StateNotifier<LinkPreviewState> {
  final Ref? ref;
  LinkPreviewController({this.ref}) : super(const LinkPreviewInitialState());

  LinkMeta? linkPreviewModelModel;

  updateState() {
    state = const LinkPreviewErrorState();
  }

  Future getLinkPreview(url) async {
    if (linkPreviewModelModel == null) state = const LinkPreviewLoadingState();
    dynamic responseBody;
    var requestBody = {'url': url};

    try {
      responseBody = await Network.handleResponse(await Network.postRequest(API.getLinkPreview, requestBody));

      if (responseBody['metaData'] != null) {
        linkPreviewModelModel = LinkMeta.fromJson(responseBody['metaData']);

        if (linkPreviewModelModel?.title == "" &&
            linkPreviewModelModel?.description == "" &&
            linkPreviewModelModel?.url == "" &&
            linkPreviewModelModel?.image.length == 0) {
          state = const LinkPreviewErrorState();
        } else {
          state = LinkPreviewSuccessState(linkPreviewModelModel!);
        }
      } else {
        state = const LinkPreviewErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const LinkPreviewErrorState();
    }
  }
}
