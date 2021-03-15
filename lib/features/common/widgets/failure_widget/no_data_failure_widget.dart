import 'package:citizen_app/core/functions/trans.dart';
import 'package:flutter/material.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'failure_widget.dart';

class NoDataFailureWidget extends StatelessWidget {
  final String message;
  final String text;

  const NoDataFailureWidget({Key key, this.message, this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FailureWidget(
      message: message,
      body: Text(text ?? trans(NO_DATA),
          style:
              GoogleFonts.inter(color: PRIMARY_COLOR, fontSize: FONT_MIDDLE)),
    );
  }
}
