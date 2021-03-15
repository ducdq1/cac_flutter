import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FaceIdWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              SVG_ASSETS_PATH + 'icon_faceid.svg',
              fit: BoxFit.contain,
            ),
            SizedBox(width: 6),
            Text(
              trans(LOGIN_WITH_FACE_ID),
              style: GoogleFonts.inter(
                fontSize: FONT_MIDDLE,
                color: PRIMARY_TEXT_COLOR,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
