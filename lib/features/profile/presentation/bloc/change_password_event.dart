abstract class ChangePasswordEvent {}

class StartChangingPasswordEvent extends ChangePasswordEvent {
  String newPassword;
  String oldPassword;
  String username;

  StartChangingPasswordEvent(
      {this.newPassword, this.username, this.oldPassword});
}
