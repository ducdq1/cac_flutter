import 'package:citizen_app/core/functions/trans.dart';
import 'package:flutter/material.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'failure_widget.dart';

class NoPermissionFailureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FailureWidget(
      body: Text(trans(NO_PERMISSION),
          style:
              GoogleFonts.inter(color: PRIMARY_COLOR, fontSize: FONT_MIDDLE)),
    );
  }
}
