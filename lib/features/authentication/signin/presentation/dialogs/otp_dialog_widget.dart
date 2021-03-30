import 'dart:async';

import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_bloc.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_event.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_state.dart';
import 'package:citizen_app/features/authentication/signin/presentation/dialogs/count_down_widget.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

const NUMBER_OTP = 6;

class OTPDialogWidget extends StatefulWidget {
  final String phone;
  final String password;
  final bool isViettelSignIn;
  OTPDialogWidget({this.phone, this.isViettelSignIn = true, this.password});
  @override
  _OTPDialogWidgetState createState() => _OTPDialogWidgetState();
}

class _OTPDialogWidgetState extends State<OTPDialogWidget>
    implements OnButtonClickListener {
  bool _shouldCountDown = true;
  int count = 0;
  String _otpEnter;
  TextEditingController _controller;
  //StreamController<ErrorAnimationType> _errorController;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _controller = TextEditingController();
   // _errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (_, state) {
        if (state is SignInFaildState) {
          //_errorController.add(ErrorAnimationType.shake);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  trans(ENTER_OTP_CODE),
                  style: GoogleFonts.inter(
                    color: PRIMARY_TEXT_COLOR,
                    fontSize: FONT_LARGE,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 34),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                  ],
                ),
              ),
              CountDownWidget(shouldCountDown: _shouldCountDown),
              SizedBox(height: 20),
              Container(
                width: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                      label: trans(TITLE_LOGIN_SCREEN),
                      ctx: this,
                      id: 'signin-otp-id',
                    ),
                    SizedBox(height: 18),
                    OutlineCustomButton(
                      label: trans(TEXT_CANCEL_BUTTON),
                      ctx: this,
                      id: 'cancel-btn-id',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  onClick(String id) {
    if (id == 'cancel-btn-id') {
      BlocProvider.of<SignInBloc>(context).add(SignInClearEvent());
      Navigator.pop(context);
    } else if (id == 'signin-otp-id') {
      _otpEnter = _controller.text;
      if (_otpEnter.length == NUMBER_OTP) {
        if (widget.isViettelSignIn) {
          BlocProvider.of<SignInBloc>(context).add(
            SignInOtpConfirmEvent(otpCode: _otpEnter, phone: widget.phone),
          );
        } else {
          BlocProvider.of<SignInBloc>(context).add(
            SignInAccountConfirmEvent(
              otpCode: _otpEnter,
              phone: widget.phone,
              password: widget.password,
            ),
          );
        }
      }
    }
  }
}
