

import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';

abstract class ActivitiesState {
    const ActivitiesState();
}
class ActivitiesInitialState extends ActivitiesState {
    const ActivitiesInitialState();
}
class ActivitiesLoadingState extends ActivitiesState {
    const ActivitiesLoadingState();
}
class ActivitiesSuccessState extends ActivitiesState {
   final List<FeelingsModel> activitiesModel;
    const ActivitiesSuccessState(this.activitiesModel);
}
class ActivitiesErrorState extends ActivitiesState {
    const ActivitiesErrorState();
}