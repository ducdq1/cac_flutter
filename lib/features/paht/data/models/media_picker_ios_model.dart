import 'dart:io';

import 'package:equatable/equatable.dart';

class MediaPickerIOSModel extends Equatable {
  final int id;
  final String path;
  final String type;

  MediaPickerIOSModel({
    this.id,
    this.path,
    this.type,
  });

  @override
  List<Object> get props => [id, path, type];
  factory MediaPickerIOSModel.fromJson(Map<String, dynamic> json) {
    return MediaPickerIOSModel(
      id: json['id'],
      path: json['path'],
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {};
  }
}
