import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/bloc/forgot_password_state.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/widgets/form_reset_password_widget.dart';
import 'package:citizen_app/features/authentication/forgot_password/presentation/widgets/form_secret_code_widget.dart';
import 'package:citizen_app/features/authentication/signup/presentation/widgets/signup_account_page/header_widget.dart';
import 'package:citizen_app/features/common/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';

class ForgotPasswordPage extends StatefulWidget {
  final isResetPasswordPage;
  ForgotPasswordPage({this.isResetPasswordPage = false});
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (_, state) {
        if (state is FetchSecretCodeProcessingState) {
          showLoadingDialog(context, trans(GETTING_SECRET_CODE));
        } else if (state is FetchSecretCodeSucceedState) {
          Navigator.pop(context);
          Navigator.of(context).push(
            PageRouteTransition(
              animationType: AnimationType.fade,
              builder: (context) =>
                  ForgotPasswordPage(isResetPasswordPage: true),
            ),
          );
        } else if (state is FetchSecretCodeFaildState ||
            state is ResetPasswordFaildState) {
          final message = (state is FetchSecretCodeFaildState)
              ? state.message
              : (state as ResetPasswordFaildState).message;
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else if (state is ResetPasswordProcessingState) {
          showLoadingDialog(context, trans(RESETTING_PASSWORD));
        } else if (state is ResetPasswordSucceedState) {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
            trans(LABEL_FORGET_PASSWORD),
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
            color: Colors.white,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 90,
                  child: SvgPicture.asset(
                    SVG_ASSETS_PATH + 'top_wave_auth_bg.svg',
                    fit: BoxFit.fitWidth,
                    // alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 55),
                    HeaderWidget(svgIcon: 'icon_lock.svg'),
                    SizedBox(height: 145),
                    widget.isResetPasswordPage
                        ? FormResetPasswordWidget()
                        : FormSecretCodeWidget(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
