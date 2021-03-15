import 'package:flutter/material.dart';

import 'confirm_widget.dart';

Future showConfirmDialog({
  BuildContext context,
  String title,
  String label,
  Icon icon,
  Function onSubmit,
}) async {
  return await showDialog(
    context: context,
    builder: (_) => ConfirmDialog(
      icon: icon,
      label: label,
      onSubmit: onSubmit,
      title: title,
    ),
  );
}
