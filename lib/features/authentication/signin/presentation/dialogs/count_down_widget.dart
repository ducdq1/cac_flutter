import 'dart:async';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_bloc.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CountDownWidget extends StatefulWidget {
  final bool shouldCountDown;
  CountDownWidget({this.shouldCountDown = false});
  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  int _seconds = 59;
  bool _shouldResend = false;
  Timer _timer;

  Future _countDown() async {
    _seconds = 59;
    setState(() {
      _shouldResend = false;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_seconds == 0) {
          // BlocProvider.of<SignInBloc>(context).add(SignInClearEvent());
          setState(() {
            timer.cancel();
            _shouldResend = true;
          });
        } else {
          setState(() {
            _seconds--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    _countDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _shouldResend
          ? Center(
              child: TextButton(
                onPressed: () {
                  BlocProvider.of<SignInBloc>(context)
                      .add(SignInResendOtpEvent());
                  _countDown();
                },
                child: Text(
                  trans(RESEND_CODE),
                  style: GoogleFonts.inter(
                    color: Color(0xff0F8E70),
                    fontSize: FONT_MIDDLE,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                trans(RESEND_CODE_AFTER) + _seconds.toString() + ' s',
                style: GoogleFonts.inter(
                  color: Color(0xff0F8E70),
                  fontSize: FONT_MIDDLE,
                  height: 1.5,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
