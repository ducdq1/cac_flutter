import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_bloc.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_event.dart';
import 'package:citizen_app/features/authentication/auth/bloc/auth_state.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_bloc.dart';
import 'package:citizen_app/features/authentication/signin/presentation/bloc/signin_state.dart';
import 'package:citizen_app/features/common/dialogs/loading_dialog.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/signin_event.dart';
import 'widgets/footer_widget.dart';
import 'widgets/form_signin_widget.dart';
import 'widgets/logo_widget.dart';
import 'package:flutter/services.dart';
import 'dart:io';

const SIGIN_ACCOUNT_BTN = 'signin_account_btn';
const SIGNIN_VIETTEL_BTN = 'signin_viettel_btn';
const SIZE_ARROW_BACK_ICON = 20.0;

class SignInPage extends StatefulWidget {
  final bool isCustomer;

  SignInPage({this.isCustomer = true});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// [_formKey] helps us validate form signin
  /// [Form] has [key] property should be assigned by [_formKey]
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    /// Clear [SignInBloc] before sign-in page will be lanched
    //BlocProvider.of<SignInBloc>(context).add(SignInClearEvent());

    /// If [AuthBloc] was set before, reset its state
    final auth = BlocProvider.of<AuthBloc>(context).state;
    if (auth is AuthenticatedState) {
      BlocProvider.of<AuthBloc>(context).add(UnAuthenticatedEvent());
    }
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Thông báo'),
            content: new Text('Bạn muốn thoát ứng dụng?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  exit(0);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    final args = ModalRoute.of(context).settings.arguments;
    return BaseLayoutWidget(
        title: 'Cập nhật thông tin cá nhân',
        onPop: (){
          bool isLoginRequired = pref.getBool("isLoginRequired");

          if (isLoginRequired != null &&
              isLoginRequired == true) {
            Fluttertoast.showToast(msg: "Bạn phải đăng nhập để tiếp tục");
            return;
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
              ROUTER_CUS_HOME_PAGE, (route) => false);
        },
          body: BlocListener<SignInBloc, SignInState>(
            listener: (_, state) {
              if (state is SignInSucceedState) {
                BlocProvider.of<AuthBloc>(context)
                    .add(AuthenticatedEvent(auth: state.auth));
                if (args != null) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(args, (route) => false);
                } else {
                  if (state.isCustomer) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        ROUTER_CUS_HOME_PAGE, (route) => false);
                  } else {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }
                }
              } else if (state is SignInSsoState ||
                  state is SignInOtpConfirmState ||
                  state is SignInAccountConfirmState) {
                showLoadingDialog(context, trans(SIGNING_IN));
              } else if (state is SignInFaildState) {
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
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 20,
                child: Stack(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SvgPicture.asset(
                          SVG_ASSETS_PATH + 'bottom_wave_auth_bg.svg',
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomCenter,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: FooterWidget(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LogoWidget(),
                          SizedBox(
                            height: 30,
                          ),
                          FormSignInWidget(formKey: _formKey,isCustomerLogin: widget.isCustomer),
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: PRIMARY_COLOR,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    super.dispose();
  }
}
