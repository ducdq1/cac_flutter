abstract class ForgotPasswordState {}

class FetchSecretCodeProcessingState extends ForgotPasswordState {}

class FetchSecretCodeSucceedState extends ForgotPasswordState {}

class FetchSecretCodeFaildState extends ForgotPasswordState {
  final String message;
  FetchSecretCodeFaildState({this.message});
}

class ResetPasswordProcessingState extends ForgotPasswordState {}

class ResetPasswordSucceedState extends ForgotPasswordState {}

class ResetPasswordFaildState extends ForgotPasswordState {
  final String message;
  ResetPasswordFaildState({this.message});
}
