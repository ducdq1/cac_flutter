import 'package:equatable/equatable.dart';

class StatusEntity extends Equatable {
  final int id;
  final String name;

  StatusEntity({this.id, this.name});

  @override
  List<Object> get props => [id, name];

  Map<String, dynamic> toJson() {
    return {};
  }
}
