import 'package:citizen_app/features/profile/domain/entities/update_profile_entity.dart';

abstract class UpdateProfileEvent {}

class FetchingProfileEvent extends UpdateProfileEvent {
  final int userId;
  FetchingProfileEvent({this.userId});
}

class UpdatingProfileEvent extends UpdateProfileEvent {
  final UpdateProfileEntity profile;
  UpdatingProfileEvent({this.profile});
}
