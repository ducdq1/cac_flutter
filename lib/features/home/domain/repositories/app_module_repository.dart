import 'package:citizen_app/features/home/domain/entities/entities.dart';

abstract class AppModuleRepository {
  Future<AppModuleEntity> getAppModules({int provinceId, int userId});
}
