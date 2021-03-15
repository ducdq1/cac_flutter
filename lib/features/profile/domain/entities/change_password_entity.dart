abstract class ChangePasswordEntity {
  String username;
  String oldPassword;
  String newPassword;

  ChangePasswordEntity({this.newPassword, this.oldPassword, this.username});

  toJson() {
    return {
      'username': this.username,
      'oldPassword': this.oldPassword,
      'newPassword': this.newPassword,
    };
  }
}
