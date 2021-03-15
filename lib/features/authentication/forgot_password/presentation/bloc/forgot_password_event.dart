
abstract class ForgotPasswordEvent {}

class FetchSecretCodeEvent extends ForgotPasswordEvent {
  final String phone;
  final String captcha;
  final String captchaId;

  FetchSecretCodeEvent({this.captcha, this.captchaId, this.phone});
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String phone;
  final String secretCode;
  final String newPassword;

  ResetPasswordEvent({this.secretCode, this.newPassword, this.phone});
}
