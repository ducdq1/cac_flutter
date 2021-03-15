import 'package:citizen_app/features/authentication/signin/data/datasources/sso_data_source.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signin/domain/repositories/sso_repository.dart';
import 'package:citizen_app/injection_container.dart';

class SsoRepositoryImpl implements SsoRepository {
  @override
  String pass;

  @override
  String phone;
  SsoDataSource remoteDataSource;

  SsoRepositoryImpl({this.pass, this.phone}) {
    remoteDataSource =
        SsoDataSourceImpl(client: singleton(), networkRequest: singleton());
  }

  @override
  Future<AuthEntity> signin([String param]) async {
    return await remoteDataSource.auth(password: pass, phone: phone);
  }
}
