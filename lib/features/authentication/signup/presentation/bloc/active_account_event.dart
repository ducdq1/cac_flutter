abstract class ActiveAccountEvent {}

class OtpRequestCodeEvent extends ActiveAccountEvent {
  final String phone;
  OtpRequestCodeEvent({this.phone});
}

class ResendOtpCodeEvent extends ActiveAccountEvent {}

class ActiveAccountByOtpEvent extends ActiveAccountEvent {
  final String otp;
  final String phone;
  ActiveAccountByOtpEvent({this.otp, this.phone});
}
