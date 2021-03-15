import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';

class PasswordValidate implements Validate<String> {
  @override
  String validate(String value) {
    if (value.isEmpty) return trans(REQUIRE_FIELD_INFO);
    if (RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                caseSensitive: false)
            .hasMatch(value) ==
        false) {
      return trans(PASSWORD_VALIDATE);
    }
    return null;
  }
}
