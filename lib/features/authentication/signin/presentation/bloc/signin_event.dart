import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';

abstract class SignInEvent {}

class SignInSsoEvent extends SignInEvent {
  String phone;
  String password;

  SignInSsoEvent({this.phone, this.password});
}

class SignInAccountEvent extends SignInEvent {
  String phone;
  String password;

  SignInAccountEvent({this.phone, this.password});
}

class SignInOtpEvent extends SignInEvent {
  String phone;

  SignInOtpEvent({this.phone});
}

class SignInOtpConfirmEvent extends SignInEvent {
  String otpCode;
  String phone;

  SignInOtpConfirmEvent({this.otpCode, this.phone});
}

class SignInAccountConfirmEvent extends SignInEvent {
  String otpCode;
  String phone;
  String password;

  SignInAccountConfirmEvent({this.otpCode, this.phone, this.password});
}

class SignInSucceedEvent extends SignInEvent {
  final AuthEntity auth;
  SignInSucceedEvent({this.auth});
}

class SignInFaildEvent extends SignInEvent {}
class SignInClearEvent extends SignInEvent {}
class SignInResendOtpEvent extends SignInEvent {}
