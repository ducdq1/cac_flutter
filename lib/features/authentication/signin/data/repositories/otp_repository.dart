import 'package:citizen_app/features/authentication/signin/data/datasources/otp_data_source.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signin/domain/repositories/opt_repository.dart';
import 'package:citizen_app/injection_container.dart';

class OtpRepositoryImpl implements OtpRepository {
  OtpDataSource remoteDataSource;
  OtpRepositoryImpl({this.phone, this.otpCode}) {
    remoteDataSource =
        OtpDataSourceImpl(client: singleton(), networkRequest: singleton());
  }
  String otpCode;

  @override
  String phone;

  @override
  Future<String> getOtpCode() async {
    return await remoteDataSource.otp(phone: phone);
  }

  @override
  Future<AuthEntity> signin([String param]) async {
    return await remoteDataSource.auth(otpCode: otpCode, phone: phone);
  }
}
