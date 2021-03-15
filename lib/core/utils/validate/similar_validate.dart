import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';
import 'package:flutter/cupertino.dart';

class SimilarValidate implements Validate<String> {
  final TextEditingController controller;

  SimilarValidate({this.controller});

  @override
  String validate(String value) {
    if (value.trim().isEmpty) return trans(REQUIRE_FIELD_INFO);
    if (value != controller.text) return trans(PASSWORD_INCORRECT);
    return null;
  }
}
