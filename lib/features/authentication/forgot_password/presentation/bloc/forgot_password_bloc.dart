import 'package:citizen_app/features/authentication/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_event.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(null);

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is FetchSecretCodeEvent) {
      yield FetchSecretCodeProcessingState();
      try {
        final repo = ForgotPasswordRepositoryImpl();
        await repo.getSecretCode(
          phone: event.phone,
          captchaId: event.captchaId,
          captch: event.captcha,
        );
        yield FetchSecretCodeSucceedState();
      } catch (e) {
        yield FetchSecretCodeFaildState(message: e.message);
      }
    } else if (event is ResetPasswordEvent) {
      yield ResetPasswordProcessingState();
      try {
        final repo = ForgotPasswordRepositoryImpl();
        await repo.resetPassword(
          phone: event.phone,
          secretCode: event.secretCode,
          newPassword: event.newPassword,
        );
        yield ResetPasswordSucceedState();
      } catch (e) {
        yield ResetPasswordFaildState(message: e.message);
      }
    }
  }
}
