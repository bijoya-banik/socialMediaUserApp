import 'package:buddyscripts/models/auth/user_model.dart';

/// User
abstract class UserState {
  const UserState();
}

class UserInitialState extends UserState {
  const UserInitialState();
}

class UserLoadingState extends UserState {
  const UserLoadingState();
}

class RegisterSuccessState extends UserState {
  const RegisterSuccessState();
}

class UserSuccessState extends UserState {
  final UserModel userModel;
  const UserSuccessState(this.userModel);
}

class LoginSuccessState extends UserState {
  const LoginSuccessState();
}
class UserUnverifiedState extends UserState {
  const UserUnverifiedState();
}

class LogoutSuccessState extends UserState {
  const LogoutSuccessState();
}

class VerificationSuccessState extends UserState {
  const VerificationSuccessState();
}

class VerificationMailSentSuccessState extends UserState {
  const VerificationMailSentSuccessState();
}

class ErrorState extends UserState {
  const ErrorState();
}
