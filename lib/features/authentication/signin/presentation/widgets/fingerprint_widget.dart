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
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';

class FingerPrintWidget extends StatefulWidget {
  FingerPrintWidget({Key key}) : super(key: key);

  @override
  _FingerPrintWidgetState createState() => _FingerPrintWidgetState();
}

class _FingerPrintWidgetState extends State<FingerPrintWidget> {
  final LocalAuthentication auth = LocalAuthentication();
  final pref = singleton<SharedPreferences>();
  bool _canCheckBiometric;
  List<BiometricType> _availableBiometrics;
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
    _getAvailableBiometric();
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      IOSAuthMessages iosStrings = IOSAuthMessages(
        cancelButton: trans(CANCEL),
        goToSettingsButton: trans(TITLE_SETTING_SCREEN),
        goToSettingsDescription: trans(REQUIRE_SET_UP_TOUCH_ID),
        lockOut: trans(ENABLE_TOUCH_ID),
      );
      AndroidAuthMessages androidStrings = AndroidAuthMessages(
          cancelButton: trans(CANCEL),
          goToSettingsButton: trans(TITLE_SETTING_SCREEN),
          goToSettingsDescription: trans(REQUIRE_SET_UP_TOUCH_ID),
          fingerprintHint: '',
          fingerprintNotRecognized: trans(FINGERPRINT_NOT_RECOGNIZED),
          fingerprintSuccess: trans(FINGERPRINT_RECOGNIZED),
          fingerprintRequiredTitle: trans(FINGERPRINT_REQUIRED),
          signInTitle: trans(FINGERPRINT_AUTHENTICATION));

      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: trans(SCAN_FP_TO_AUTHENTICATION),
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: androidStrings,
        iOSAuthStrings: iosStrings,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      //!Thêm xử lý nếu vân tay hợp lệ ở đây
      autherized =
          authenticated ? "Autherized success" : "Failed to authenticate";
      print(autherized);
    });
    if (authenticated) {
      await pref.setString('auth', pref.getString('authTemp'));
      await pref.setString('token', pref.getString('tokenTemp'));
      BlocProvider.of<AuthBloc>(context).add(UnknownAuthenticateEvent());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return pref.getBool('fingerprint') == true
        ? TextButton(
            onPressed: () async {
              await _authenticate();
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
