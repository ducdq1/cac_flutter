import 'package:citizen_app/features/authentication/signin/domain/usecases/signin_usecase.dart';
import 'package:get_it/get_it.dart';

import 'presentation/bloc/signin_bloc.dart';

Future<void> dependencyInjectionsHome(GetIt singleton) async {
  singleton.registerFactory(
    () => SignInBloc(signInUseCase: SignInUseCase()),
  );
}
