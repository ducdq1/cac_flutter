import 'package:citizen_app/features/authentication/signup/data/repositories/active_account_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'active_account_event.dart';
import 'active_account_state.dart';

class ActiveAccountBloc extends Bloc<ActiveAccountEvent, ActiveAccountState> {
  ActiveAccountBloc() : super(null);

  @override
  Stream<ActiveAccountState> mapEventToState(ActiveAccountEvent event) async* {
    if (state is ActiveAccountOtpState && event is ResendOtpCodeEvent) {
      add(OtpRequestCodeEvent(phone: (state as ActiveAccountOtpState).phone));
    }

    if (event is OtpRequestCodeEvent) {
      yield ActiveAccountOtpState(phone: event.phone);
      final otpRepo = ActiveAccountRepositoryImpl();
      try {
        await otpRepo.otp(phone: event.phone);
      } catch (e) {
        print(e);
      }
    } else if (event is ActiveAccountByOtpEvent) {
      yield ActiveAccountLoadingState();
      final otpRepo = ActiveAccountRepositoryImpl();
      try {
        await otpRepo.active(
          username: event.phone,
          otp: event.otp,
        );
        yield ActiveAccountSucceedState();
      } catch (e) {
        yield ActiveAccountFaildState(message: e.message);
      }
    }
  }
}
