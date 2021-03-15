import 'package:citizen_app/features/profile/domain/entities/update_profile_entity.dart';

abstract class UpdateProfileState {}

class FetchProfileProcessingState extends UpdateProfileState {
  final int userId;
  FetchProfileProcessingState({this.userId});
}

class FetchProfileSucceedState extends UpdateProfileState {
  final UpdateProfileEntity profile;
  FetchProfileSucceedState({this.profile});
}

class FetchProfileFaildState extends UpdateProfileState {
  final String message;
  FetchProfileFaildState({this.message});
}

class UpdateProfileProcessingState extends UpdateProfileState {
  final UpdateProfileEntity profile;
  UpdateProfileProcessingState({this.profile});
}

class UpdateProfileSucceedState extends UpdateProfileState {}

class UpdateProfileFaildState extends UpdateProfileState {
  final String message;
  UpdateProfileFaildState({this.message});
}
