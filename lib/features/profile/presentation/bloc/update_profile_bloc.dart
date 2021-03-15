import 'package:citizen_app/features/profile/data/repositories/update_profile_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'update_profile_event.dart';
import 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc() : super(null);

  @override
  Stream<UpdateProfileState> mapEventToState(UpdateProfileEvent event) async* {
    if (event is FetchingProfileEvent) {
      yield FetchProfileProcessingState();
      try {
        final repo = UpdateProfileRepositoryImpl();
        final profile = await repo.getProfile(userId: event.userId);
        yield FetchProfileSucceedState(profile: profile);
      } catch (e) {
        yield FetchProfileFaildState(message: e.message);
      }
    } else if (event is UpdatingProfileEvent) {
      yield UpdateProfileProcessingState();
      try {
        final repo = UpdateProfileRepositoryImpl();
        await repo.updateProfile(profile: event.profile);
        yield UpdateProfileSucceedState();
      } catch (e) {
        yield UpdateProfileFaildState(message: e.message);
      }
    }
  }
}
