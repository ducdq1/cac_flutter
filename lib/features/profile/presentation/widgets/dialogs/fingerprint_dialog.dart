import 'package:citizen_app/features/profile/presentation/widgets/dialogs/fingerprint_dialog_widget.dart';
import 'package:flutter/material.dart';

Future showFingerPrintDialog({
  BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (_) => FingerPrintDialogWidget(),
  );
}
