import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signup/domain/entities/signup_entity.dart';

abstract class SignUpRepository {
  Future<AuthEntity> signUp({SignUpEntity entity});
}
