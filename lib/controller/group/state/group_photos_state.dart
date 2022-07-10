import 'package:buddyscripts/models/group/group_photos_model.dart';

abstract class GroupPhotosState {
  const GroupPhotosState();
}

class GroupPhotosInitialState extends GroupPhotosState {
  const GroupPhotosInitialState();
}

class GroupPhotosLoadingState extends GroupPhotosState {
  const GroupPhotosLoadingState();
}

class GroupPhotosSuccessState extends GroupPhotosState {
  final GroupPhotosModel groupPhotosModel;
  const GroupPhotosSuccessState(this.groupPhotosModel);
}

class GroupPhotosErrorState extends GroupPhotosState {
  const GroupPhotosErrorState();
}
