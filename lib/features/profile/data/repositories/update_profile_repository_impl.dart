import 'package:citizen_app/features/profile/data/data_sources/update_profile_data_source.dart';
import 'package:citizen_app/features/profile/domain/entities/update_profile_entity.dart';
import 'package:citizen_app/features/profile/domain/repositories/update_profile_repository.dart';
import 'package:citizen_app/injection_container.dart';

class UpdateProfileRepositoryImpl implements UpdateProfileRepository {
  UpdateProfileDataSource dataSource;

  UpdateProfileRepositoryImpl() {
    dataSource = UpdateProfileDataSourceImpl(client: singleton());
  }

  @override
  Future<UpdateProfileEntity> getProfile({int userId}) async {
    return await dataSource.fetchUser(userId: userId);
  }

  @override
  Future updateProfile({UpdateProfileEntity profile}) async {
    return await dataSource.update(profile);
  }
}
