abstract class ChangePasswordState {}

class ChangePasswordProcessingState extends ChangePasswordState {}
class ChangePasswordSucceedState extends ChangePasswordState {}
class ChangePasswordFaildState extends ChangePasswordState {
  final String message;
  ChangePasswordFaildState({this.message});
}
