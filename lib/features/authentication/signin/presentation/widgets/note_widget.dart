import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_note.svg',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              trans(ONLY_CITIZENS_USING_VIETTEL),
              style: GoogleFonts.inter(
                color: SECONDARY_TEXT_COLOR,
                fontSize: FONT_MIDDLE,
                fontWeight: FontWeight.normal,
                height: 1.8,
              ),
            ),
          )
        ],
      ),
    );
  }
}
