import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/core/utils/form_tools/form_tools.dart';
import 'package:citizen_app/core/utils/validate/empty_validate.dart';
import 'package:citizen_app/core/utils/validate/password_validate.dart';
import 'package:citizen_app/core/utils/validate/email_validate.dart';
import 'package:citizen_app/core/utils/validate/phone_validate.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/forgot_password_page.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_bloc.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_event.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_state.dart';
import 'package:citizen_app/features/authentication/signin/presentation/dialogs/otp_dialog.dart';
import 'package:citizen_app/features/common/dialogs/loading_dialog.dart';
import 'package:citizen_app/features/common/widgets/inputs/input_validate_widget.dart';
import 'package:citizen_app/features/profile/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:citizen_app/features/authentication/signin/presentation/widgets/cus_group_widget.dart';

import 'group_button_widget.dart';

class FormSignInWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isCustomerLogin;
  FormSignInWidget({this.formKey,this.isCustomerLogin = true});
  @override
  _FormSignInWidgetState createState() => _FormSignInWidgetState();
}

class _FormSignInWidgetState extends State<FormSignInWidget>
    implements OnLoadingDialogPopListener {
  FocusNode _passFocusNode;
  FocusNode _phoneFocusNode;
  FocusNode _inviterFocusNode;
  TextEditingController _phoneController;
  TextEditingController _passController;
  TextEditingController _inviterController;

  bool _isButtonDisabled = false;
  SignInBloc _signInBloc;
  bool isCustomer = true;
  int cusGroup = -1;
  @override
  void initState() {
     isCustomer = widget.isCustomerLogin;
    _passFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _inviterFocusNode = FocusNode();
    _phoneController = TextEditingController();
    _passController = TextEditingController();
    _inviterController = TextEditingController();
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
            mainAxisSize : MainAxisSize.min,
            children: [
              InputValidateWidget(
                label: isCustomer ? 'S??? ??i???n tho???i' :trans(LABEL_LOGIN_USER_NAME),
                limitLength: 200,
                focusNode: _phoneFocusNode,
                textInputType: isCustomer? TextInputType.phone: TextInputType.text,
                controller: _phoneController,
                focusAction: () => FormTools.requestFocus(
                    currentFocusNode: _phoneFocusNode,
                    context: context,
                    nextFocusNode: _passFocusNode),
                validates: [
                  isCustomer ? PhoneValidate() : EmptyValidate(), EmptyValidate(),
                ],
              ),
              SizedBox(height: 0),
              InputValidateWidget(
                label:  isCustomer ? 'H??? v?? t??n' : trans(LABEL_LOGIN_PASSWORD),
                focusNode: _passFocusNode,
                controller: _passController,
                obscureText: !isCustomer,
                focusAction: () => _passFocusNode.unfocus(),
                textInputAction: isCustomer ? TextInputAction.next : TextInputAction.done,
                validates: [
                  EmptyValidate(),
                  //PasswordValidate(),
                ],
              ),
             isCustomer ? Padding(
                padding: const EdgeInsets.only(top:0.0),
                child: InputValidateWidget(
                  label:   'Ng?????i gi???i thi???u',
                  focusNode: _inviterFocusNode,
                  controller: _inviterController,
                  focusAction: () => _inviterFocusNode.unfocus(),
                  textInputAction: TextInputAction.done,
                  obscureText: !isCustomer,
                  validates: [
                    //EmptyValidate(),
                    //PasswordValidate(),
                  ],
                ),
              ) : SizedBox(),

              isCustomer ?
                  CusGroupWidget(onChange: (value) {
                    cusGroup = value;
                  }) : SizedBox(),
              SizedBox(
                height:   10 ,
              ),
              GroupButtonWidget(
                primaryLabel: isCustomer ? 'C???p nh???t' : '????ng nh???p',
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
                        isCustomer : isCustomer,
                      inveter: _inviterController.text.trim(),
                      cusGroup: cusGroup
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
              ),

              SizedBox(
                height: isCustomer ? 0: 30,
              ),

              isCustomer ? SizedBox(height: 0,) : Center(
                child: InkWell(
                  onTap:(){
                    Navigator.of(context).push(PageRouteTransition(
                        animationType: AnimationType.slide_up,
                        builder: (context) => SettingsPage()));
                  },
                  child: Text(
                    'C??i ?????t',
                    style: GoogleFonts.inter(
                      fontSize: FONT_MIDDLE,
                      color:  Colors.red ,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Center(
                child: InkWell(
                  onTap:(){
                    setState(() {
                      isCustomer = !isCustomer;
                    });
                  },
                  child: Text(
                    isCustomer ? 'D??nh cho nh??n vi??n' : 'D??nh cho kh??ch h??ng',
                    style: GoogleFonts.inter(
                      fontSize: FONT_MIDDLE,
                      color:  Colors.indigo ,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),



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
