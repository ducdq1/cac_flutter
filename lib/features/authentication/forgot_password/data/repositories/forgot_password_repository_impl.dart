import 'package:citizen_app/features/authentication/forgot_password/data/datasource/forgot_password_remote_data_source.dart';
import 'package:citizen_app/features/authentication/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:citizen_app/injection_container.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  ForgotPasswordRemoteDataSource dataSource;

  ForgotPasswordRepositoryImpl() {
    dataSource = ForgotPasswordRemoteDataSourceImpl(client: singleton());
  }

  @override
  Future getSecretCode(
      {String phone, String captchaId, String captch}) async {
    return await dataSource.fetchSecretCode(
        phone: phone, captch: captch, captchaId: captchaId);
  }

  @override
  Future resetPassword(
      {String phone, String secretCode, String newPassword}) async {
    return await dataSource.resetPassword(
        phone: phone, secretCode: secretCode, newPassword: newPassword);
  }
}
