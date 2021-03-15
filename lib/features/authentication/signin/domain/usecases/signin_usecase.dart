import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/authentication/signin/domain/entities/auth_entity.dart';
import 'package:citizen_app/features/authentication/signin/domain/repositories/signin_repository.dart';

class SignInUseCase
    implements UseCase<AuthEntity, ISignInRepository> {

  @override
  Future<AuthEntity> call(ISignInRepository repository) async {
    return await repository.signin();
  }
}