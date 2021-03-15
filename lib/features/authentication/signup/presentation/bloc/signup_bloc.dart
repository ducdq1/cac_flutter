import 'package:citizen_app/features/authentication/signup/data/models/signup_model.dart';
import 'package:citizen_app/features/authentication/signup/data/repositories/signup_repository_impl.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_event.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_state.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitState(entity: SignUpModel()));

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpUpdateFieldsEvent) {
      final newEntity = state.entity.copyWith(event.entity);
      print(newEntity);
      yield SignUpUpdatedFieldsState(entity: newEntity);
    } else if (event is RegisterAccountEvent) {
      if (event.entity == null) {
        yield RegisteringAccountState(entity: state.entity);
        try {
          final signUpRepo = SignUpRepositoryImpl();
          print(state.entity);
          final auth = await signUpRepo.signUp(entity: state.entity);
          final prefs = singleton<SharedPreferences>();
          print('token: ${auth.access_token}');
          await prefs.setString('token', auth.access_token);
          yield RegisterAccountSucceedState(auth: auth);
        } catch (e) {
          print(e);
          yield RegisterAccountFaildState(
            message: e.message,
            entity: state.entity,
          );
        }
      }
    } else if(event is SignUpClearEvent) {
      yield SignUpInitState(entity: SignUpModel());
    }
  }
}
