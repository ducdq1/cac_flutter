import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/core/functions/trans.dart';

class EmotionItemWidget extends StatelessWidget {
  final String svgIcon;
  final String label;
  final bool active;
  EmotionItemWidget({this.svgIcon, this.active, this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            SVG_ASSETS_PATH + '$svgIcon${active ? '_active' : ''}.svg',
            // color: active ? Color(0xffC2CBCE) : Color(0xffFFCA28),
          ),
          SizedBox(height: 15),
          Text(
            trans(label),
            style: GoogleFonts.inter(
              color: PRIMARY_TEXT_COLOR,
              fontSize: FONT_MIDDLE,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
