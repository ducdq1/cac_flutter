import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:citizen_app/features/home/presentation/pages/widgets/sos_button_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';

class ViewInfoPage extends StatefulWidget {
  @override
  _ViewInfoPageState createState() => _ViewInfoPageState();
}

class _ViewInfoPageState extends State<ViewInfoPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
      title: trans(TITLE_INFORMATION_SCREEN),
      centerTitle: true,
      body: Column(
        children: [
          SizedBox(height: 100),
          SvgPicture.asset(SVG_ASSETS_PATH + 'icon_version.svg'),
          SizedBox(height: 20),
          Text(
            trans(VERSION),
            style: GoogleFonts.inter(
              fontSize: FONT_EX_LARGE,
              color: PRIMARY_TEXT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            singleton<PackageInfo>().version.toString(),
            style: GoogleFonts.inter(
              fontSize: FONT_MIDDLE,
              color: PRIMARY_TEXT_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 150),
          Container(
            height: 0,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.only(left: 38, right: 38, top: 20, bottom: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Color.fromARGB(80, 235, 238, 240),
            ),
            child: Column(
              children: [
                Text(
                  trans(TITLE_SUPPORT_SCREEN),
                  style: GoogleFonts.inter(
                    fontSize: FONT_EX_LARGE,
                    color: PRIMARY_TEXT_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SvgPicture.asset(
                      SVG_ASSETS_PATH + 'icon_call.svg',
                    ),
                    SizedBox(width: 14),
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: GoogleFonts.inter(
                          color: PRIMARY_TEXT_COLOR,
                          fontSize: FONT_MIDDLE,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '',
                            style: GoogleFonts.inter(
                              color: PRIMARY_TEXT_COLOR,
                              fontSize: FONT_MIDDLE,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SvgPicture.asset(
                      SVG_ASSETS_PATH + 'icon_mail.svg',
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: '',
                          style: GoogleFonts.inter(
                            color: PRIMARY_TEXT_COLOR,
                            fontSize: FONT_MIDDLE,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '',
                              style: GoogleFonts.inter(
                                color: PRIMARY_TEXT_COLOR,
                                fontSize: FONT_MIDDLE,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
