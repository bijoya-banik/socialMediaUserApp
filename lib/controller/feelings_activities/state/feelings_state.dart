
import 'package:buddyscripts/models/feelings_activities/feelings_model.dart';

abstract class FeelingsState {
    const FeelingsState();
}
class FeelingsInitialState extends FeelingsState {
    const FeelingsInitialState();
}
class FeelingsLoadingState extends FeelingsState {
    const FeelingsLoadingState();
}
class FeelingsSuccessState extends FeelingsState {
   final List<FeelingsModel> feelingsModel;
    const FeelingsSuccessState(this.feelingsModel);
}
class FeelingsErrorState extends FeelingsState {
    const FeelingsErrorState();
}