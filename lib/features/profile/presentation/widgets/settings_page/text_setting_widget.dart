import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TextSettingWidget extends StatefulWidget {
  final String icon;
  final String label;
  final String value;

  TextSettingWidget({this.icon, this.label, this.value});
  @override
  _TextSettingWidgetState createState() => _TextSettingWidgetState();
}

class _TextSettingWidgetState extends State<TextSettingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xffB9B9B9), width: 0.3))),
      child: Row(
        children: [
          SvgPicture.asset(
            SVG_ASSETS_PATH + widget.icon,
          ),
          SizedBox(width: 17),
          Expanded(
            child: Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: FONT_MIDDLE,
                fontWeight: FontWeight.normal,
                color: PRIMARY_TEXT_COLOR,
              ),
            ),
          ),
          Text(
            widget.value,
            style: GoogleFonts.inter(
              fontSize: FONT_MIDDLE,
              fontWeight: FontWeight.bold,
              color: PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}
