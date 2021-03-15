import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';

class DeletePaht implements UseCase<StatusEntity, String> {
  final PahtRepository repository;

  DeletePaht(this.repository);

  @override
  Future<bool> call(String id) async {
    return await repository.deletePaht(id: id);
  }
}
