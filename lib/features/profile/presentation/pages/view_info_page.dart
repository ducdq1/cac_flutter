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
import 'package:url_launcher/url_launcher.dart';

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
          color: Color(0xffF0F2FC),
          //Colors.grey.shade300,//(0xff0F8E70).withOpacity(0.4),
          border: Border.all(color: Color(0xffE6EAFF), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Image.asset(
              IMAGE_ASSETS_PATH + 'cac_logo1.png',
              width: 180,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30, top: 30),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(ICONS_ASSETS + 'icon_address.png',
                              width: 24, height: 24),
                          SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: '?????a ch???: ',
                                style: GoogleFonts.inter(
                                  color: PRIMARY_TEXT_COLOR,
                                  fontSize: FONT_MIDDLE,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '11 Pasteur, H???i Ch??u, ???? N???ng',
                                    style: GoogleFonts.inter(
                                      color: PRIMARY_TEXT_COLOR,
                                      fontSize: FONT_MIDDLE,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
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
                          Image.asset(ICONS_ASSETS + 'icon_phone.png',
                              width: 24, height: 24),
                          SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              text: '??i???n tho???i: ',
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
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Image.asset(ICONS_ASSETS + 'ic_gmail.png',
                      //         width: 24, height: 24),
                      //     SizedBox(width: 10),
                      //     RichText(
                      //       text: TextSpan(
                      //         text: 'Email: ',
                      //         style: GoogleFonts.inter(
                      //           color: PRIMARY_TEXT_COLOR,
                      //           fontSize: FONT_MIDDLE,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //         children: <TextSpan>[
                      //           TextSpan(
                      //             text: 'cac_cskh@gmail.com',
                      //             style: GoogleFonts.inter(
                      //               color: PRIMARY_TEXT_COLOR,
                      //               fontSize: FONT_MIDDLE,
                      //               fontWeight: FontWeight.normal,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        splashColor: Color(0xffF1FBEE),
                        highlightColor: Color(0xffF1FBEF),
                        onTap: () async {
                          print('ok ok ok ');
                          await canLaunch(
                              'https://www.facebook.com/G???ch-v??-Thi???t-B???-N???i-Th???t-CAC-????-N???ng-104247451488013')
                              ? await launch(
                              'https://www.facebook.com/G???ch-v??-Thi???t-B???-N???i-Th???t-CAC-????-N???ng-104247451488013')
                              : throw 'Could not launch';
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(ICONS_ASSETS + 'ic_facebook.png',
                                width: 28, height: 28),
                            SizedBox(width: 7),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Facebook: ',
                                  style: GoogleFonts.inter(
                                    color: PRIMARY_TEXT_COLOR,
                                    fontSize: FONT_MIDDLE,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'facebook.com/G???ch-v??-Thi???t-B???-N???i-Th???t-CAC-????-N???ng',
                                      style: GoogleFonts.inter(
                                        color: PRIMARY_TEXT_COLOR,
                                        fontSize: FONT_MIDDLE,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
