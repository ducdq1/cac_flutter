import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/validate.dart';

class EmptyValidate extends Validate<String> {
  @override
  String validate(String value) {
    if (value.trim().isEmpty) {
      return trans(REQUIRE_FIELD_INFO);
    }

    return null;
  }
}
