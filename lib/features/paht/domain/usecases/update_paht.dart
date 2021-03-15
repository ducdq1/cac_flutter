import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

class UpdatePaht implements UseCase<StatusEntity, UpdatedParams> {
  final PahtRepository repository;

  UpdatePaht(this.repository);

  @override
  Future<bool> call(UpdatedParams updatedParams) async {
    return await repository.updatePaht(updatedParams);
  }
}

class UpdatedParams extends Equatable {
  final String userId;
  final String id;
  final String address;
  final String location;
  final String description;
  final List<dynamic> files;

  UpdatedParams(
      {this.userId,
      this.address,
      this.location,
      this.description,
      this.files,
      this.id});

  @override
  List<Object> get props => [userId, address, location, description, files, id];
}
