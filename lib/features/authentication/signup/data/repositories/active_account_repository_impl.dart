import 'package:citizen_app/features/authentication/signup/data/data_sources/signup_data_source.dart';
import 'package:citizen_app/features/authentication/signup/domain/repositories/active_account_repository.dart';
import 'package:citizen_app/injection_container.dart';

class ActiveAccountRepositoryImpl extends ActiveAccountRepository {
  SignUpDataSource dataSource;

  ActiveAccountRepositoryImpl() {
    dataSource =
        SignUpDataSourceImpl(client: singleton(), networkRequest: singleton());
  }

  @override
  Future<String> otp({String phone}) async {
    return await dataSource.otp(phone: phone);
  }

  @override
  Future active({String username, String otp}) async {
    return await dataSource.activeAccount(
        username: username, otp: otp);
  }
}
