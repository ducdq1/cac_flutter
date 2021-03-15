import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';

abstract class AuthState {}

class AuthenticatedState extends AuthState {
  final AuthEntity auth;
  AuthenticatedState({this.auth});
}

class UnAuthenticateState extends AuthState {}
