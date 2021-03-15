abstract class ActiveAccountState {}

class ActiveAccountSucceedState extends ActiveAccountState {}
class ActiveAccountLoadingState extends ActiveAccountState {}
class ActiveAccountOtpState extends ActiveAccountState {
  final String phone;
  ActiveAccountOtpState({this.phone});
}

class ActiveAccountFaildState extends ActiveAccountState {
  final String message;
  ActiveAccountFaildState({this.message});
}
