abstract class ForgotPasswordRepository {
  Future getSecretCode({String phone, String captchaId, String captch});
  Future resetPassword(
      {String phone, String secretCode, String newPassword});
}
