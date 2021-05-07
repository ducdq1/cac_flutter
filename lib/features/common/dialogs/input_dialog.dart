import 'package:flutter/material.dart';

import 'confirm_widget.dart';
import 'input_dialog_widget.dart';

Future showInputDialog({
  BuildContext context,
  String title,
  String label,
  Icon icon,
  Function onSubmit,
}) async {
  return await showDialog(
    context: context,
    builder: (_) => InputDialog(
      icon: icon,
      label: label,
      onSubmit: onSubmit,
      title: title,
    ),
  );
}
