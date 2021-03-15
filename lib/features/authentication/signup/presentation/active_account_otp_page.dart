import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_bloc.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_event.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/active_account_state.dart';
import 'package:citizen_app/features/authentication/signup/presentation/welcome_page.dart';
import 'package:citizen_app/features/common/dialogs/loading_dialog.dart';
import 'package:citizen_app/features/common/widgets/buttons/outline_custom_button.dart';
import 'package:citizen_app/features/common/widgets/buttons/primary_button.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:route_transitions/route_transitions.dart';

import 'bloc/active_account_bloc.dart';
import 'bloc/active_account_event.dart';
import 'widgets/signup_account_page/header_widget.dart';

class ActiveAccountOtpPage extends StatefulWidget {
  @override
  _ActiveAccountOtpPageState createState() => _ActiveAccountOtpPageState();
}

class _ActiveAccountOtpPageState extends State<ActiveAccountOtpPage>
    implements OnButtonClickListener {
  FocusNode _focusNode;
  GlobalKey<FormState> _formKey;
  TextEditingController _controller;

  @override
  void initState() {
    _focusNode = FocusNode();
    _formKey = GlobalKey<FormState>();
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocListener<ActiveAccountBloc, ActiveAccountState>(
        listener: (_, state) {
          if (state is ActiveAccountLoadingState) {
            showLoadingDialog(context, trans(ACTIVATING_ACCOUNT));
          } else if (state is ActiveAccountSucceedState) {
            Navigator.pop(context);
            Navigator.of(context).push(
              PageRouteTransition(
                animationType: AnimationType.slide_right,
                builder: (context) => WelcomePage(),
              ),
            );
          } else if (state is ActiveAccountFaildState) {
            print(state.message);
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: PRIMARY_COLOR,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                SVG_ASSETS_PATH + 'icon_arrow_back.svg',
                fit: BoxFit.scaleDown,
                width: 24,
                height: 24,
              ),
            ),
            title: Text(
              trans(ACTIVE_ACCOUNT),
              style: GoogleFonts.inter(
                fontSize: FONT_EX_LARGE,
                height: 1.8,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 90,
                      child: SvgPicture.asset(
                        SVG_ASSETS_PATH + 'top_wave_auth_bg.svg',
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 55),
                        HeaderWidget(svgIcon: 'icon_otp.svg'),
                        SizedBox(height: 120),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 38),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputValidateCustomWidget(
                                focusNode: _focusNode,
                                controller: _controller,
                                label: trans(OTP_CODE),
                                textInputType: TextInputType.number,
                                validates: [
                                  EmptyValidate(),
                                ],
                                focusError: (FocusNode focusNode) {},
                              ),
                              RichText(
                                text: TextSpan(
                                  text: trans(PRESS),
                                  style: GoogleFonts.inter(
                                    fontSize: FONT_MIDDLE,
                                    fontWeight: FontWeight.normal,
                                    color: PRIMARY_TEXT_COLOR,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: trans(RESEND),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print('asfdds');
                                          BlocProvider.of<ActiveAccountBloc>(
                                                  context)
                                              .add(ResendOtpCodeEvent());
                                        },
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: PRIMARY_COLOR,
                                      ),
                                    ),
                                    TextSpan(
                                      text: trans(IF_HAVE_NOT_RECEIVED_OTP),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 55),
                              PrimaryButton(
                                label: trans(ACTIVATE),
                                ctx: this,
                                id: 'active-btn',
                              ),
                              SizedBox(height: 18),
                              OutlineCustomButton(
                                label: trans(TEXT_CANCEL_BUTTON),
                                ctx: this,
                                id: 'close-btn',
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  onClick(String id) {
    if (id == 'close-btn') {
      BlocProvider.of<SignInBloc>(context).add(SignInClearEvent());
      Navigator.of(context)
          .pushNamedAndRemoveUntil(ROUTER_SIGNIN, (route) => false);
    } else {
      if (_formKey.currentState.validate()) {
        final auth =
            (BlocProvider.of<AuthBloc>(context).state as AuthenticatedState)
                .auth;
        BlocProvider.of<ActiveAccountBloc>(context).add(
          ActiveAccountByOtpEvent(
            phone: '',
            otp: _controller.text.trim(),
          ),
        );
      }
    }
  }
}
