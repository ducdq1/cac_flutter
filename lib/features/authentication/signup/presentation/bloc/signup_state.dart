import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signup/domain/entities/signup_entity.dart';

abstract class SignUpState {
  final SignUpEntity entity;

  SignUpState({this.entity});
}

class SignUpInitState extends SignUpState {
  final SignUpEntity entity;

  SignUpInitState({this.entity});
}

class SignUpUpdatedFieldsState extends SignUpState {
  final SignUpEntity entity;

  SignUpUpdatedFieldsState({this.entity});
}

class RegisteringAccountState extends SignUpState {
  final SignUpEntity entity;

  RegisteringAccountState({this.entity});
}

class RegisterAccountSucceedState extends SignUpState {
  final AuthEntity auth;

  RegisterAccountSucceedState({this.auth});
}

class RegisterAccountFaildState extends SignUpState {
  final String message;
  final SignUpEntity entity;

  RegisterAccountFaildState({this.message, this.entity});
}
