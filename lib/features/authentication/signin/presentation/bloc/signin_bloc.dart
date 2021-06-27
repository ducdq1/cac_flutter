import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/authentication/signin/data/repositories/account_repository.dart';
import 'package:citizen_app/features/authentication/signin/data/repositories/otp_repository.dart';
import 'package:citizen_app/features/authentication/signin/domain/usecases/signin_usecase.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_event.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_state.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInUseCase signInUseCase;
  AccountRepositoryImpl accountRepository;

  SignInBloc({this.signInUseCase}) : super(SignInInitState());

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    print(' vao bloc');
    try {
      /// Resend otp-code
      /// [SignInOtpEvent] or [SignInAccountEvent]
      /// Check if previous state is in [SignInAccountState] or [SignInOtpState]
      /// and event is [SignInResendOtpEvent] will be reset opt
      if (state is SignInAccountState && event is SignInResendOtpEvent) {
        add(
          SignInAccountEvent(
            phone: (state as SignInAccountState).phone,
            password: (state as SignInAccountState).password,
          ),
        );
      } else if (state is SignInOtpState && event is SignInResendOtpEvent) {
        add(SignInOtpEvent(phone: (state as SignInOtpState).phone));
      }

      /// [SignInOtpEvent] using to get otp code
      /// Send [phone] number to server
      /// Server responses status and send a message to [phone]
      if (event is SignInOtpEvent) {
        yield SignInOtpState(phone: event.phone);
        final otpRepo = OtpRepositoryImpl(phone: event.phone);
        await otpRepo.getOtpCode();
      }

      /// [SignInOtpConfirmEvent] using for auth by otp
      /// Using to verify otp and return [Auth]
      /// This event should be pass [phone] and [optcode]
      /// If verify's succeed, bloc should yield [SignInSucceedState]
      /// attch [AuthModel] inside
      else if (event is SignInOtpConfirmEvent) {
        yield SignInOtpConfirmState();
        final auth = await signInUseCase(
            OtpRepositoryImpl(otpCode: event.otpCode, phone: event.phone));
        final prefs = singleton<SharedPreferences>();
        await prefs.setString('token', auth.access_token);

        await prefs.setInt('isViettelAuth', 1);
        yield SignInSucceedState(auth: auth);
      }
      // else if (event is SignInSsoEvent) {
      //   yield SignInSsoState();
      //   final auth = await signInUseCase(
      //       SsoRepositoryImpl(pass: event.password, phone: event.phone));
      //   final prefs = singleton<SharedPreferences>();
      //   await prefs.setString('token', auth.token);
      //   yield SignInSucceedState(auth: auth);
      // }
      /// [SignInAccountEvent] using for get otp code over [password], [phone]
      /// Before excute get request [opt]
      /// Bloc should yield a [SignInAccountState] to save [phone],[password]
      /// It's using for resend opt event
      else if (event is SignInAccountEvent) {
        yield SignInAccountState(phone: event.phone, password: event.password);
        if (accountRepository == null) {
          accountRepository = AccountRepositoryImpl(phone: event.phone);
        }

        final auth = await accountRepository.signInWithAccount(
            phone: event.phone, password: event.password, isCustomer: event.isCustomer);

        if( auth ==null || auth.userName == null || auth.userName.isEmpty){
          yield SignInFaildState(message: 'Tên đăng nhập hoặc mật khẩu không đúng');
          return;
        }
        final prefs = singleton<SharedPreferences>();
        await prefs.setString('token', auth.userName);

       // final user = await accountRepository.getUserInfo();
        await prefs.setString('userName', auth.userName);
        await prefs.setString('fullName', auth.fullName);
        await prefs.setString('avartarPath', auth.avartarPath);
        await prefs.setString('userId', auth.userId == null ? null : auth.userId.toString());
        await prefs.setInt('userType', auth.userType);
        await prefs.setBool('isCustomer', event.isCustomer);
        await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);

        yield SignInSucceedState(auth: auth,isCustomer: event.isCustomer);
        // yield SignInAccountSucceedState();
      }

      /// [SignInAccountConfirmEvent] using for auth by opt
      else if (event is SignInAccountConfirmEvent) {
        yield SignInAccountConfirmState();
        final auth = await signInUseCase(AccountRepositoryImpl(
            otpCode: event.otpCode,
            phone: event.phone,
            password: event.password));
        final prefs = singleton<SharedPreferences>();
        await prefs.setString('token', auth.access_token);

        yield SignInSucceedState(auth: auth);
      } else if (event is SignInClearEvent) {
        /// [close()] shoule be called in order to release
        /// and remove task's processing before the time;
        //accountRepository?.close();

        //final prefs = singleton<SharedPreferences>();
        // try {
        //   await prefs.remove('token');
        //   // await prefs.remove('auth');
        // } catch (e) {
        //   print(e);
        // }
        yield SignInInitState();
      } else if (event is SignInSucceedEvent) {
        yield SignInSucceedState(auth: event.auth);
      }
    } catch (e) {
      print(e);
      yield SignInFaildState(
          message: e.message == "Connection failed"
              ? trans(ERROR_CONNECTION_FAILED)
              :  e.message);
    }
  }
}
