import 'package:citizen_app/features/authentication/signin/domain/repositories/signin_repository.dart';

abstract class OtpRepository implements ISignInRepository {
  String phone;
  Future<String> getOtpCode();
}