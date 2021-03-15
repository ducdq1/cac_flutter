import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';

abstract class ISignInRepository {
  Future<AuthEntity> signin([String param]);
}

abstract class SignInRepository {
  Future<AuthEntity> signin({ISignInRepository signinMechanism});
}
