import 'package:buddyscripts/controller/feelings_activities/state/sub_activities_state.dart';
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subActivitiesProvider = StateNotifierProvider<SubActivitiesController, SubActivitiesState>(
  (ref) => SubActivitiesController(ref: ref),
);

class SubActivitiesController extends StateNotifier<SubActivitiesState> {
  final Ref? ref;
  SubActivitiesController({this.ref}) : super(const SubActivitiesInitialState());

  List<FeelingsModel>? subActivitiesModel = [];
  List<FeelingsModel>? storeSubActivitiesModel = [];
   FeelingsModel? selectedfeelingData;

  refresh(List<FeelingsModel>? activitiesModelInstance) {
    state = SubActivitiesSuccessState(activitiesModelInstance!);
  }

  Future fetchSubActivities({required id}) async {
    state = const SubActivitiesLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.getSubActivities(id:id)));
      print(responseBody);
      if (responseBody != null) {
        subActivitiesModel = (responseBody as List<dynamic>).map((e) => FeelingsModel.fromJson(e)).toList();
        storeSubActivitiesModel = subActivitiesModel;

        state = SubActivitiesSuccessState(subActivitiesModel!);
      } else {
        state = const SubActivitiesErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const SubActivitiesErrorState();
    }
  }
  
  Future searchSubActivities({str, id}) async {
    state = const SubActivitiesLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(await Network.getRequest(API.feelingSubActivitysearch(
        id: id, str: str
        )));
      print(responseBody);
      if (responseBody != null) {
        subActivitiesModel = (responseBody as List<dynamic>).map((e) => FeelingsModel.fromJson(e)).toList();

        state = SubActivitiesSuccessState(subActivitiesModel!);
      } else {
        state = const SubActivitiesErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const SubActivitiesErrorState();
    }
  }
}
