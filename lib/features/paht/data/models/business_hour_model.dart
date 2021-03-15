import 'package:citizen_app/features/paht/domain/entities/business_hour_entity.dart';

class BusinessHourModel extends BusinessHourEntity {
  BusinessHourModel({String openTime, String closeTime, int day, int status})
      : super(openTime: closeTime,closeTime: closeTime, day: day,status:  status);

  factory BusinessHourModel.fromJson(Map json) {
    return BusinessHourModel(
      openTime: json['openTime'],
      closeTime:  json['closeTime'],
      day:  json['day'],
      status:  json['status'],
    );
  }

  @override
  String toString() => 'BusinessHour { openTime: $openTime, closeTime: $closeTime, day: $day, status:$status}';
}
