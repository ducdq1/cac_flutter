import 'package:citizen_app/app_localizations.dart';
import 'package:flutter/material.dart';

String trans(String key) {
  return AppLocalizations.instance.translate(key);
}

//Dùng để reload lại trang khi chuyển ngôn ngữ
String transWithContext(String key, BuildContext context) {
  return AppLocalizations.of(context).translate(key);
}
