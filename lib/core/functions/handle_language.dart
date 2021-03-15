import 'package:citizen_app/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

String handleLanguage() {
  final pref = singleton<SharedPreferences>();
  String locale = ui.window.locale.languageCode;
  String result = "vi";

  result = pref.getString('languageDevice') == "en"
      ? "en"
      : pref.getString('languageDevice') == "vi"
          ? "vi"
          : locale == "en"
              ? "en"
              : "vi";
  return result;
}
