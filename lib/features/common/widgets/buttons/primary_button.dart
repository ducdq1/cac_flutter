import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

abstract class OnButtonClickListener {
  onClick(String id);
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final String id;
  final State ctx;

  PrimaryButton({@required this.label, this.id, this.ctx});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
          color: PRIMARY_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
          ),
          onPressed: () {
            try {
              (ctx as OnButtonClickListener).onClick(id);
            } catch (e) {
              throw e;
            }
          },
          child: AutoSizeText(
            label,
            style: GoogleFonts.inter(
              fontSize: FONT_EX_SMALL,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: FONT_EX_SMALL,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }
}
