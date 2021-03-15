
import 'signin_repository.dart';

abstract class SsoRepository implements ISignInRepository {
  String phone;
  String pass;
}
