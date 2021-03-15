import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';

abstract class AuthEvent {}

class AuthenticatedEvent extends AuthEvent {
  final AuthEntity auth;

  AuthenticatedEvent({this.auth});
}
class UnAuthenticatedEvent extends AuthEvent {}
class UnknownAuthenticateEvent extends AuthEvent {}
