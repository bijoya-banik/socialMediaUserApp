
import 'package:buddyscripts/controller/feelings_activities/state/activities_state.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activitiesProvider = StateNotifierProvider<ActivitiesController, ActivitiesState>(
  (ref) => ActivitiesController(ref: ref),
);

class ActivitiesController extends StateNotifier<ActivitiesState> {
  final Ref? ref;
  ActivitiesController({this.ref}) : super(const ActivitiesInitialState());

  List<FeelingsModel>? activitiesModel = [];
  List<FeelingsModel>? subActivitiesModel = [];
  List<FeelingsModel>? storeActivitiesModel = [];
   FeelingsModel? selectedfeelingData;

  refresh(List<FeelingsModel>? activitiesModelInstance) {
    state = ActivitiesSuccessState(activitiesModelInstance!);
  }

  Future fetchActivities() async {
    state = const ActivitiesLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.getActivities));
      print(responseBody);
      if (responseBody != null) {
        activitiesModel = (responseBody as List<dynamic>).map((e) => FeelingsModel.fromJson(e)).toList();
        storeActivitiesModel = activitiesModel;

        state = ActivitiesSuccessState(activitiesModel!);
      } else {
        state = const ActivitiesErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ActivitiesErrorState();
    }
  }
  
  Future searchActivities(str) async {
    state = const ActivitiesLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.feelingActivitysearch(type: "ACTIVITY", str: str)));
      print(responseBody);
      if (responseBody != null) {
        activitiesModel = (responseBody as List<dynamic>).map((e) => FeelingsModel.fromJson(e)).toList();

        state = ActivitiesSuccessState(activitiesModel!);
      } else {
        state = const ActivitiesErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const ActivitiesErrorState();
    }
  }
}
