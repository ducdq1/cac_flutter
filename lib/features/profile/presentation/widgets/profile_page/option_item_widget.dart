import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';

class OptionItemWidget extends StatelessWidget {
  final String icon;
  final String label;
  final Widget page;
  final Function callback;

  OptionItemWidget({this.icon, this.label, this.page, this.callback});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (page != null) {
            Navigator.of(context).push(PageRouteTransition(
                animationType: AnimationType.slide_up,
                builder: (context) => page));
          } else {
            callback();
          }
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xffB9B9B9), width: 0.3))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Image.asset(
                  IMAGE_ASSETS_PATH + icon.split('/').last,
                  width: 32,
                  height: 32,
                  fit: BoxFit.scaleDown,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: FONT_MIDDLE,
                      color: PRIMARY_TEXT_COLOR,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(SVG_ASSETS_PATH + 'icon_arrow_right.svg')
            ],
          ),
        ),
      ),
    );
  }
}
