import 'package:citizen_app/features/paht/domain/entities/entities.dart';

class StatusModel extends StatusEntity {
  StatusModel({int id, String name}) : super(id: id, name: name);

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['statusId'],
      name: json['namePlatform'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'statusId': id,
      'namePlatform': name,
    };
  }

  @override
  String toString() => 'Status { statusId: $id, statusName: $name}';
}
