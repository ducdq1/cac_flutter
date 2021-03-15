import 'package:citizen_app/core/usecases/usecase.dart';
import 'package:citizen_app/features/home/data/models/app_module_model.dart';
import 'package:citizen_app/features/home/domain/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetListAppModulesUseCase
    implements UseCase<AppModuleModel, AppModuleParams> {
  final AppModuleRepository repository;

  GetListAppModulesUseCase(this.repository);

  @override
  Future<AppModuleModel> call(AppModuleParams appModuleParams) async {
    return await repository.getAppModules(
        provinceId: appModuleParams.provinceId, userId: appModuleParams.userId);
  }
}

class AppModuleParams extends Equatable {
  final int provinceId;
  final int userId;

  AppModuleParams({@required this.provinceId, this.userId});

  @override
  List<Object> get props => [provinceId];
}
