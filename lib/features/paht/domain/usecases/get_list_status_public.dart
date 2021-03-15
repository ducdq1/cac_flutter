import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';

class GetListStatusPublic implements UseCase<StatusEntity, NoParams> {
  final PahtRepository repository;

  GetListStatusPublic(this.repository);

  @override
  Future<List<StatusEntity>> call(NoParams params) async {
    return await repository.getListStatusPublic();
  }
}
