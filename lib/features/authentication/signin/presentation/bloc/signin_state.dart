import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';

abstract class SignInState {}

class SignInInitState extends SignInState {}

class SignInSsoState extends SignInState {}

class SignInOtpConfirmState extends SignInState {}

class SignInAccountConfirmState extends SignInState {}

class SignInOtpState extends SignInState {
  final String phone;
  SignInOtpState({this.phone});
}

class SignInAccountState extends SignInState {
  final String phone;
  final String password;

  SignInAccountState({this.phone, this.password});
}

class SignInAccountSucceedState extends SignInState {
  // final String phone;
  // final String password;

  // SignInAccountSucceedState({this.phone, this.password});
}

class SignInSucceedState extends SignInState {
  AuthEntity auth;
  SignInSucceedState({this.auth});
}

class SignInFaildState extends SignInState {
  String message;
  SignInFaildState({this.message});
}
