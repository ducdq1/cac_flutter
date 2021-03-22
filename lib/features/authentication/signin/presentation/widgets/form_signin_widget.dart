import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/password_validate.dart';
import 'package:citizen_app/core/utils/validate/email_validate.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/forgot_password_page.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_bloc.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_event.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_state.dart';
import 'package:citizen_app/features/authentication/signin/presentation/dialogs/otp_dialog.dart';
import 'package:citizen_app/features/common/dialogs/loading_dialog.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:url_launcher/url_launcher.dart';

import 'group_button_widget.dart';

class FormSignInWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  FormSignInWidget({this.formKey});
  @override
  _FormSignInWidgetState createState() => _FormSignInWidgetState();
}

class _FormSignInWidgetState extends State<FormSignInWidget>
    implements OnLoadingDialogPopListener {
  FocusNode _passFocusNode;
  FocusNode _phoneFocusNode;
  TextEditingController _phoneController;
  TextEditingController _passController;
  bool _isButtonDisabled = false;
  SignInBloc _signInBloc;

  @override
  void initState() {
    _passFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _phoneController = TextEditingController();
    _passController = TextEditingController();
    _signInBloc = BlocProvider.of<SignInBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (_, state) {
        if (state is SignInAccountSucceedState) {
          Navigator.pop(context);
          showOtpDialog(
            context,
            _phoneController.text.trim(),
            _passController.text.trim(),
            false,
          ).then((value) {
            _isButtonDisabled = false;
          });
        } else if (state is SignInAccountState) {
          showLoadingDialog(context, trans(SIGNING_IN), this).then((value) {
            _isButtonDisabled = false;
          });
        }
      },
      child: Container(
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputValidateWidget(
                label: trans(LABEL_LOGIN_USER_NAME),
                limitLength: 200,
                focusNode: _phoneFocusNode,
                textInputType: TextInputType.text,
                controller: _phoneController,
                focusAction: () => FormTools.requestFocus(
                    currentFocusNode: _phoneFocusNode,
                    context: context,
                    nextFocusNode: _passFocusNode),
                validates: [
                  EmailValidate(),
                  EmptyValidate(),
                ],
              ),
              SizedBox(height: 5),
              InputValidateWidget(
                label: trans(LABEL_LOGIN_PASSWORD),
                focusNode: _passFocusNode,
                controller: _passController,
                obscureText: true,
                focusAction: () => _passFocusNode.unfocus(),
                textInputAction: TextInputAction.done,
                validates: [
                  EmptyValidate(),
                  //PasswordValidate(),
                ],
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    _launchForgetPssURL();
                  },
                  child: Text(
                    trans(LABEL_FORGET_PASSWORD),
                    style: GoogleFonts.inter(
                      fontSize: FONT_MIDDLE,
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height <= 650 ? 10 : 30,
              ),
              GroupButtonWidget(
                primaryLabel: trans(TITLE_LOGIN_SCREEN),
                secondaryLabel: trans(LOGIN_WITH_VIETTEL_MOBILE),
                isViettelSignin: false,
                primaryBtnId: 'signin_account_btn',
                secondBtnId: 'signin_viettel_navigate_btn',
                formKey: widget.formKey,
                onSubmit: () async {
                  print('disable: $_isButtonDisabled');
                  if (_isButtonDisabled == false) {
                    _isButtonDisabled = true;
                    FocusScope.of(context).unfocus();
                    _signInBloc.add(SignInAccountEvent(
                      password: _passController.text.trim(),
                      phone: _phoneController.text.trim(),
                    ));
                    // await showOtpDialog(
                    //   context,
                    //   _phoneController.text.trim(),
                    //   _passController.text.trim(),
                    //   false,
                    // );
                    // _isButtonDisabled = false;
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _launchForgetPssURL() async {
    const url = 'https://sso.viettelmaps.com.vn:8080/auth/realms/vts-mientrung/login-actions/reset-credentials?client_id=vtmaps';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  @override
  onPop() {
    _isButtonDisabled = false;
    _signInBloc.add(SignInClearEvent());
  }
}
