import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequiredLabelWidget extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Color color;

  RequiredLabelWidget(
      {this.label, this.isRequired = true, this.color = PRIMARY_TEXT_COLOR});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: FONT_MIDDLE,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          isRequired
              ? Text(
                  " *",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: FONT_MIDDLE,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
