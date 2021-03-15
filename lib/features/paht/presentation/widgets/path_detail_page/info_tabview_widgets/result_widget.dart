import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultWidget extends StatefulWidget {
  final String updatedTime;
  final String status;
  final Color color;
  final String description;

  ResultWidget({this.description, this.status, this.color, this.updatedTime});

  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            SVG_ASSETS_PATH + 'icon_result.svg',
          ),
          SizedBox(height: 18),
          Text(
            trans(LABEL_CONTENT_PAHT),
            style: GoogleFonts.inter(
              fontSize: FONT_EX_LARGE,
              color: PRIMARY_TEXT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_check.svg',
                color: widget.color ?? PRIMARY_COLOR,
              ),
              SizedBox(width: 9),
              Text(
                widget.status ?? trans(ACT_PRECESSED),
                style: GoogleFonts.inter(
                  color: widget.color ?? PRIMARY_COLOR,
                  fontSize: FONT_MIDDLE,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_clock.svg',
              ),
              SizedBox(width: 9),
              Text(
                widget.updatedTime ?? '12:00, 14/11/2021'.toUpperCase(),
                style: GoogleFonts.inter(
                  color: PRIMARY_TEXT_COLOR,
                  fontSize: FONT_MIDDLE,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Text(
            widget.description ?? '',
            style: GoogleFonts.inter(
              color: PRIMARY_TEXT_COLOR,
              fontSize: FONT_MIDDLE,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}
