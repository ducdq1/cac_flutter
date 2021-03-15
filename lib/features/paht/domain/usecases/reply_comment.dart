import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'create_comment.dart';

class ReplyComment implements UseCase<String, Params> {
  final PahtRepository repository;

  ReplyComment(this.repository);

  @override
  Future<bool> call(Params commentParams) async {
    return await repository.replyComment(commentParams);
  }
}
