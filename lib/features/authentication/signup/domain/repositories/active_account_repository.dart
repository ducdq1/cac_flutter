
abstract class ActiveAccountRepository {
  Future<String> otp({String phone});
  Future active({String username, String otp});
}
