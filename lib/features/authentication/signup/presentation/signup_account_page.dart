import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/signup/data/models/signup_model.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_bloc.dart';
import 'package:citizen_app/features/authentication/signup/presentation/bloc/signup_event.dart';
import 'package:citizen_app/features/authentication/signup/presentation/signup_personal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';

import 'widgets/group_signup_button_widget.dart';
import 'widgets/signup_account_page/form_account_widget.dart';
import 'widgets/signup_account_page/header_widget.dart';
import 'widgets/step_complete_widget.dart';
import 'package:flutter/services.dart';

class SignUpAccountPage extends StatefulWidget {
  @override
  _SignUpAccountPageState createState() => _SignUpAccountPageState();
}

class _SignUpAccountPageState extends State<SignUpAccountPage> {
  GlobalKey<FormState> _formKey;
  TextEditingController _phoneController;
  TextEditingController _passController;
  FocusNode _focusNodeError;

  void _focusError(FocusNode focusNode) {
    if (_focusNodeError == null) _focusNodeError = focusNode;
  }

  @override
  void initState() {
    _phoneController = TextEditingController();
    _passController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
            trans(TITLE_SIGNUP_ACCOUNT),
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
          child: Container(
            child: Stack(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      height: (MediaQuery.of(context).size.height - 90) * 4 / 5,
                      child: SvgPicture.asset(
                        SVG_ASSETS_PATH + 'top_wave_auth_bg.svg',
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: HeaderWidget(),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 90,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 1.2 / 4),
                      StepCompleteWidget(
                        total: 3,
                        completeIndex: -1,
                      ),
                      SizedBox(height: 30),
                      FormAccountWidget(
                        formKey: _formKey,
                        passController: _passController,
                        phoneController: _phoneController,
                        focusNodeError: _focusError,
                      ),
                      Expanded(child: SizedBox(height: 120)),
                      GroupSignUpButtonWidget(
                        formKey: _formKey,
                        router: SignUpPersonalPage(),
                        onValidate: () {
                          final tmp = SignUpModel();
                          tmp.phone = _phoneController.text.trim();
                          tmp.password = _passController.text.trim();
                          BlocProvider.of<SignUpBloc>(context)
                              .add(SignUpUpdateFieldsEvent(entity: tmp));
                        },
                        onInValidate: () {},
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }
}
