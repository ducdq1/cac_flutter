import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:citizen_app/features/paht/domain/usecases/get_list_personal_paht.dart';

class GetListPublicPaht implements UseCase<PahtEntity, PahtParams> {
  final PahtRepository repository;

  GetListPublicPaht(this.repository);

  @override
  Future<List<PahtEntity>> call(PahtParams params) async {
    return await repository.getListPublicPaht(params);
  }
}
