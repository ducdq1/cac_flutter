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
    return Padding(
      padding:
          const EdgeInsets.only(top: 30.0, left: 15, right: 15, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff0F8E70).withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Image.asset(
              ICONS_ASSETS + 'icon_da_ban.png',
              width: 62,
              height: 62,
            ),
            SizedBox(height: 20),
            Text("Liên hệ với Chúng tôi ",
                style: GoogleFonts.inter(
                  fontSize: FONT_LARGE,
                  color: PRIMARY_TEXT_COLOR,
                  fontWeight: FontWeight.w600,
                )),
            Text(
              "để được tư vấn và báo giá tốt nhất",
              style: GoogleFonts.inter(
                fontSize: FONT_LARGE,
                color: PRIMARY_TEXT_COLOR,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 15),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(ICONS_ASSETS + 'ic_call.png',
                              width: 24, height: 24),
                          SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              text: 'Phone: ',
                              style: GoogleFonts.inter(
                                color: PRIMARY_TEXT_COLOR,
                                fontSize: FONT_MIDDLE,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '0236.381.2805',
                                  style: GoogleFonts.inter(
                                    color: PRIMARY_TEXT_COLOR,
                                    fontSize: FONT_MIDDLE,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(ICONS_ASSETS + 'ic_gmail.png',
                              width: 24, height: 24),
                          SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              text: 'Email: ',
                              style: GoogleFonts.inter(
                                color: PRIMARY_TEXT_COLOR,
                                fontSize: FONT_MIDDLE,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'cac_cskh@gmail.com',
                                  style: GoogleFonts.inter(
                                    color: PRIMARY_TEXT_COLOR,
                                    fontSize: FONT_MIDDLE,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
