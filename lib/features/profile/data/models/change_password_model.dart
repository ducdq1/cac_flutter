import 'package:citizen_app/features/profile/domain/entities/change_password_entity.dart';

class ChangePasswordModel extends ChangePasswordEntity {
  ChangePasswordModel({String username, String oldPassword, String newPassword})
      : super(
            username: username,
            oldPassword: oldPassword,
            newPassword: newPassword);
}
