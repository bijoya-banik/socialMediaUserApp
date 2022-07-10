import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';

abstract class SubActivitiesState {
    const SubActivitiesState();
}
class SubActivitiesInitialState extends SubActivitiesState {
    const SubActivitiesInitialState();
}
class SubActivitiesLoadingState extends SubActivitiesState {
    const SubActivitiesLoadingState();
}
class SubActivitiesSuccessState extends SubActivitiesState {
   final List<FeelingsModel> subActivitiesModel;
    const SubActivitiesSuccessState(this.subActivitiesModel);
}
class SubActivitiesErrorState extends SubActivitiesState {
    const SubActivitiesErrorState();
}