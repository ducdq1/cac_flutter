import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/paht/domain/entities/entities.dart';
import 'package:citizen_app/features/paht/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetListPersonalPaht implements UseCase<PahtEntity, PahtParams> {
  final PahtRepository repository;

   GetListPersonalPaht(this.repository);

  @override
  Future<List<PahtEntity>> call(PahtParams params) async {
    return await repository.getListPersonalPaht(params);
  }
}

class PahtParams extends Equatable {
  final String search;
  final String userName;
  final int limit;
  final int offset;
  final int status;
  final bool isApproveAble;
  final bool isSaled;

  PahtParams({this.search,this.userName, this.limit, this.offset, this.status,this.isApproveAble = false,this.isSaled = false});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  Map<String, dynamic> toJson() {
    return {
      'search': search,
      'userName': userName,
      'limit': limit,
      'offset': offset,
      'status': status,
      'isApproveAble' : isApproveAble,
      'isSaled' : isSaled
    };
  }
}
