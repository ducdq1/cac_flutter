import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/user_entity.dart';
import 'signin_repository.dart';

abstract class AccountRepository implements ISignInRepository {
  String phone;
  String password;

  Future<String> getOtpCode({String password, String phone});
  Future<AuthEntity> signInWithAccount({String password, String phone,bool isCustomer});
  Future<UserEntity> getUserInfo();
}
