import 'package:equatable/equatable.dart';

class BusinessHourEntity extends Equatable {
  String openTime;
  String closeTime;
  int day;
  int status;

  BusinessHourEntity({this.openTime, this.closeTime, this.day, this.status});

  @override
  List<Object> get props => [openTime, closeTime, day, status];

  Map<String, dynamic> toJson() {
    return {
      "openTime": openTime,
      "closeTime": closeTime,
      "day": day,
      "status": status
    };
  }
}
