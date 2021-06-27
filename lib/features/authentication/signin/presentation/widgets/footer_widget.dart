import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_bloc.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_event.dart';
import 'package:citizen_app/features/authentication/signup/presentation/signup_account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  final Color color;

  FooterWidget({this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Công ty TNHH C.A.C',
                style: GoogleFonts.inter(
                  fontSize: FONT_MIDDLE,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '11 Pasteur, Hải Châu, Đà Nẵng',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _launchRegistrationURL() async {
    const url =
        'https://sso.viettelmaps.vn/auth/realms/vts-mientrung/protocol/openid-connect/auth?client_id=vtmaps&redirect_uri=https%3A%2F%2Flive.viettelmaps.vn%2Fmaps&state=f0bdb728-3bbe-40c3-8eca-d98892a90166&response_mode=fragment&response_type=code&scope=openid&nonce=00c12e5c-106d-475d-bbfe-c5167eee1df8&kc_locale=vn';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
