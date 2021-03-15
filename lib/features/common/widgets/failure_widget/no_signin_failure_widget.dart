import 'package:citizen_app/core/functions/functions.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'failure_widget.dart';

class NoSigninFailureWidget extends StatelessWidget {
  final String message;
  final Function onPressed;
  const NoSigninFailureWidget({Key key, this.message, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FailureWidget(
      message: message,
      body: SubmitButon(
        onPressed: onPressed,
        label: trans(TITLE_LOGIN_SCREEN),
      ),
    );
  }
}
