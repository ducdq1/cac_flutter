import 'package:flutter/material.dart';

import 'confirm_widget.dart';
import 'input_dialog_widget.dart';

Future showInputDialog({
  BuildContext context,
  String title,
  String value,
  Icon icon,
  Function onSubmit,
  String submitTitle,
}) async {
  return await showDialog(
    context: context,
    builder: (_) => InputDialog(
      icon: icon,
      value: value,
      onSubmit: onSubmit,
      title: title,
      submitTitle: submitTitle,
    ),
  );
}
