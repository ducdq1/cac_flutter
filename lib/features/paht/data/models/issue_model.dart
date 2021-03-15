import 'dart:io';

import 'package:citizen_app/features/paht/domain/entities/entities.dart';

class IssueModel extends IssueEntity {
  IssueModel(
      {int userId,
      String address,
      String location,
      String description,
      List<File> files})
      : super(
            userId: userId,
            address: address,
            location: location,
            description: description,
            files: files);
}
