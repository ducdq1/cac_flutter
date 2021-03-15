import 'package:citizen_app/features/profile/data/data_sources/change_password_data_source.dart';
import 'package:citizen_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:citizen_app/features/profile/domain/repositories/change_password_repository.dart';
import 'package:citizen_app/injection_container.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {

  ChangePasswordDataSource dataSource;

  ChangePasswordRepositoryImpl() {
    dataSource = ChangePasswordDataSourceImpl(client: singleton());
  }

  @override
  Future changePassword({ChangePasswordEntity changePasswordEntity}) async {
    return await this.dataSource.change(changePasswordEntity);
  }
}