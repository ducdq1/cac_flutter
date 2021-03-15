import 'package:citizen_app/features/profile/data/models/change_password_model.dart';
import 'package:citizen_app/features/profile/data/repositories/change_password_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(null);

  @override
  Stream<ChangePasswordState> mapEventToState(
      ChangePasswordEvent event) async* {
    if (event is StartChangingPasswordEvent) {
      try {
        yield ChangePasswordProcessingState();
        final repo = ChangePasswordRepositoryImpl();
        final changePasswordEntity = ChangePasswordModel();
        changePasswordEntity.newPassword = event.newPassword;
        changePasswordEntity.oldPassword = event.oldPassword;
        changePasswordEntity.username = event.username;
        print(changePasswordEntity.toJson());
        await repo.changePassword(changePasswordEntity: changePasswordEntity);
        yield ChangePasswordSucceedState();
      } catch (e) {
        yield ChangePasswordFaildState(message: e.message);
      }
    }
  }
}
