import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_event.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';

class FingerPrintWidget extends StatefulWidget {
  FingerPrintWidget({Key key}) : super(key: key);

  @override
  _FingerPrintWidgetState createState() => _FingerPrintWidgetState();
}

class _FingerPrintWidgetState extends State<FingerPrintWidget> {
  final pref = singleton<SharedPreferences>();
  bool _canCheckBiometric;
  String autherized = "Not autherized";

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }


  @override
  Widget build(BuildContext context) {
    return pref.getBool('fingerprint') == true
        ? TextButton(
            onPressed: () async {
            },
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    SVG_ASSETS_PATH + 'icon_fingerprint.svg',
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 6),
                  Text(
                    trans(LOGIN_WITH_FINGERPRINT),
                    style: GoogleFonts.inter(
                      fontSize: FONT_MIDDLE,
                      color: PRIMARY_TEXT_COLOR,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox();
  }
}
