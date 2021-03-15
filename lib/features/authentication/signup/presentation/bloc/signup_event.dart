import 'package:citizen_app/features/authentication/signup/domain/entities/signup_entity.dart';

abstract class SignUpEvent {}

class SignUpUpdateFieldsEvent extends SignUpEvent {
  final SignUpEntity entity;

  SignUpUpdateFieldsEvent({this.entity});
}

class RegisterAccountEvent extends SignUpEvent {
  final SignUpEntity entity;

  RegisterAccountEvent({this.entity});
}

class SignUpClearEvent extends SignUpEvent {}
