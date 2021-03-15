import 'package:citizen_app/features/profile/domain/entities/update_profile_entity.dart';

abstract class UpdateProfileRepository {
  Future updateProfile({UpdateProfileEntity profile});
  Future<UpdateProfileEntity> getProfile({int userId});
}
