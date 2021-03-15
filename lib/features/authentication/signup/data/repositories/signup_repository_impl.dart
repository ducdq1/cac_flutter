import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signup/data/data_sources/signup_data_source.dart';
import 'package:citizen_app/features/authentication/signup/domain/entities/signup_entity.dart';
import 'package:citizen_app/features/authentication/signup/domain/repositories/signup_repository.dart';
import 'package:citizen_app/injection_container.dart';

class SignUpRepositoryImpl extends SignUpRepository{
  SignUpDataSource dataSource;

  SignUpRepositoryImpl() {
    dataSource = SignUpDataSourceImpl(client: singleton(), networkRequest: singleton());
  }

  @override
  Future<AuthEntity> signUp({SignUpEntity entity}) async {
    return await dataSource.signUp(entity: entity);
  }
}