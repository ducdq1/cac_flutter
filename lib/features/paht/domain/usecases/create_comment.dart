import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CreateComment implements UseCase<String, Params> {
  final PahtRepository repository;

  CreateComment(this.repository);

  @override
  Future<bool> call(Params commentParams) async {
    return await repository.createComment(commentParams);
  }
}

class Params extends Equatable {
  final String content;
  final String issueId;
  final int commentId;

  Params({this.content, @required this.issueId, this.commentId});

  @override
  List<Object> get props => [issueId, content, commentId];
}
