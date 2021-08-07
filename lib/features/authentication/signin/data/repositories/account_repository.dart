import 'package:citizen_app/features/authentication/signin/data/datasources/account_data_source.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/user_entity.dart';
import 'package:citizen_app/features/authentication/signin/domain/repositories/account_repository.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:http/http.dart' as http;

class AccountRepositoryImpl implements AccountRepository {
  static http.Client client;
  @override
  String phone;
  AccountDataSource remoteDataSource;

  AccountRepositoryImpl({this.phone, this.otpCode, this.password}) {
    if (client == null) {
      client = http.Client();

    }
    remoteDataSource =
        AccountDataSourceImpl(client: client, networkRequest: singleton());
  }

  void close() {
    client?.close();
  }

  @override
  Future<String> getOtpCode({String password, String phone}) async {
    return await remoteDataSource.otp(phone: phone, password: password);
  }

  @override
  Future<AuthEntity> signin([String param]) async {
    return await remoteDataSource.auth(
        otpCode: otpCode, phone: phone, password: password);
  }

  @override
  String otpCode;

  @override
  String password;

  @override
  Future<AuthEntity> signInWithAccount({String password, String phone,bool isCustomer,String inviter,int cusGroup}) async {
    return await remoteDataSource.authNonOtp(phone: phone, password: password, isCustomer: isCustomer,inviter: inviter,cusGroup: cusGroup);
  }

  @override
  Future<UserEntity> getUserInfo() async{
    return await remoteDataSource.getUserInfo();
  }
}
