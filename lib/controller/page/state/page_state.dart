abstract class PageState {
  const PageState();
}

class PageInitialState extends PageState {
  const PageInitialState();
}

class PageLoadingState extends PageState {
  const PageLoadingState();
}

class PageErrorState extends PageState {
  const PageErrorState();
}

/// Create page

class CreatePageSuccessState extends PageState {
  const CreatePageSuccessState();
}

class CreatePageErrorState extends PageState {
  const CreatePageErrorState();
}

/// Edit page

class EditPageSuccessState extends PageState {
  const EditPageSuccessState();
}

class EditPageErrorState extends PageState {
  const EditPageErrorState();
}

/// Delete page

class DeletePageSuccessState extends PageState {
  const DeletePageSuccessState();
}

class DeletePageErrorState extends PageState {
  const DeletePageErrorState();
}

/// unfollow page

class UnfollowPageSuccessState extends PageState {
  const UnfollowPageSuccessState();
}

class UnfollowPageErrorState extends PageState {
  const UnfollowPageErrorState();
}

/// follow page

class FollowPageSuccessState extends PageState {
  const FollowPageSuccessState();
}

class FollowPageErrorState extends PageState {
  const FollowPageErrorState();
}
