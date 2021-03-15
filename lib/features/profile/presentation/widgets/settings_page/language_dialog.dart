import 'package:citizen_app/features/profile/presentation/widgets/settings_page/language_dialog_widget.dart';
import 'package:flutter/material.dart';

Future showLanguageSettingDialog(
    {BuildContext context, String languagePicked, Function func}) async {
  return await showDialog(
    context: context,
    builder: (_) =>
        LanguageDialogWidget(languagePicked: languagePicked, func: func),
  );
}
