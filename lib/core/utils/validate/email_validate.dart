import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';

class EmailValidate extends Validate<String> {
  @override
  String validate(String value) {
    if (value.trim().isEmpty) return null;

    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value) ==
        false) {
      return trans(EMAIL_VALIDATE_WRONG_FORMAT);
    }
    return null;
  }
}
