import 'package:citizen_app/features/profile/domain/entities/change_password_entity.dart';

abstract class ChangePasswordRepository {
  Future changePassword({ChangePasswordEntity changePasswordEntity});
}
