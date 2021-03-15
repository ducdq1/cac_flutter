import 'dart:io';

import 'package:equatable/equatable.dart';

class IssueEntity extends Equatable {
  final int userId;
  final String address;
  final String location;
  final String description;
  final List<File> files;

  IssueEntity(
      {this.userId, this.address, this.location, this.description, this.files});

  @override
  List<Object> get props => [userId, address, location, description, files];
  Map<String, dynamic> toJson() {
    return {};
  }
}
