import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';

class IDCodeValidate extends Validate<String> {
  @override
  String validate(String value) {
    if (value == null || value.trim().isEmpty)
      return trans(ID_NUMBER_VALIDATE_EMPTY);
    if (RegExp(r'^\d+$').hasMatch(value) == false)
      return trans(ID_NUMBER_VALIDATE_WRONG_FORMAT);
    return null;
  }
}
