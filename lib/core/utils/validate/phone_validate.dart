import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';

class PhoneValidate extends Validate<String> {
  @override
  String validate(String value) {
    Pattern pattern = r'^0[1-9][0-9]+[0-9]{7,8}$';
    RegExp regex = new RegExp(pattern);
    if (value.trim().isNotEmpty && !regex.hasMatch(value)) {
      return trans(PHONE_VALIDATE_WRONG_FORMAT);
    } else
      return null;
  }
}
