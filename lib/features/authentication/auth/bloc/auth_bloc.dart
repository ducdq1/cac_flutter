import 'dart:convert';

import 'package:citizen_app/features/authentication/auth/bloc/auth_event.dart';
import 'package:citizen_app/features/authentication/signin/data/models/auth_model.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(UnAuthenticateState());
  @override
  Stream<AuthState> mapEventToState(event) async* {
    if (event is UnknownAuthenticateEvent) {
      final SharedPreferences prefs = singleton<SharedPreferences>();
      final authStr = prefs.get('auth');
      if (authStr != null) {
        final auth = AuthModel.fromJson(jsonDecode(authStr));
        add(AuthenticatedEvent(auth: auth));
      }
    }
    if (event is AuthenticatedEvent) {
      final SharedPreferences prefs = singleton<SharedPreferences>();
      await prefs.setString('auth', event.auth.toString());
      yield AuthenticatedState(auth: event.auth);
    }
    if (event is UnAuthenticatedEvent) {
      final SharedPreferences prefs = singleton<SharedPreferences>();
      try {
        await prefs.remove('userName');
        await prefs.remove('auth');
        await prefs.remove('token');
        await prefs.remove('userType');
        await prefs.remove('userRole');
        await prefs.remove('myFirebaseUserId');
        await prefs.remove('myFirebaseUserFullName');
        await prefs.remove('myFirebaseUserAvatar');
      } catch (e) {
        print(e);
      }
      yield UnAuthenticateState();
    }
  }
}
