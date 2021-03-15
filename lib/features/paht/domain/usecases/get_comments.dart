import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/data/models/comment_model.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetComments implements UseCase<PahtEntity, CommentParams> {
  final PahtRepository repository;

  GetComments(this.repository);

  @override
  Future<List<CommentModel>> call(CommentParams params) async {
    return await repository.getCommentsDetailedPaht(pahtId: params.pahtId);
  }
}

class CommentParams extends Equatable {
  final String pahtId;

  CommentParams({
    @required this.pahtId,
  });

  @override
  List<Object> get props => [pahtId];
}
