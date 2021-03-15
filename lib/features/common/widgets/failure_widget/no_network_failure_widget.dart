import 'package:citizen_app/core/functions/trans.dart';
import 'package:flutter/material.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'failure_widget.dart';

class NoNetworkFailureWidget extends StatelessWidget {
  final String message;
  final Function onPressed;
  const NoNetworkFailureWidget({Key key, this.message, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FailureWidget(
      message: message,
      body: SubmitButon(
        onPressed: onPressed,
        label: trans(RETRY),
      ),
    );
  }
}
