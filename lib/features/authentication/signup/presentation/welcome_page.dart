import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PRIMARY_COLOR,
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
          icon: SvgPicture.asset(
            SVG_ASSETS_PATH + 'icon_arrow_back.svg',
            fit: BoxFit.scaleDown,
            width: 24,
            height: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 120,
                  child: SvgPicture.asset(
                    SVG_ASSETS_PATH + 'bg_welcome.svg',
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      SvgPicture.asset(
                          SVG_ASSETS_PATH + 'bg_header_welcome.svg'),
                      Positioned(
                        left: 55,
                        bottom: 0,
                        child: SvgPicture.asset(
                          SVG_ASSETS_PATH + 'icon_welcome.svg',
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 80),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 38),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trans(TITLE_HELLO),
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          trans(ACTIVATED_SUCCESSFULLY),
                          style: GoogleFonts.inter(
                            fontSize: FONT_LARGE,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 45),
                        RaisedButton(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                trans(GETTING_STARTED),
                                style: GoogleFonts.inter(
                                  fontSize: FONT_MIDDLE,
                                  color: PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/', (route) => false);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
