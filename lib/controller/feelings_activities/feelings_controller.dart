import 'package:buddyscripts/controller/feelings_activities/state/feelings_state.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feelingsProvider = StateNotifierProvider<FeelingsController, FeelingsState>(
  (ref) => FeelingsController(ref: ref),
);

class FeelingsController extends StateNotifier<FeelingsState> {
  final Ref? ref;
  FeelingsController({this.ref}) : super(const FeelingsInitialState());

  List<FeelingsModel>? feelingsModel = [];
  List<FeelingsModel>? storeFeelingsModel = [];
   FeelingsModel? selectedfeelingData;

  refresh(List<FeelingsModel>? feelingsModelInstance) {
    state = FeelingsSuccessState(feelingsModelInstance!);
  }

  Future fetchFeelings() async {
    state = const FeelingsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.getFeelings));
      print(responseBody);
      if (responseBody != null) {
        feelingsModel = (responseBody as List<dynamic>).map((e) => FeelingsModel.fromJson(e)).toList();
        storeFeelingsModel = feelingsModel;

        state = FeelingsSuccessState(feelingsModel!);
      } else {
        state = const FeelingsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FeelingsErrorState();
    }
  }

  Future searchFeelings(str) async {
    state = const FeelingsLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.feelingActivitysearch(type: "FEELINGS", str: str)));
      print(responseBody);
      if (responseBody != null) {
        feelingsModel = (responseBody as List<dynamic>).map((e) => FeelingsModel.fromJson(e)).toList();

        state = FeelingsSuccessState(feelingsModel!);
      } else {
        state = const FeelingsErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const FeelingsErrorState();
    }
  }
}
